# Lab 5 — Encoding forensics

Name: Bauyrzhan · Date: 11.22.2026 · Tools: Ubuntu guest

## What I received
Excel - indecipherable symbols
Libreoffice - incorrect Kazakh character display
Ubuntu - similar question mark and other symbols

## Diagnosis (made before the fix)
- file said: cat evidence/file-before.txt
$ file evidence/staff-broken.csv
evidence/staff-broken.csv: Non-ISO extended-ASCII text, with CRLF line terminators  (evidence/file-before.txt)
- First 16 bytes: $ xxd evidence/staff-broken.csv | head -n 8
00000000: 4944 3bd4 e0ec e8eb e8ff 3bc8 ecff 3bce  ID;.......;...;.
00000010: f2e4 e5eb 3bc4 eeeb e6ed eef1 f2fc 3bc3  ....;.........;.
00000020: eef0 eee4 0d0a 3130 313b a3e1 e4b3 f0e0  ......101;......
00000030: f5ec e0ed eee2 e03b c0f0 f3e6 e0ed 3bc1  .......;......;.
00000040: f3f5 e3e0 ebf2 e5f0 e8ff 3bc3 ebe0 e2ed  ..........;.....
00000050: fbe9 20e1 f3f5 e3e0 ebf2 e5f0 3bc0 ebec  .. .........;...
00000060: e0f2 fb0d 0a31 3032 3bc8 e2e0 edee e23b  .....102;......;
00000070: d1e5 f0e3 e5e9 3bc8 d22d eef2 e4e5 eb3b  ......;..-.....;
  (evidence/hexdump-before.txt)
- Encoding: KZ-1048 — because file contains specific single-byte hex values for Cyrillic and Kazakh characters, like a3
- Line ending: CRLF — because 0d0a
- BOM: no — because 49 44; in the fixed file I <kept / removed / added> it because <reason>

## Fix
Converted from RK1048 to UTF-8 into evidence/staff-fixed.csv using scripts/fix.sh (iconv -f RK1048 -t UTF-8)  
[Three-application verification screenshot](evidence/opens-correctly.png)

## Verification
ID;Фамилия;Имя;Отдел;Должность;Город
101;Әбдірахманова;Аружан;Бухгалтерия;Главный бухгалтер;Алматы
102;Иванов;Сергей;ИТ-отдел;Системный администратор;Алматы
103;Қасымов;Нұрлан;Продажи;Менеджер по продажам;Астана
104;Петрова;Елена;Отдел кадров;Специалист по кадрам;Алматы
105;Сейітқали;Айгерім;Маркетинг;Дизайнер;Шымкент
106;Жұмабаев;Ерғали;ИТ-отдел;Веб-разработчик;Алматы
107;Ким;Алия;Бухгалтерия;Бухгалтер;Алматы
108;Өмірзақова;Гүлнұр;Продажи;Менеджер по работе с клиентами;Қарағанды
109;Смирнов;Дмитрий;Склад;Кладовщик;Алматы
110;Тоқтарова;Мөлдір;Отдел кадров;Руководитель отдела;Астана
111;Нұрғалиев;Әлихан;ИТ-отдел;Инженер техподдержки;Алматы
112;Федорова;Ольга;Юридический отдел;Юрист;Алматы
113;Бекболат;Үміт;Маркетинг;SMM-менеджер;Өскемен
114;Ахметов;Тимур;Склад;Водитель;Алматы
115;Шәріпова;Жәния;Бухгалтерия;Экономист;Павлодар

## What did not work the first time
Table contents did not turn correctly in each column inside Excel, after I tried sep= it still failed, need to proceed to ask instructor how to manage it correctly in the next lesson
