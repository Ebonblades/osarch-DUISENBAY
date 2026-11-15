# Lab 4 — Partition, mirror, fail, recover

Pair: Duisenbay Bauyrzhan · Date: 11.16.2026 · Hypervisor: VirtualBox

## Windows
PS C:\WINDOWS\system32> Get-Disk | Select Number, FriendlyName, PartitionStyle, Size

Number FriendlyName  PartitionStyle        Size
------ ------------  --------------        ----
     0 VBOX HARDDISK GPT            68719476736
     1 VBOX HARDDISK GPT             1073741824


PS C:\WINDOWS\system32> Get-Volume | Where FileSystemLabel -eq 'LAB04'

DriveLetter FriendlyName FileSystemType DriveType HealthStatus OperationalStatus SizeRemaining       Size
----------- ------------ -------------- --------- ------------ ----------------- -------------       ----
E           LAB04        NTFS           Fixed     Healthy      OK                    990.77 MB 1007.93 MB

MBR or GPT: GPT, because Windows 11 requires UEFI booting and GPT supports modern disk sizes beyond 2 TB while keeping a backup copy of the partition table for data integrity.

## Linux — layout before and after
### Before
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
loop0                       7:0    0  1.5M  1 loop /snap/hwctl/123
loop1                       7:1    0 66.8M  1 loop /snap/core24/1643
loop2                       7:2    0  1.5M  1 loop /snap/hwctl/131
loop3                       7:3    0 50.1M  1 loop /snap/snapd/27710
sda                         8:0    0   25G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    2G  0 part /boot
└─sda3                      8:3    0   23G  0 part
  └─ubuntu--vg-ubuntu--lv 252:0    0 11.5G  0 lvm  /
sdb                         8:16   0    1G  0 disk
└─sdb1                      8:17   0 1022M  0 part
sdc                         8:32   0    1G  0 disk
└─sdc1                      8:33   0 1022M  0 part
sdd                         8:48   0    1G  0 disk
└─sdd1                      8:49   0 1022M  0 part
sr0                        11:0    1 1024M  1 rom
### After
NAME                       SIZE TYPE  FSTYPE            MOUNTPOINTS
loop0                      1.5M loop  squashfs          /snap/hwctl/123
loop1                     66.8M loop  squashfs          /snap/core24/1643
loop2                      1.5M loop  squashfs          /snap/hwctl/131
loop3                     50.1M loop  squashfs          /snap/snapd/27710
sda                         25G disk
├─sda1                       1M part
├─sda2                       2G part  ext4              /boot
└─sda3                      23G part  LVM2_member
  └─ubuntu--vg-ubuntu--lv 11.5G lvm   ext4              /
sdb                          1G disk
└─sdb1                    1022M part  linux_raid_member
  └─md0                   1021M raid1 ext4              /mnt/mirror
sdc                          1G disk
└─sdc1                    1022M part  linux_raid_member
sdd                          1G disk
└─sdd1                    1022M part  linux_raid_member
  └─md0                   1021M raid1 ext4              /mnt/mirror
sr0                       1024M rom

## What I did
### WINDOWS (Run in PowerShell as Administrator) ###

Get-Disk  
Set-Disk -Number 1 -IsOffline $false  
Initialize-Disk -Number 1 -PartitionStyle GPT  
New-Partition -DiskNumber 1 -UseMaximumSize -AssignDriveLetter | Format-Volume -FileSystem NTFS -NewFileSystemLabel LAB04  
Get-Disk | Select Number, FriendlyName, PartitionStyle, Size  
Get-Volume | Where FileSystemLabel -eq 'LAB04'  


### LINUX (Run in Ubuntu Terminal) ###

# Step 3: Setup evidence folder and check disks 
mkdir -p ~/lab04/evidence && cd ~/lab04  
{ echo '$ lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS'; lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS; } > evidence/lsblk-before.txt  
cat evidence/lsblk-before.txt  

# Step 4: Partition the three disks (Ensure your disks are sdb, sdc, sdd)  
for d in sdb sdc sdd; do  
  sudo parted -s /dev/$d mklabel gpt mkpart primary 1MiB 100% set 1 raid on  
done  
lsblk  

# Step 5: Build mirror
sudo apt install -y mdadm  
sudo mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1  
cat /proc/mdstat  
{ echo '$ cat /proc/mdstat'; cat /proc/mdstat; echo; echo '$ sudo mdadm --detail /dev/md0'; sudo mdadm --detail /dev/md0; } > evidence/array-healthy.txt  

# Step 6: File system, mount, proof file, and checksum
sudo mkfs.ext4 -L mirror /dev/md0  
sudo mkdir -p /mnt/mirror  
sudo mount /dev/md0 /mnt/mirror  
sudo chown $USER: /mnt/mirror  
echo "Lab 4 proof file — <your names> — $(date)" > /mnt/mirror/proof.txt  
head -c 20M /dev/urandom > /mnt/mirror/random.bin  
cd /mnt/mirror && { echo '$ sha256sum proof.txt random.bin'; sha256sum proof.txt random.bin; } > ~/lab04/evidence/checksum-before.txt; cd ~/lab04  
cat evidence/checksum-before.txt  

# Step 7: Fail one disk and test survival
sudo mdadm /dev/md0 --fail /dev/sdc1
sudo mdadm /dev/md0 --remove /dev/sdc1
{ echo '$ cat /proc/mdstat'; cat /proc/mdstat; echo; echo '$ sudo mdadm --detail /dev/md0'; sudo mdadm --detail /dev/md0; } > evidence/array-degraded.txt
cat /proc/mdstat
cat /mnt/mirror/proof.txt
cd /mnt/mirror && { echo '$ sha256sum proof.txt random.bin'; sha256sum proof.txt random.bin; } > ~/lab04/evidence/checksum-after-failure.txt; cd ~/lab04
diff <(tail -n +2 evidence/checksum-before.txt) <(tail -n +2 evidence/checksum-after-failure.txt) && echo "checksums match"

# Step 8: Add the third disk and rebuild
sudo mdadm /dev/md0 --add /dev/sdd1
cat /proc/mdstat
{ echo '$ cat /proc/mdstat'; cat /proc/mdstat; echo; echo '$ sudo mdadm --detail /dev/md0'; sudo mdadm --detail /dev/md0; } > evidence/array-rebuilt.txt
sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf
sudo update-initramfs -u
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS

## Three states
| State | What /proc/mdstat showed | File |
| --- | --- | --- |
| Healthy | [2/2] [UU] | evidence/array-healthy.txt |
| Degraded | [2/1] [U_] | evidence/array-degraded.txt |
| Rebuilt | [2/2] [UU], sdd1 replaced sdc1 | evidence/array-rebuilt.txt |
Checksums before and after the failure: match

## RAID is not a backup
Your colleague deleted the wrong file from the mirror an hour ago. Does RAID 1 help? Why?
No, RAID 1 does not help in this scenario because file deletion is immediately mirrored and synchronized across both drives in real time. Since RAID protects against hardware disk failure rather than user error or logical data corruption, the file is effectively gone on both copies. Recovering the deleted file requires restoring it from an independent backup or snapshot taken prior to the deletion.

## What did not work the first time
I accidently detached the main disk while adding three 1 gb ones, after which I reattached it by assigning correct port to the main disk.
