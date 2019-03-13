#!/bin/bash

dirpath=$1
program=$2
arguments=$3

pass=0

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

if [ $successmem -gt 0 ]; then
	((pass+=2))
	meml = "FAIL"
fi

valgrind --tool=helgrind $dirpath/$program  &>/dev/null

successtrd=$?

if [ $successtrd -gt 0 ]; then
	((pass+=1))
	trdr = "FAIL"
fi

echo "Compilation "   "Memory leaks "  "thread race"
echo   "$comp          "        "$meml             "           "$trdr"

exit $pass
