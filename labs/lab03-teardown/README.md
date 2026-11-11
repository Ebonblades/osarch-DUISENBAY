# Lab 3 — Teardown, and the same machine from the command line

Pair: Bauyrzhan · Date: 11.8.2026

Part 1 — Ten parts
AMD Ryzen 5 7600
6-core/12-thread processor, 5.1 GHz, 38 MB cache, 65 W. Connects to an AM5 socket. Limit: fits only AM5 motherboards; memory controller supports only DDR5.  
- [evidence/amd-ryzen-5-7600.png](evidence/amd-ryzen-5-7600.png)
https://www.amd.com/en/products/processors/desktops/ryzen/7000-series/amd-ryzen-5-7600.html#product-specs


Intel Core i5-13400
10-core/16-thread processor, 4.60 GHz, 20 MB cache, 65 W. Connects to an LGA1700 socket. Limit: fits only LGA1700 motherboards.  
- [evidence/intel-core-i5-13400.png](evidence/intel-core-i5-13400.png)
https://www.intel.com/content/www/us/en/products/sku/230495/intel-core-i513400-processor-20m-cache-up-to-4-60-ghz/specifications.html

ASUS PRIME B650M-A
Micro-ATX motherboard, AMD B650 chipset. Connects to an AM5 processor, DDR5 memory, M.2 NVMe, and SATA drives. Limit: supports only compatible AMD Ryzen processors; DDR5 slots make DDR4 impossible.  
- [evidence/asus-prime-b560m-a.png](evidence/asus-prime-b560m-a.png)
https://www.asus.com/motherboards-components/motherboards/prime/prime-b650m-a/

MSI PRO B760M-A WIFI DDR4
Micro-ATX motherboard, Intel B760 chipset, Wi-Fi. Connects to an LGA1700 processor, DDR4 memory, M.2 NVMe, and SATA drives. Limit: supports only compatible Intel Core processors; DDR4 slots make DDR5 impossible.  
- [evidence/msi-pro-b760m-a-wifi-ddr4.png](evidence/msi-pro-b760m-a-wifi-ddr4.png)
https://storage-asset.msi.com/datasheet/mb/global/PRO-B760M-A-WIFI-DDR4.pdf
Kingston FURY Beast DDR5-5600, 16 GB
DDR5 UDIMM, 16 GB, 5600 MT/s, 288 pins. Connects to a desktop DDR5 slot, one per memory channel. Limit: fits only DDR5 boards; the notch makes DDR4 slots impossible.  
- [evidence/kingston-fury-beast-ddr5-5600-16-gb.png](evidence/kingston-fury-beast-ddr5-5600-16-gb.png)
https://www.kingston.com/datasheets/KF556C40BB-16.pdf
Crucial DDR4-3200, 16 GB DIMM
DDR4 UDIMM, 16 GB, 3200 MT/s, 288 pins. Connects to a desktop DDR4 slot, one per memory channel. Limit: fits only DDR4 boards; the notch makes DDR5 slots impossible.  
- [evidence/crucial-ddr4-3200-16-gb-dimm.png](evidence/crucial-ddr4-3200-16-gb-dimm.png)
https://eu.crucial.com/memory/eol_ddr4/ct16g4dfra32a


Samsung 990 PRO 1 TB
NVMe PCIe 4.0 x4 SSD, 1 TB, M.2 2280, 7450 MB/s. Connects to an M.2 motherboard slot. Limit: requires an 80mm M.2 slot; speed drops to ~3500 MB/s on older PCIe 3.0 boards.  
- [evidence/samsung-990-pro-1-tb.png](evidence/samsung-990-pro-1-tb.png)
https://download.semiconductor.samsung.com/resources/data-sheet/Samsung_NVMe_SSD_990_PRO_Datasheet_Rev.1.0.pdf


Samsung 870 EVO 1 TB
SATA SSD, 1 TB, 2.5-inch, 560 MB/s. Connects to a motherboard SATA port and power supply SATA cable. Limit: SATA interface caps speed at roughly 550 MB/s.  
- [evidence/samsung-870-evo-1-tb.png](evidence/samsung-870-evo-1-tb.png)
https://download.semiconductor.samsung.com/resources/data-sheet/Samsung_SSD_870_EVO_Data_Sheet_Rev1.1_230509.pdf

Corsair RM750e (750 W)
750 W power supply, 80 PLUS Gold, ATX 3.0, fully modular. Connects to motherboard 24-pin and 8-pin CPU headers, graphics card, and drives. Limit: total system draw cannot exceed 750 watts.  
- [evidence/corsair-rm750e-750w.png](evidence/corsair-rm750e-750w.png)
https://www.corsair.com/ww/en/p/psu/cp-9020262-ww/rme-series-rm750e-fully-modular-low-noise-atx-power-supply-cp-9020262-ww#tab-techspecs

Stock Cooler (Intel Laminar RM1 / AMD Wraith Stealth)
Down-draft air cooler. Connects to the designated CPU socket and motherboard 4-pin fan header. Limit: fits only the specific socket it is bundled for; heat removal maxes out around 65 W.  
- [evidence/intel-laminar-rm1.png](evidence/intel-laminar-rm1.png)
https://www.intel.com/content/www/us/en/support/articles/000089190.html
## Two builds

### Build 1
| Part | Model | Why it fits here |
| :--- | :--- | :--- |
| Processor | AMD Ryzen 5 7600 | Requires the AM5 socket found on the ASUS board. |
| Motherboard | ASUS PRIME B650M-A | Provides the AM5 socket for the Ryzen CPU and DDR5 slots for the Kingston memory. |
| Memory | Kingston FURY Beast DDR5-5600, 16 GB | Physically fits the DDR5 slots on the ASUS board. |
| SSD | Samsung 990 PRO 1 TB | Fits directly into the M.2 NVMe slot on the ASUS board. |
| Power Supply | Corsair RM750e (750 W) | Provides the 24-pin and 8-pin ATX power needed by the board and CPU. |

**What Build 1 still needs:** A CPU cooler. Because the single stock cooler from the list was allocated to Build 2, this processor will overheat without an AM5-compatible cooling solution.

### Build 2
| Part | Model | Why it fits here |
| :--- | :--- | :--- |
| Processor | Intel Core i5-13400 | Requires the LGA1700 socket found on the MSI board. |
| Motherboard | MSI PRO B760M-A WIFI DDR4 | Provides the LGA1700 socket for the Intel CPU and DDR4 slots for the Crucial memory. |
| Memory | Crucial DDR4-3200, 16 GB DIMM | Physically fits the DDR4 slots on the MSI board. |
| SSD | Samsung 870 EVO 1 TB | Plugs into one of the SATA 6G ports on the MSI board. |
| Cooling | Stock cooler | Mounts directly to the LGA1700 socket to keep the i5-13400 cool. |

**What Build 2 still needs:** A power supply. Without a PSU to deliver power to the motherboard and the SATA SSD, the system cannot turn on.

## Part 2 — Same facts, three operating systems
| Fact | Windows (PowerShell) | Linux (Ubuntu VM) |
| :--- | :--- | :--- |
| **CPU model** | Intel(R) Core(TM) i9-14900HX | Intel(R) Core(TM) i9-14900HX |
| **Cores / threads** | 24 cores / 32 logical processors | 2 cores / 2 threads (assigned vCPUs) |
| **Total memory** | 16 GB (17,179,869,184 bytes across 2 sticks) | 3.3 GiB (~4.0 GB assigned to VM) |
| **Memory modules and speed** | 2x 8 GB DDR5 (`SMBIOSMemoryType: 34`), SODIMM (`FormFactor: 12`), 5600 MT/s | Virtualized RAM (VirtualBox SMBIOS exposes no physical DIMMs) |
| **Disk model and type** | Samsung PM9A1 1 TB (`MZVL21T0HCLR-00B07`), SSD, NVMe | `VBOX HARDDISK`, Virtual HDD, SATA, 25 GB |
| **Free space** | 87.2 GB remaining (out of 952.6 GB on C:) | 5.4 GB available (out of 12 GB root volume) |
| **Architecture (x86-64 / ARM64)** | AMD64 (x86-64) | x86_64 |

Windows reported the host's physical hardware identities directly, showing specific OEM model names like the Intel(R) Core(TM) i9-14900HX processor and the SAMSUNG MZVL21T0HCLR-00B07 NVMe SSD. In contrast, the Ubuntu VM abstracted the physical hardware through the hypervisor, displaying generic virtualization labels such as VBOX HARDDISK on a virtual SATA controller and reporting only 2 assigned vCPUs and ~3.3 GiB of virtual RAM. Furthermore, because VirtualBox does not expose physical DIMM topology to the guest OS, dmidecode on Linux could not read individual memory module models or clock speeds, whereas Windows detailed the dual 8 GB DDR5-5600 SODIMM sticks.

## What did not work the first time
Commands provided to retrieve specs did not work, after which I tried typing each command individually with presented code ({ echo '$ lscpu'; lscpu; } >> evidence/linux-specs.txt for ubuntu and ... | Out-File evidence\windows-specs.txt -Encoding utf8 -Append for windows) individually, after which it worked out

## Evidence
- [evidence/windows-specs.txt](evidence/windows-specs.txt) — Windows specs
- [evidence/linux-specs.txt](evidence/linux-specs.txt) — Linux specs
