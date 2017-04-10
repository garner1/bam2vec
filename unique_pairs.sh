#!/usr/bin/env bash

# RETAIN ONLY UNIQUE PAIRS

file=$1				# input file of pairs

lines=$(cat $file|wc -l)
for row in $(seq 2 $lines); do
    tail -n +"$row" $file | awk '{OFS="\t"; print $5,$6,$7,$8,$1,$2,$3,$4}' > "$file"_newfile # FLIP THE BOTTOM FILE
    head -n "$(($row-1))" $file | cat - "$file"_newfile | # MERGE TOP AND BOTTOM
    LC_ALL=C sort -u - -o "$file"_newfile		  # REMOVE DUPLICATE PAIRS
    mv "$file"_newfile $file				  # RENAME THE FILE
done
