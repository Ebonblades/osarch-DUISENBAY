# Lab 2 — A Windows guest, and a network between them

Pair: Duisenbay Bayurzhan Machine: acer laptop, windows, 16 gb RAM, 24 cores, guests Ubuntu Server + Windows 11 Enterprise eval
Date: 02.11.26

## What I did
1. Downloaded Windows 11 Enterprise evaluation. Licence: https://www.microsoft.com/en-us/evalcenter
2. Created lab02-windows: 2 vCPU, 4 GB, 64 GB thin, UEFI + Secure Boot, vTPM.
3. Network mode: NAT network, both guests. Why: Both guests must see each other, it could be accomplished through Bridged mode but it is more limited due to the internet connection requirement, so NAT network should be more optimal
4. Ping Ubuntu → Windows timed out because the ping command relies on sending ICMP Echo Request packets, Windows Defender Firewall blocks all incoming ICMP requests by default to protect the system. So the command line is needed for ping requests to pass. . Fixed with: <New-NetFirewallRule -DisplayName "Allow ping in (ICMPv4)" -Protocol ICMPv4 -IcmpType 8 -Direction Inbound -Action Allow>
5. Overcommitment: set 10 GB + 10 GB on a 16 GB host.

## Network diagram
         Internet
                 |
      Host laptop 192.168.3.29 (home Wi-Fi)
                 |
     [VirtualBox · NAT · 10.0.2.0/24]
          /                        \
lab01-ubuntu                  lab02-windows
10.0.2.9                      10.0.2.10

## Result
| | Before | After |
|---|---|---|
| Host RAM in use | | |
| Available | | |
| Committed / Swap used | | |
| What I noticed | — | |

## What did not work the first time
<At least one thing: what I saw, what it turned out to be, what I did.>

## Evidence
- [evidence/ipconfig-windows.txt](evidence/ipconfig-windows.txt) — Windows address
- [evidence/ip-addr-linux.txt](evidence/ip-addr-linux.txt) — Ubuntu address
- [evidence/ping-both-ways.txt](evidence/ping-both-ways.txt) — both directions and the internet
- [evidence/host-memory-before.png](evidence/host-memory-before.png) — host memory, guests off
- [evidence/host-memory-after.png](evidence/host-memory-after.png) — host memory, both guests overcommitted
