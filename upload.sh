#!/bin/sh
xcodebuild clean
xcodebuild
tar cjf Extendaword.tar.bz2 -C build/Release Extendaword.app
rm -rf build
scp -P 2222 Extendaword.tar.bz2 keith@onesadcookie.com:public_html/
echo 'http://onesadcookie.com/~keith/Extendaword.tar.bz2' | pbcopy
