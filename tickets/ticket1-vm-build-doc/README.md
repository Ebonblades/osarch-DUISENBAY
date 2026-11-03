# Ticket 1 – New developer starts Monday, needs a test machine

## 1. What was asked
From: Aigerim T. (Office Manager)
Subject: test machine for new dev
Hi, we have someone starting on Monday and he needs a test computer set up. Nothing special, just so he can try things without breaking anything. Can you write down how to do it so I can do the next one myself? Thanks

## 2. What was actually needed
Aigerim’s request says "nothing special" because she is an office manager, not a systems engineer or developer. She does not know what tools, operating systems, or safety barriers a software developer requires to test code without impacting company infrastructure. Setting up a physical secondary laptop is unnecessary and costly; instead, the developer needs an isolated virtual environment hosted on their primary workstation.

**Where the request is incomplete or wrong:**
* **"Nothing special":** A modern developer needs both a headless Linux server environment (standard backend deployment target) and a Windows client environment to verify cross-platform functionality, network services, and client-server communication.
* **"Without breaking anything":** Running experiments directly on the host operating system risks corrupting local tools, registries, and configuration files. Hypervisor-based virtual machines provide hardware abstraction and isolation, ensuring that crashes, malformed configurations, or corrupted dependencies inside the guest cannot damage the host OS. Furthermore, when the developer inevitably breaks the test system, they must be able to restore it in seconds without reinstalling from scratch—which requires taking clean, post-install snapshots.
* **Missing hardware context:** The ticket specifies no hardware limits (RAM, CPU cores, storage capacity). Virtual machine resource sizing must be strictly calibrated against physical host capacity to avoid host exhaustion.
* **Missing network scope:** The ticket does not state whether the test environment requires internet access or whether the guest systems must communicate with each other. Developers need internet access to pull packages and dependencies, as well as local interconnectivity for client-server testing.
* **Licensing compliance:** Because Aigerim will replicate this setup herself, all tools, hypervisors, and operating system images must be completely free and legal for enterprise/commercial use so she does not inadvertently introduce pirated images or trigger enterprise licensing audits.

**What I would have asked Aigerim:**
1. What are the exact hardware specifications (total RAM, CPU cores, available SSD storage) of the workstation the developer will use?
2. Which specific operating systems and software stack will the new developer be testing?
3. Does the test workflow require the guest machines to communicate with each other over a shared local subnet, and do they require outbound internet access?

**What I assumed instead:**
1. **Workstation Hardware:** The host workstation matches my physical Windows laptop: 16 GB of RAM, 24 CPU cores, and at least 100 GB of free SSD space.
2. **Operating Systems:** Ubuntu Server 24.04 LTS (amd64) provides the standard Linux server target, and Microsoft Windows 11 Enterprise (90-day Evaluation) provides the client OS legally and without cost.
3. **Hypervisor & Licensing:** Oracle VirtualBox 7.x base package is selected under the GNU General Public License (GPLv3). The proprietary VirtualBox Extension Pack is excluded to avoid commercial licensing violations.
4. **Networking:** Both guest machines require mutual network visibility and outbound internet access. A VirtualBox NAT Network (`NatNetwork`) provides a private internal subnet (`10.0.2.0/24`) with outbound host NAT, avoiding campus Wi-Fi MAC filtering that blocks bridged adapters.

**Resource Calculation (Host: 16 GB RAM, 24 Cores):**
* **Memory:** The physical Windows host consumes approximately 6 GB of RAM at idle. Allocating 4 GB (4096 MB) to the Ubuntu Server VM and 4 GB (4096 MB) to the Windows 11 VM consumes 8 GB combined. This leaves $16\text{ GB} - 6\text{ GB} - 8\text{ GB} = 2\text{ GB}$ of unallocated memory headroom for host stability, background processes, and buffer cache, preventing physical disk swapping.
* **CPU:** Allocating 2 vCPUs to Ubuntu Server and 4 vCPUs to Windows 11 uses a total of 6 vCPUs. This uses 25% of the host’s 24 physical cores, remaining well under the recommended 50% hypervisor threshold (12 cores) and leaving 18 cores for the host OS.
* **Storage:** Both disks use thin provisioning (dynamically allocated VDI). Ubuntu is allocated a maximum of 25 GB and Windows 11 is allocated 65 GB (satisfying the 64 GB Windows 11 hardware minimum). Because thin disks grow on demand, the initial installation footprint is approximately 20–25 GB total on the host drive.

**Non-Default Settings Table:**

| Setting | Default | Mine | Why |
| :--- | :--- | :--- | :--- |
| Unattended Installation | Enabled | Skipped (Ticked) | VirtualBox automated unattended installation bypasses crucial setup options, preventing the manual creation of local accounts and omitting the OpenSSH server installation on Ubuntu. |
| Ubuntu RAM | 2048 MB | 4096 MB | Allocates additional memory headroom for developer compilation tasks while keeping total allocated RAM within host capacity. |
| Ubuntu Disk Allocation | Fixed / 25 GB | Thin (Dynamic) | Keeps initial host disk consumption low; disk space is claimed only as actual files are written by the guest OS. |
| Ubuntu OpenSSH Server | Disabled | Enabled | Ubuntu Server operates headless; installing OpenSSH enables terminal access and output extraction from the host workstation. |
| Windows vCPU | 2 Cores | 4 Cores | Windows 11 graphical desktop performance improves significantly with 4 cores, easily accommodated by the host's 24 physical cores. |
| Windows Disk Allocation | 80 GB | 65 GB (Thin) | Satisfies the minimum 64 GB storage requirement for Windows 11 while conserving physical host storage. |
| Network Mode (Both) | NAT | NAT Network | Standard NAT places each guest behind its own isolated virtual router with an identical IP (`10.0.2.15`), preventing guest-to-guest traffic. NAT Network places both guests onto a shared `10.0.2.0/24` subnet. |
| Windows Account Setup | Online Microsoft Account | Domain join instead | Bypasses the mandatory personal Microsoft account requirement to create an isolated, local workstation profile (`dev`). |
| Windows Firewall (ICMPv4) | Block Inbound | Allow Inbound (ICMPv4 Type 8) | Windows Defender Firewall blocks ICMP echo requests by default on Public network profiles. Adding a specific allow rule enables ping tests without turning off host protection. |

## 3. What I did
1. **Installed Base Hypervisor:** Downloaded and installed Oracle VirtualBox 7.x on the Windows host using default paths. Omitted the Extension Pack to maintain full compliance with open-source licensing.
2. **Obtained Clean ISO Media:** Downloaded the official Ubuntu Server 24.04 LTS (amd64) ISO from `ubuntu.com` and the Windows 11 Enterprise 90-day Evaluation ISO from the Microsoft Evaluation Center.
3. **Built Ubuntu Server Guest (`lab01-ubuntu`):** Configured 2 vCPUs, 4096 MB RAM, and a 25 GB dynamically allocated disk. Selected "Skip Unattended Installation". Installed Ubuntu Server with `English (US)` keyboard, DHCP networking, guided full-disk partitioning, standard local account (`dev`), and enabled OpenSSH server. Verified installation via:
```bash
uname -a
lsb_release -a
```
4. **Built Windows 11 Guest (`lab02-windows`):** Configured 4 vCPUs, 4096 MB RAM, 65 GB dynamically allocated disk, EFI firmware, Secure Boot, and virtual TPM 2.0. Installed Windows 11 Enterprise Evaluation via "Domain join instead" to generate a clean local account (`dev`). Installed VirtualBox Guest Additions to enable proper display scaling and clipboard integration.
5. **Configured Shared NAT Network:** Created `NatNetwork` (`10.0.2.0/24`) in VirtualBox Network Manager. Attached `Adapter 1` of both `lab01-ubuntu` and `lab02-windows` to `NatNetwork`.
6. **Configured Inbound ICMP Firewall Rule:** Executed an administrative PowerShell command on Windows 11 to permit incoming ping requests:
```powershell
New-NetFirewallRule -DisplayName "Allow ping in (ICMPv4)" -Protocol ICMPv4 -IcmpType 8 -Direction Inbound -Action Allow
```
7. **Verified Inter-VM and Internet Connectivity:**
```bash
# Executed on Ubuntu Server:
ping -c 4 10.0.2.15
ping -c 4 ubuntu.com
```
```powershell
# Executed on Windows 11:
ping 10.0.2.4
ping ubuntu.com
```
8. **Created Golden Snapshot Baselines:** Powered down both virtual machines and created a clean snapshot named `clean-install` on each to establish an instant rollback state.

**What went wrong and how I resolved it:**
During initial connectivity checks, Windows 11 successfully pinged the Ubuntu Server (`10.0.2.4`), but pings from Ubuntu to Windows (`10.0.2.15`) timed out with 100% packet loss. 

First, I checked `Get-NetConnectionProfile` in Windows PowerShell and observed that the network interface was categorized under the `Public` firewall profile. In Windows Defender Firewall, the default policy for Public profiles discards incoming ICMPv4 Echo Requests. Rather than disabling the entire firewall (which compromises security and invalidates testing), I opened an elevated PowerShell prompt and deployed a targeted inbound rule (`New-NetFirewallRule -DisplayName "Allow ping in (ICMPv4)" -Protocol ICMPv4 -IcmpType 8 -Direction Inbound -Action Allow`). Subsequent pings from Ubuntu returned immediately with 0% packet loss.

Additionally, when initially attaching the network adapters, Ubuntu retained an old DHCP lease from a previously attached standard NAT adapter. Running `sudo reboot` forced the netplan configuration to reinitialize and acquire a clean, routable lease on the shared `NatNetwork` subnet.

## 4. Evidence
* [evidence/01-new-vm-wizard.png](evidence/01-new-vm-wizard.png) – Proves initial VM creation parameters, including version selection and skipping unattended installation.
* [evidence/02-disk-settings.png](evidence/02-disk-settings.png) – Proves dynamic allocation (thin provisioning) of the virtual disk files.
* [evidence/03-network-adapter.png](evidence/03-network-adapter.png) – Shows the VM network configuration bound to `NAT Network` (`NatNetwork`).
* [evidence/04-guest-uname.txt](evidence/04-guest-uname.txt) – Shows raw terminal output of `uname -a` and `lsb_release -a` confirming functional Linux guest build.
* [evidence/05-ping-between-guests.txt](evidence/05-ping-between-guests.txt) – Contains unedited ping outputs: Ubuntu to Windows, Windows to Ubuntu, and both machines reaching `ubuntu.com`.
* [evidence/06-snapshot-list.png](evidence/06-snapshot-list.png) – Proves both VMs have an offline `clean-install` snapshot configured.

## 5. What I would do differently
If rolling this out as a standard onboarding workflow for office management, I would not have Aigerim manually step through operating system installations or execute PowerShell firewall scripts. Instead, I would configure the base Ubuntu and Windows images once, apply all configurations and snapshots, and export them as an Open Virtualization Appliance (`.ova`) package. Aigerim could then set up a new developer workstation by simply clicking `File -> Import Appliance`, completing the entire deployment in under ten minutes with zero chance of manual configuration error.