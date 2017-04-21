#!/usr/bin/env bash

filein=$1
fileout=$2
len=$3

##HERE WE CONSIDER ONLY THE FIRST READ IN PAIR
rm -f $fileout
touch $fileout
while IFS='\t' read -r line; do
    strlen=$(echo $line | awk '{print length($4)}') # evaluate length of the read sequence numb 1
    for begin in `seq 1 $len`; do
	for pos in `seq $begin $len $(($strlen - $len))`; do
    	    word=`echo $line | awk -v start="$pos" -v len="$len" '{print substr($9,start,len)}'`
	    if [ "$pos" -ge "$(($strlen - $len -$len + 1))" ] 
	    then
    		echo -en $word "\n" >> $fileout # insert newline only in this case
	    else
		echo -en $word"," >> $fileout # do not insert newline
	    fi
	done
    done
done < $filein

# # NOW YOU NEED TO COUNT WORD PAIRS BY ALIGNING THE LIST OF WORDS WITH THE PROGRESSIVELY TRANSLATED ONES
python count_pairs.py $fileout

echo Done with $filein
