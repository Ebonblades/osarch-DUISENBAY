# Ticket 2 — Kitting out the new office

## 1. What was asked
> **From:** Daniyar K. (Director)  
> **Subject:** computers for the new office  
> "We are opening the second office and need four computers — accountant, sales, web developer, designer. Budget 3,000,000 tenge for everything. Everyone says we should just buy the same four machines, is that right? Make sure they last a few years. Monitors included."

---

## 2. What was actually needed

**Why four identical machines is wrong:**  
Buying four identical ~750,000 KZT PCs wastes budget on the wrong components for every role. An accountant and sales manager do not need a dedicated GPU or a 4K color-calibrated monitor, so spending money on graphics for them takes away the exact budget the designer needs for an RTX 3060 12 GB and a ProArt display. Conversely, giving everyone a basic 750,000 KZT office machine with integrated graphics and a standard 1080p panel would cripple the designer's Adobe workflows and color accuracy. Matching each machine to its actual bottleneck puts every tenge where it prevents slowdowns.

**What the request left out:**
* **Operating system licenses:** Windows 11 costs 89,790 KZT per seat; three licenses alone take 269,370 KZT out of the budget.
* **CPU coolers for OEM processors:** Retail OEM CPUs (`i3-12100 OEM`, `Ryzen 5 5600GT OEM`) ship without a boxed cooler and require aftermarket coolers (`DeepCool AG200`).
* **Peripherals & accessories:** Keyboards (full-size with Numpad for the accountant), mice, webcam/headset for sales calls, and surge protectors/UPS.
* **Network & software:** Whether all desks have wired Ethernet drops (only the Web Developer's `B650M GAMING WIFI6E` has built-in Wi-Fi) and separate licensing for 1C:Enterprise, MS Office, and Adobe Creative Cloud.

**What I would ask Daniyar:**
1. Does the designer work mainly in 2D (Figma/Photoshop/Illustrator) or heavy 3D/4K video editing (Premiere/Blender)?
2. Does the web developer's stack allow Linux (Ubuntu LTS), or do company tools mandate Windows?
3. Do all four desks in the new office have wired Ethernet ports, or do the Accountant, Sales, and Designer PCs need Wi-Fi adapters?
4. How many years is "a few years" (3 vs. 5 years), and is there a separate IT budget for software subscriptions and backups?

**What I assumed instead:**
* **"A few years" = 3–5 years:** Every build has ≥ 16 GB RAM (32 GB for Web Developer and Designer), a 1 TB PCIe 4.0 NVMe SSD, and open RAM slots for upgrades on the Accountant (1 free slot) and Sales Manager (3 free slots) machines.
* **Software requirements:** Accountant, Sales, and Designer need licensed **Windows 11 Home** (for 1C/NCALayer, MS Office, and Adobe CC). The Web Developer runs **Ubuntu 24.04 LTS** (free commercial GNU GPL license, native Docker).
* **Office networking:** Wired Gigabit Ethernet is available at the office desks (all four motherboards include Gigabit/2.5GbE LAN ports).
* **Designer workload:** Primarily 2D print/UI design (Photoshop, Illustrator, Figma) with occasional video exports.

---

## 3. What I did

I profiled each role's daily workload to identify its primary bottleneck, allocated the 3,000,000 KZT budget toward those bottlenecks, and verified all component compatibility (sockets, DDR generation, M.2 NVMe, case clearance, PSU wattage) and Kazakhstan retail availability as of `2026-11-23`.

* Detailed load, bottleneck, and trade-off analysis: [`builds.md`](builds.md)
* Full itemized pricing with KZ vendor URLs and dates: [`budget.csv`](budget.csv)

| Role | Platform | RAM / Storage | GPU / Monitor | OS | Subtotal (KZT) |
| :--- | :--- | :--- | :--- | :--- | ---: |
| **Accountant** | LGA1700 (i3-12100 OEM) | 16 GB DDR4 / 1 TB NVMe | iGPU / 23.8" IPS FHD | Windows 11 Home | 528,560 |
| **Sales Manager** | AM4 (Ryzen 5 5600GT OEM) | 16 GB DDR4 / 1 TB NVMe | iGPU / 23.8" IPS FHD | Windows 11 Home | 588,050 |
| **Web Developer** | AM5 (Ryzen 5 7600) | 32 GB DDR5 / 1 TB NVMe | iGPU / 27" IPS QHD | Ubuntu 24.04 LTS | 777,858 |
| **Designer** | LGA1700 (i5-12400F) | 32 GB DDR4 / 1 TB NVMe | RTX 3060 12G / 27" 4K ProArt | Windows 11 Home | 1,094,708 |
| **Grand Total** | | | | | **2,989,176** |

*(10,824 KZT remaining under the 3,000,000 KZT budget.)*

### Answers to the Director's Three Questions

**1. Which machine will we upgrade first in 18 months, and why?**  
The **Sales Manager's RAM** (adding a second `16 GB DDR4-3200` stick to reach 32 GB dual-channel). To keep the initial purchase under 3,000,000 KZT despite high DDR5 prices, Sales starts with a single 16 GB stick (`1×16 GB`) on a 4-slot `Gigabyte B550M GAMING X` motherboard. Adding a matching 16 GB stick (~105,000 KZT) in one of the three open DIMM slots takes two minutes, enables dual-channel bandwidth, and eliminates memory swapping during heavy CRM + video-call multitasking.

**2. Pre-built comparison (Kazakhstan vendor prices, `2026-11-23`)**  
Comparable pre-built towers in Kazakhstan (without monitors, OS, or peripherals included):

| Role | Pre-built PC Model (KZ Vendor) | Tower Price | + Monitor, OS, Peripherals | Total (KZT) | Source (2026-11-23) |
| :--- | :--- | ---: | ---: | ---: | :--- |
| Accountant | Pulser Core i3-12100 / H610 / 8 GB / 512 GB *(under-spec)* | 195,990 | 158,820 | 354,810 | `pulser.kz/product/sistemnyj-blok-core-i3-12100-3-3ghz-h610-ram-8gb-ssd-512gb-no-dvd-450w-2-197450` |
| Sales | Sulpak ARG Universal T-03 (i3 / 16 GB / 512 GB, DOS) *(under-spec)* | 249,990 | 158,820 | 408,810 | `sulpak.kz/f/sistemniye_bloki` |
| Web Dev | Pulser Core i5-12400F / B760 / 16 GB / 512 GB / RTX 5050 *(wrong spec)* | 429,990 | 98,889 | 528,879 | `pulser.kz/product/sistemnyj-blok-core-i5-12400f-2-5ghz-b760-ram-16gb-ssd-512gb-rtx5050-8g-no-dvd-600w-3-203628` |
| Designer | Sulpak ARG Game B01 (i9-14900KF / 32 GB / 1 TB / RTX 5070) | 1,449,990 | 354,780 | 1,804,770 | `sulpak.kz/f/sistemniye_bloki` |
| **Pre-built Total** | | | | **3,097,269** | **Over budget by 97,269 KZT** |

* **What the company gains with pre-builts:** Single-invoice purchasing, zero assembly time, and a unified 1-year system warranty with one vendor to call if a PC fails to boot.
* **What the company loses:** Component balance and value. Off-the-shelf KZ office PCs ship with 8 GB RAM and 512 GB SSDs (violating our hard requirements), while pre-builts with 32 GB RAM and 1 TB SSDs bundle overpriced gaming CPUs/GPUs that push the total to **3,097,269 KZT** (over budget), often using unbranded PSUs and 2-slot boards with poor upgrade paths.

**3. Who will complain about performance within a month, and about what?**  
The **Sales Manager** will complain first—specifically about **browser sluggishness and minor stutters during Zoom/Teams screen-sharing** when 35–40 CRM tabs, Excel price sheets, and desktop messengers are open simultaneously. Cutting Sales from 32 GB to **1×16 GB DDR4** to keep the grand total under 3,000,000 KZT means Windows will hit ~85–90% RAM usage and start paging to the NVMe SSD under peak multitasking, while single-channel RAM slightly reduces the Ryzen 5 5600GT's integrated Vega graphics bandwidth.

---

## 4. Evidence
* [`evidence/pcpartpicker-links.md`](evidence/pcpartpicker-links.md) — PCPartPicker build permalinks verifying socket, RAM generation, M.2, case clearance, and PSU wattage compatibility across all four roles.
* [`evidence/vendor-quotes/i3-12100.png`](evidence/vendor-quotes/i3-12100.png) — Dated quote proving the `Intel Core i3-12100 OEM (LGA1700)` price (`66,900 KZT`) for Accountant.
* [`evidence/vendor-quotes/deepcool-ag200.png`](evidence/vendor-quotes/deepcool-ag200.png) — Dated quote proving the `DeepCool AG200` cooler price (`5,990 KZT`) for Accountant and Sales Manager.
* [`evidence/vendor-quotes/msi-pro-h610m-g-ddr4.png`](evidence/vendor-quotes/msi-pro-h610m-g-ddr4.png) — Dated quote proving the `MSI PRO H610M-G DDR4` motherboard price (`43,590 KZT`) for Accountant and Designer.
* [`evidence/vendor-quotes/kingston-fury-beast-16gb-ddr4.png`](evidence/vendor-quotes/kingston-fury-beast-16gb-ddr4.png) — Dated quote proving the `Kingston FURY Beast Black 16GB (1x16GB) DDR4-3200` price (`104,990 KZT`) for Accountant and Sales Manager.
* [`evidence/vendor-quotes/kingston-nv3-1tb.png`](evidence/vendor-quotes/kingston-nv3-1tb.png) — Dated quote proving the `Kingston NV3 1TB M.2 PCIe 4.0 NVMe SSD` price (`92,990 KZT`) across all four builds.
* [`evidence/vendor-quotes/deepcool-pf550.png`](evidence/vendor-quotes/deepcool-pf550.png) — Dated quote proving the `DeepCool PF550 550W` PSU price (`25,290 KZT`) across all four builds.
* [`evidence/vendor-quotes/deepcool-cc560-wh-v2.png`](evidence/vendor-quotes/deepcool-cc560-wh-v2.png) — Dated quote proving the `DeepCool CC560 WH V2` case price (`29,990 KZT`) across all four builds.
* [`evidence/vendor-quotes/lg-24ms500-b.png`](evidence/vendor-quotes/lg-24ms500-b.png) — Dated quote proving the `LG 24MS500-B 23.8" IPS 1920x1080` monitor price (`56,040 KZT`) for Accountant and Sales Manager.
* [`evidence/vendor-quotes/logitech-mk120.png`](evidence/vendor-quotes/logitech-mk120.png) — Dated quote proving the `Logitech MK120` wired keyboard and mouse price (`12,990 KZT`) across all four builds.
* [`evidence/vendor-quotes/windows-11-home.png`](evidence/vendor-quotes/windows-11-home.png) — Dated quote proving the `Microsoft Windows 11 Home 64-bit` license price (`89,790 KZT`) for Accountant, Sales Manager, and Designer.
* [`evidence/vendor-quotes/ryzen-5-5600gt.png`](evidence/vendor-quotes/ryzen-5-5600gt.png) — Dated quote proving the `AMD Ryzen 5 5600GT OEM (AM4)` price (`99,990 KZT`) for Sales Manager.
* [`evidence/vendor-quotes/gigabyte-b550m-gaming-x.png`](evidence/vendor-quotes/gigabyte-b550m-gaming-x.png) — Dated quote proving the `Gigabyte B550M GAMING X` motherboard price (`69,990 KZT`) for Sales Manager.
* [`evidence/vendor-quotes/ryzen-5-7600.png`](evidence/vendor-quotes/ryzen-5-7600.png) — Dated quote proving the `AMD Ryzen 5 7600 (AM5)` price (`93,729 KZT`) for Web Developer.
* [`evidence/vendor-quotes/deepcool-ag400.png`](evidence/vendor-quotes/deepcool-ag400.png) — Dated quote proving the `DeepCool AG400` cooler price (`11,990 KZT`) for Web Developer and Designer.
* [`evidence/vendor-quotes/gigabyte-b650m-gaming-wifi6e.png`](evidence/vendor-quotes/gigabyte-b650m-gaming-wifi6e.png) — Dated quote proving the `Gigabyte B650M GAMING WIFI6E` motherboard price (`89,990 KZT`) for Web Developer.
* [`evidence/vendor-quotes/agi-turbosprint-32gb-ddr5.png`](evidence/vendor-quotes/agi-turbosprint-32gb-ddr5.png) — Dated quote proving the `AGI Turbosprint RGB 32GB (2x16GB) DDR5-6000` price (`334,990 KZT`) for Web Developer.
* [`evidence/vendor-quotes/lg-27qn600-b.png`](evidence/vendor-quotes/lg-27qn600-b.png) — Dated quote proving the `LG 27QN600-B 27" IPS 2560x1440 QHD` monitor price (`85,899 KZT`) for Web Developer.
* [`evidence/vendor-quotes/ubuntu-24-04-lts.png`](evidence/vendor-quotes/ubuntu-24-04-lts.png) — Dated page capture proving `Ubuntu Desktop 24.04 LTS` (`0 KZT`, GNU GPL open-source license) for Web Developer.
* [`evidence/vendor-quotes/i5-12400f.png`](evidence/vendor-quotes/i5-12400f.png) — Dated quote proving the `Intel Core i5-12400F (LGA1700)` price (`61,948 KZT`) for Designer.
* [`evidence/vendor-quotes/kingston-fury-beast-32gb-ddr4.png`](evidence/vendor-quotes/kingston-fury-beast-32gb-ddr4.png) — Dated quote proving the `Kingston FURY Beast 32GB (2x16GB) DDR4-3200` price (`174,140 KZT`) for Designer.
* [`evidence/vendor-quotes/msi-rtx-3060-ventus-2x-12g.png`](evidence/vendor-quotes/msi-rtx-3060-ventus-2x-12g.png) — Dated quote proving the `MSI GeForce RTX 3060 Ventus 2X 12G OC` GPU price (`299,990 KZT`) for Designer.
* [`evidence/vendor-quotes/asus-proart-pa279cv.png`](evidence/vendor-quotes/asus-proart-pa279cv.png) — Dated quote proving the `ASUS ProArt Display PA279CV 27" 4K IPS` monitor price (`252,000 KZT`) for Designer.

---

## 5. What I would do differently
Instead of buying a 32 GB DDR5 kit at inflated retail pricing (`334,990 KZT`) for the Web Developer on AM5, I would build the Web Developer on an **AM4 / DDR4 platform** (e.g., `Ryzen 7 5700G` + `Gigabyte B550M GAMING X` + `32 GB DDR4-3200`). That would save ~160,000 KZT, allowing us to upgrade the Sales Manager back to **32 GB DDR4** right away and upgrade the Designer's motherboard from an `H610M` (2 RAM slots, 1 M.2) to a `B760M DDR4` (4 RAM slots, 2 M.2) while staying well under 3,000,000 KZT.
