#!/usr/bin/env bash

filein=$1			# context_chr{?,??}.txt made of CHR START END SEQUENCE ROW# CHR START END SEQUENCE ROW#
len=$2				# word length
window=$3			# window to contruct the context, ex: 4

# COUNT WORD PAIRS IN EVERY ROW CONSIDERED AS A SENTENCE
python count_pairs.py $filein $window $len # file output is *_counter.txt

echo Done with $filein
