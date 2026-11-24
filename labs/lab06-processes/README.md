# Lab 6 — Live processes and memory pressure

Pair: Bauyrzhan Duisenbay
Date: 2026-11-24
Guests: Ubuntu Server 24.04 (VirtualBox, 3.3 GiB RAM / 2.0 GiB swap) / Windows 11 (VirtualBox, 4 GB RAM)

## Part 1 — One process, three tools

Process chosen: `VBoxService.exe` (Windows) / `VBoxService` (Ubuntu)
Why: It is pre-installed as part of VirtualBox Guest Additions on both the Windows and Ubuntu guests, allowing direct comparison of the same background service across Task Manager, Process Explorer, and `htop` / `ps`.

| Metric | Task Manager | Process Explorer | htop / ps |
| --- | --- | --- | --- |
| PID | 1696 | 1696 | 1654 |
| Parent (name and PID) | (not shown) | services.exe (932) | systemd / init (PPID: 1; user: root) |
| "Memory" as shown by default | 820K | 812K | 3832K (0.1%) |
| Private memory | 820K | Private Bytes: 2392K / WS Private: 812K | N/A directly (RES - SHR ~460K) |
| Working set / RES | 9164K | 9172K | 3832K |
| Virtual size | 2360K | Private Bytes: 2392K / Virtual Size: 2,151,779,408K | 349M |
| Handles / file descriptors | 194 | 196 | 6 |
| Threads | 13 | 14 | 9 |

### Where the tools disagree

- **Parent process visibility:** Windows Task Manager’s **Details** tab does not display the parent process, whereas Process Explorer identifies `services.exe (932)` as the parent of `VBoxService.exe` (PID `1696`) in the process tree and Image tab, and `htop` / `ps` report `PPID` (`1`) and user (`root`) on Ubuntu.
- **Default "Memory" vs. Working Set & Private Memory:** Task Manager’s default **Memory** column (`820K`) reports the private working set (`820K`), while its **Working set (memory)** column (`9164K`) and Process Explorer’s **Working Set** (`9172K`) are much larger because they include shared DLL pages. On Ubuntu, `htop` reports `RES` (`3832K`) as its default memory figure, which includes shared libraries (`SHR: 3372K`), leaving ~`460K` (`RES - SHR`) of non-shared resident memory.
- **Commit Size / Private Bytes vs. Virtual Size:** Task Manager’s **Commit size** (`2360K`) aligns closely with Process Explorer’s **Private Bytes** (`2392K`), whereas Process Explorer’s **Virtual Size** (`2,151,779,408K`) and `htop`’s **VIRT** (`349M`) represent total reserved/mapped virtual address space rather than physical RAM currently in use.

## Part 2 — Memory pressure

Guest RAM: 3.3 GiB | Swap: 2.0 GiB

### Steps

1. Check baseline RAM and swap:
   ```bash
   free -h
   swapon --show
   ```
2. Start continuous recording in a second terminal:
   ```bash
   cd ~ && mkdir -p lab06 && cd lab06
   { echo "=== BEFORE $(date) ==="; free -h; } > memory-pressure.txt
   while true; do echo "=== $(date +%T) ==="; free -h; sleep 3; done | tee -a memory-pressure.txt
   ```
3. Run memory pressure stages in the first terminal (escalating up to `180%` to exhaust swap and trigger the OOM killer):
   ```bash
   stress-ng --vm 2 --vm-bytes 70% --timeout 60s
   stress-ng --vm 2 --vm-bytes 90% --timeout 60s
   stress-ng --vm 2 --vm-bytes 120% --timeout 90s
   stress-ng --vm 2 --vm-bytes 180% --timeout 60s
   ```
4. Stop recording (`Ctrl+C`) and append the final state:
   ```bash
   { echo "=== AFTER $(date) ==="; free -h; } >> memory-pressure.txt
   ```
5. Extract kernel OOM logs:
   ```bash
   journalctl -k --since "30 min ago" | grep -i -E -B3 -A8 "out of memory|oom-kill" > kernel-log-extract.txt
   ```

### Results

| Metric | Before | During (worst) | After |
| --- | --- | --- | --- |
| Available | 2.9Gi (`14:16:57`) | 5.5Mi (`14:19:32`) | 3.0Gi (`14:20:17`) |
| Swap used | 77Mi (`14:16:57`) | 2.0Gi (`14:18:47`, `14:19:10`) | 80Mi (`14:20:17`) |

### What happened

- **Available memory drop (14:18:11 – 14:19:32):** Available memory remained steady at `2.9Gi` from `14:17:01` through `14:18:08`. Once heavy allocation started at `14:18:11`, available RAM fell sharply to `72Mi`, dropped to `43Mi` at `14:18:37` and `8.9Mi` at `14:19:14`, hit its lowest point of `5.5Mi` at `14:19:32`, and recovered to `3.0Gi` by `14:19:46`.
- **Swap growth (14:18:11 – 14:19:10):** Swap usage rose from `77Mi` (`14:16:57`) to `463Mi` at `14:18:11`, crossed `1.2Gi` at `14:18:15`, and peaked at `2.0Gi` (virtually full swap, with only `40Mi` free at `14:18:47` and `112Ki` free at `14:19:10`) before dropping back to `80Mi` once the workload ended.
- **Responsiveness (14:18:18 – 14:19:38):** Under peak memory and swap pressure, the 3-second `free -h` loop intervals stretched to 4–6 seconds (e.g., `14:19:32` to `14:19:38`), and the kernel logged workqueue CPU-hogging warnings (`blk_mq_run_work_fn` and `e1000_watchdog`).
- **Process outcome (14:18:18 – 14:19:46):** The Linux OOM killer repeatedly terminated `stress-ng-vm` worker processes between `14:18:18` and `14:19:24` while `stress-ng` respawned replacements, until the workload finished around `14:19:46` and available memory returned to `3.0Gi`.

### What the kernel did

```text
Nov 24 14:18:18 lab01-bauyrzhan kernel: oom-kill:constraint=CONSTRAINT_NONE,nodemask=(null),cpuset=/,mems_allowed=0,global_oom,task_memcg=/user.slice/user-1000.slice/session-3.scope,task=stress-ng-vm,pid=2750,uid=1000
Nov 24 14:18:18 lab01-bauyrzhan kernel: Out of memory: Killed process 2750 (stress-ng-vm) total-vm:2818536kB, anon-rss:1649492kB, file-rss:520kB, shmem-rss:32kB, UID:1000 pgtables:5320kB oom_score_adj:1000
```

Explanation: When physical RAM and swap were nearly exhausted, the Linux kernel invoked the OOM killer and terminated `stress-ng-vm` worker processes—starting with PID `2750` at `14:18:18` (`total-vm:2818536kB`, `anon-rss:1649492kB`, `oom_score_adj:1000`) and continuing across subsequent workers (including PIDs `2751`, `2760`, `2764`, `2771`, `2778`, `2782`, `2786`, `2793`, `2797`, `2801`, `2805`, `2809`, `2813`, `2820`, and `2824`) through `14:19:24`. The kernel selected these processes because they held the largest anonymous resident memory footprints (`anon-rss`) and carried `oom_score_adj:1000`. The first kill at `14:18:18` matches `memory-pressure.txt` directly, occurring right as available RAM plunged to `54Mi`–`69Mi` and swap usage climbed past `1.2Gi` (`14:18:15`–`14:18:19`).

### Windows

Command run in PowerShell:
```powershell
Get-WinEvent -FilterHashtable @{LogName='System'; ProviderName='Microsoft-Windows-Resource-Exhaustion-Detector'} -MaxEvents 5 | Format-List TimeCreated, Id, Message
```

Result:
```text
Get-WinEvent : No events were found that match the specified selection criteria.
At line:1 char:1
+ Get-WinEvent -FilterHashtable @{LogName='System'; ProviderName='Micro ...
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : ObjectNotFound: (:) [Get-WinEvent], Exception
    + FullyQualifiedErrorId : NoMatchingEventsFound,Microsoft.PowerShell.Commands.GetWinEventCommand
```

Explanation: Because the Windows guest never ran out of virtual commit memory, no matching events exist in the System log. Unlike Linux—which uses the kernel OOM killer to abruptly terminate a high-memory process to reclaim RAM—Windows warns on low memory, fails new allocations, and writes **Event ID 2004** from `Microsoft-Windows-Resource-Exhaustion-Detector` listing the top memory-consuming processes when commit charge approaches exhaustion.

## What did not work the first time

- Running `ls /proc/1654/fd` without `sudo` failed with `Permission denied` because `VBoxService` runs as `root`; switching to `sudo ls /proc/1654/fd | wc -l` resolved it.
- In `htop` 3.x, enabling `PPID` required navigating to **Setup (`F2`) -> Screens -> Main** rather than a top-level **Columns** menu, and `ps -o pid,ppid,user,rss,vsz,nlwp,cmd -p 1654` was used to confirm the exact counters.
- Lower `stress-ng` memory percentages were absorbed by the `2.0 GiB` swap space without triggering an OOM kill, so raising `--vm-bytes` to `180%` was necessary to exhaust swap and capture `oom-kill` entries in `journalctl -k`.

## Evidence

- [evidence/task-manager.png](evidence/task-manager.png)
- [evidence/process-explorer.png](evidence/process-explorer.png)
- [evidence/htop.png](evidence/htop.png)
- [evidence/memory-pressure.txt](evidence/memory-pressure.txt)
- [evidence/kernel-log-extract.txt](evidence/kernel-log-extract.txt)
