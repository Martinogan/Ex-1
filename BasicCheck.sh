#!/bin/bash

dirpath=$1
program=$2
arguments=$3

comp="PASS"
meml="PASS"
trdr="PASS"

cd $dirpath
make &>/dev/null

successcmp=$?

if [ $successcmp -gt 0 ]; then
	echo "Compilation FAIL"
	comp = "FAIL"
	exit 7
else 
valgrind --tool=memcheck --leak-check=full $dirpath/$program  &>/dev/null

successmem=$?

if [ $successmem -gt 0 ]; then
	meml = "FAIL"
	exit 2
else
valgrind --tool=helgrind $dirpath/$program  &>/dev/null

successtrd=$?

if [ $successtrd -gt 0 ]; then
	trdr = "FAIL"
	exit 1
else
exit 0

fi
fi
fi

echo "Compilation "   "Memory leaks "  "thread race"
echo   "$comp          "        "$meml             "           "$trdr"
