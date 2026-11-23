# Lab 5 — Encoding forensics

Name: Bauyrzhan · Date: 11.22.2026 · Tools: Ubuntu guest, Excel, LibreOffice Calc

## What I received
- **Excel:** Indecipherable mojibake symbols instead of Russian and Kazakh names, with all fields collapsed into column A.
- **LibreOffice Calc:** Incorrect Kazakh characters displayed when opened with the default character set.
- **Ubuntu terminal (`cat`):** Question marks and garbled symbols for non-ASCII characters.

## Diagnosis (made before the fix)
- **file said:** `evidence/staff-broken.csv: Non-ISO extended-ASCII text, with CRLF line terminators` (`evidence/file-before.txt`)
- **First 16 bytes:** `4944 3bd4 e0ec e8eb e8ff 3bc8 ecff 3bce` (`ID;.......;...;.`) (`evidence/hexdump-before.txt`)
- **Encoding:** **KZ-1048** (named `RK1048` in `iconv`) — Cyrillic letters are single bytes in the `C0–FF` range (e.g., `d4 e0 ec e8 eb e8 ff` = `Фамилия`), and the first letter of the surname in row 101 (`101;Әбдірахманова`, offset `0x2a`) is the single byte **`A3`**. In **KZ-1048**, `A3` is **`Ә`**, whereas in **Windows-1251**, `A3` is **`Ј`**. Decoding with `iconv -f RK1048 -t UTF-8` renders every Russian and Kazakh name correctly.
- **Separator:** **`;` (semicolon)** — byte `3b` separates every column (e.g., `49 44 3b` = `ID;`, `31 30 31 3b` = `101;`).
- **Line ending:** **CRLF** — line 1 ends with `0d 0a` (offsets `0x24–0x25`, right after `Город`). **Decision for fixed file:** **Kept CRLF (`0d 0a`)** because Windows and Excel expect CRLF line endings, while LibreOffice Calc and `cat` in Ubuntu display it cleanly.
- **BOM:** **No BOM in `staff-broken.csv`** (starts with `49 44` = `ID`, not `EF BB BF`); **UTF-8 BOM (`EF BB BF`) is present in `staff-fixed.csv`** — I **added** it so Excel on Windows automatically detects UTF-8 when opening the CSV by double-click.

## Fix
Converted `evidence/staff-broken.csv` from `RK1048` to `UTF-8`, kept CRLF line endings, converted the delimiter from `;` to `,` for Excel compatibility (no field values contain commas), and prepended a UTF-8 BOM (`EF BB BF`) using `scripts/fix.sh`:

```sh
#!/bin/sh
# Lab 5: convert staff-broken.csv from RK1048 (KZ-1048) to UTF-8 with BOM,
# keeping CRLF line endings and replacing ';' with ',' for Excel compatibility
in="evidence/staff-broken.csv"
out="evidence/staff-fixed.csv"

iconv -f RK1048 -t UTF-8 "$in" \vert{} sed 's/;/,/g' > "$out"
printf '\357\273\277' | cat - "$out" > tmp && mv tmp "$out"
[Three-application verification screenshot](evidence/opens-correctly.png)

## Verification
evidence/file-after.txt: Confirms Unicode text, UTF-8 (with BOM) text with CRLF line endings, and the hex dump starts with efbb bf (EF BB BF UTF-8 BOM). Cyrillic and Kazakh letters appear as valid multi-byte UTF-8 sequences (e.g., d0 a4 for Ф, d3 98 for Ә).  
Three-application check: evidence/staff-fixed.csv opens with all Russian and Kazakh letters displayed correctly and columns properly separated in Excel, LibreOffice Calc, and the Ubuntu terminal (cat evidence/staff-fixed.csv)  


## What did not work the first time
BOM mismatch between script and evidence: Running iconv -f RK1048 -t UTF-8 alone does not add a BOM. Updating scripts/fix.sh to prepend \357\273\277 (EF BB BF) and regenerating evidence/staff-fixed.csv and evidence/file-after.txt resolved the mismatch.