PERSON: DUISENBAY BAUIRZHAN
PART: ALL BY ME
MACHINE: WINDOWS
DATE: 19.10.26

WHAT I DID:
1) Open powershell as device's OS is windows
2) Get commands sourced from the internet
3) Enter them and retrieve the results according to the task

RESULT:
4. CPU model -Intel(R) Core(TM) i9-14900HX, core number - 24, thread count - 32
5. Capacity - two stick 8 GB each, speed - 5600 both.
6. model - NVMe SAMSUNG MZVL21T0HCLR-00B07, type - NVMe, free space -153.81.
7. firmware type - UEFI, date - 1/16/2026 5:00:00 AM
8. virtualization present - false, enabled - false
WHERE I GOT IT:
4.
Get-CimInstance Win32_Processor | Select-Object Name, NumberOfCores, NumberOfLogicalProcessors
5.
Get-CimInstance Win32_PhysicalMemory | Select-Object @{Name="Capacity (GB)"; Expression={$_.Capacity / 1GB}}, Speed, DeviceLocator
6.
Get-Volume | Format-Table DriveLetter, FileSystemLabel, @{Name="FreeSpace (GB)"; Expression={[math]::Round($_.SizeRemaining / 1GB, 2)}}, @{Name="TotalSize (GB)"; Expression={[math]::Round($_.Size / 1GB, 2)}} -AutoSize

Get-Disk | Format-Table -Property FriendlyName, MediaType, BusType -AutoSize

7.
$env:firmware_type
Get-CimInstance -ClassName Win32_BIOS | Select-Object Manufacturer, SMBIOSBIOSVersion, ReleaseDate

8.
Get-CimInstance -ClassName Win32_Processor | Select-Object Name, VMMonitorModeExtensions, VirtualizationFirmwareEnabled

What did not work the first time:
Getting the date of BIOS version, as the initial command lacked details. which was resolved by adding additional command line.






