#!/usr/bin/env bash

filein=$1
fileout=$2

len=70				# hard-coded word length

rm -f $fileout
touch $fileout
while IFS='\t' read -r line; do
    strlen_1=$(echo $line | awk '{print length($4)}') # evaluate length of the read sequence numb 1
    strlen_2=$(echo $line | awk '{print length($9)}') # evaluate length of the read sequence numb 2
    for pos in `seq 1 $(($strlen_1 - $len))`; do
    	word=`echo $line | awk -v start="$pos" -v len="$len" '{print substr($4,start,len)}'`
	echo -en $word "\t" >> $fileout # do not insert newline
    done
    for pos in `seq 1 $(($strlen_2 - $len))`; do
    	word=`echo $line | awk -v start="$pos" -v len="$len" '{print substr($9,start,len)}'`
	if [ $pos == $(($strlen_2 - $len)) ] 
	then
    	    echo -en $word "\n" >> $fileout # insert newline only in this case
	else
	    echo -en $word "\t" >> $fileout # do not insert newline
	fi
    done
    # NOW YOU NEED TO COUNT WORD PAIRS BY ALIGNING THE LIST OF WORDS WITH THE PROGRESSIVELY TRANSLATED ONES
done < $filein
