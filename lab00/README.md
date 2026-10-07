PERSON: DUISENBAY BAUIRZHAN
PART: ALL BY ME
MACHINE: WINDOWS
DATE: 10.07.26

WHAT I DID:
I used the following commands in sequence to get CPU, memory and disk model respectively:

Get-CimInstance Win32_Processor | Select-Object Name, NumberOfCores, NumberOfLogicalProcessors

Get-CimInstance Win32_PhysicalMemory | Select-Object @{Name="Capacity (GB)"; Expression={$_.Capacity / 1GB}}, Speed, DeviceLocator

Get-PhysicalDisk | Select-Object DeviceId, FriendlyName, MediaType, BusType

