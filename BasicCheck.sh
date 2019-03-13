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
fi

valgrind --tool=memcheck --leak-check=full $dirpath/$program  &>/dev/null

successmem=$?
echo $successmem
if [ $successmem -gt 0 ]; then
	echo "im not here"
	meml = "FAIL"
	exit 2
fi

valgrind --tool=helgrind $dirpath/$program  &>/dev/null

successtrd=$?
echo $successtrd
if [ $successtrd -gt 0 ]; then
	echo "im not here 2"
	trdr = "FAIL"
	exit 1
fi

echo "Compilation "   "Memory leaks "  "thread race"
echo   "$comp          "        "$meml             "           "$trdr"

exit 0
