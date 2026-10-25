# Lab 1 — Your first virtual machine

Pair: Duisenbay Bauyrzhan   Driver first half: none
Machine: ACER, WINDOWS, guest Ubuntu Server 
Date: <25.10.2026>

## What I did
1. Installed VirtualBox Version 7.2.20 r175154. Licence: https://www.virtualbox.org/wiki/Licensing_FAQ
2. Created VM lab01-ubuntu: 2 vCPU, 4 GB RAM, 25 GB dynamic disk, bridged adapter.
3. Installed Ubuntu Server, took snapshot clean-install.
4. Broke it: 
cat /etc/hostname | to verify the host name
sudo rm /etc/hostname | to delete it
5. Rolled back to clean-install: 
cat /etc/hostname | to show the host name after snapshot
hostname

## Resource justification
2 vCPUs from 24 as it is enough for the labolatory works,
4 GB RAM from total 16 GB to maintain enough memory for the OS,
25 GB of disc memory as stated in requirements.

## Result
The VM boots; the break-and-rollback cycle is shown in the evidence below.

## What did not work the first time
I tried setting up SSH and ultimately failed, I will proceed asking in next lesson to ensure it is enabled

## Evidence
- [evidence/vm-settings.png](evidence/vm-settings.png) — CPU, memory and disk as configured
- [evidence/guest-release.txt](evidence/guest-release.png) — Ubuntu Server is running in the guest
- [evidence/broken.png](evidence/broken.png) — the guest in its broken state
- [evidence/snapshot-list.png](evidence/snapshot-list.png) — the snapshot, after the rollback
