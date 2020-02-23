#!/bin/sh

propFile="$1"
propDir="$2"

if [ -e $propDir ]
then
    rm -rf $propDir/*
else
    mkdir $propDir
fi

while read -r line
do
    [ "$line" = "" ] || [ "${line:0:1}" = "#" ] && continue
    f=$(echo $line | cut -d, -f2)
    echo "Processing $f ..."
    grep -Ilr \#$f\# . > $propDir/$f.files
done < "$propFile"

echo "done."
