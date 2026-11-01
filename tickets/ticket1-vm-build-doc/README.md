| Question for Aigerim | Why it matters | Assumption made instead |
| :--- | :--- | :--- |
| What are the RAM, processor, and free disk space numbers on the laptop we are setting up? | Determines how much memory and disk we can give each VM without slowing down the main computer. | Used my Lab 0 host machine specifications: **16 GB RAM, 8-core CPU, and 512 GB SSD (180 GB free)**. |
| Which operating systems will the new developer's projects run on? | Decides which guest OS images Aigerim needs to download. | Assumed a standard cross-platform developer baseline: **Ubuntu Server 24.04 LTS** (backend/CLI) and **Windows 11 Enterprise** (desktop client). |
| Does the developer need other computers in the office to connect into his test VMs, or only his own laptop? | Determines the network adapter mode. | Assumed only outbound internet and communication between the two VMs on the same laptop are needed; chose a shared **NAT Network** so office MAC filtering does not block the VMs. |
