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
	meml = "FAIL"
	((pass+=2))
fi

valgrind --tool=helgrind $dirpath/$program  &>/dev/null

successtrd=$?

if [ $successtrd -gt 0 ]; then
	trdr = "FAIL"
	((pass+=1))
fi

echo "Compilation "   "Memory leaks "  "thread race"
echo   "$comp          "        "$meml             "           "$trdr"

exit $pass
