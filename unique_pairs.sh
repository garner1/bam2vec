#!/usr/bin/env bash

# RETAIN ONLY UNIQUE PAIRS

file=$1				# input file of pairs

cat -n $file | awk '{print $1"\t"$2"_"$3"_"$4"_"$5"_"$6"_"$7"_"$8"_"$9"_"$10"_"$11}' | LC_ALL=C sort -k2,2 > "$file"_1
cat -n $file | awk '{print $1"\t"$7"_"$8"_"$9"_"$10"_"$11"_"$2"_"$3"_"$4"_"$5"_"$6}' | LC_ALL=C sort -k2,2 > "$file"_2
LC_ALL=C join -1 2 -2 2 "$file"_1 "$file"_2 | awk '$2 <= $3' | cut -d' ' -f1 | tr '_' '\t' | LC_ALL=C sort -u > "$file"
rm -f "$file"_{1,2}
echo "Done with " $file
