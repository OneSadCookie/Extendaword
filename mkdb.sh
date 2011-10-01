#!/bin/sh
./process2+2gfreq.rb > gfreqout.txt
rm -f Extendaword/English.sqlite3
cat mkdb.sql | sqlite3 -batch Extendaword/English.sqlite3
