#!/usr/bin/env bash

file=$1

cat $file | awk '$1 != $5 || $2 != $6 || $3 != $7' > "$file"_newfile 
mv "$file"_newfile  $file
