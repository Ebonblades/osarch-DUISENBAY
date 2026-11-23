# Lab 5 — Encoding forensics

Name: Bauyrzhan · Date: 11.22.2026 · Tools: Ubuntu guest, Excel, LibreOffice Calc

## What I received
- **Excel:** Indecipherable mojibake symbols instead of Russian and Kazakh names, with all fields collapsed into column A.
- **LibreOffice Calc:** Incorrect Kazakh characters displayed when opened with the default Windows-1251 character set.
- **Ubuntu terminal (`cat`):** Replacement question marks (``) and garbled symbols for all non-ASCII characters.

## Diagnosis (made before the fix)
- **file said:** `evidence/staff-broken.csv: Non-ISO extended-ASCII text, with CRLF line terminators` (`evidence/file-before.txt`)
- **First 16 bytes:** `4944 3bd4 e0ec e8eb e8ff 3bc8 ecff 3bce` (`ID;.......;...;.`) (`evidence/hexdump-before.txt`)
- **Encoding:** **KZ-1048** (named `RK1048` in `iconv`) — Cyrillic letters are encoded as single bytes in the `C0–FF` range (e.g., `d4 e0 ec e8 eb e8 ff` for `Фамилия`, `c0` for `А`), and the Kazakh letter in row 101 (`101;Әбдірахманова`, offset `0x2a`) is the single byte **`A3`**. In **KZ-1048**, `A3` is **`Ә`**, whereas in **Windows-1251**, `A3` is **`Ј`**. Decoding with `iconv -f RK1048 -t UTF-8` renders every Russian and Kazakh name correctly.
- **Separator:** **`;` (semicolon)** — byte `3b` separates every column (e.g., `49 44 3b` = `ID;`, `31 30 31 3b` = `101;`).
- **Line ending:** **CRLF** — line 1 ends with `0d 0a` (offsets `0x24–0x25`, immediately after `Город`). **Decision for the fixed file:** I **kept CRLF** because the file must open cleanly in Windows and Excel, which expect CRLF, and LibreOffice Calc and `cat` in Linux handle it without issues.
- **BOM:** **No** — the file starts with `49 44` (`ID`), not `EF BB BF`. **Decision for the fixed file:** I **added a UTF-8 BOM (`EF BB BF`)** so Excel on Windows automatically detects UTF-8 when opening the CSV by double-click.

## Fix
Converted `evidence/staff-broken.csv` from `RK1048` to `UTF-8`, preserved CRLF line endings, and prepended a UTF-8 BOM (`EF BB BF`) using `scripts/fix.sh`:

```sh
#!/bin/sh
# Lab 5: convert staff-broken.csv from RK1048 (KZ-1048) to UTF-8 with BOM, keeping CRLF
in="evidence/staff-broken.csv"
out="evidence/staff-fixed.csv"

iconv -f RK1048 -t UTF-8 "$in" > "$out"
printf '\357\273\277' | cat - "$out" > tmp && mv tmp "$out"
