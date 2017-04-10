#!/usr/bin/env bash

filein=$1
fileout=$2

len=70				# hard-coded word length

rm -f $fileout
while IFS='\t' read -r line; do
    strlen=$(echo $line | awk '{print length($7)}') # evaluate length of the read sequence
    for pos in `seq 1 $(($strlen - $len))`; do
	word=`echo $line | awk -v start="$pos" -v len="$len" '{print substr($7,start,len)}'`
	echo $line | awk -v start="$pos" -v word="$word" -v len="$len" '{OFS="\t";print $1,$2+start-1,$2+start-1+len,$6,word}' >> $fileout
    done
done < $filein
