#!/bin/sh
# Lab 5: convert staff-broken.csv from RK1048 (KZ-1048) to UTF-8 with BOM,
# keeping CRLF line endings and replacing ';' with ',' for Excel compatibility
in="evidence/staff-broken.csv"
out="evidence/staff-fixed.csv"

iconv -f RK1048 -t UTF-8 "$in" | sed 's/;/,/g' > "$out"
printf '\357\273\277' | cat - "$out" > tmp && mv tmp "$out"
