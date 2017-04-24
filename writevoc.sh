#!/usr/bin/env bash

filein=$1			# context_chr{?,??}.txt made of CHR START END SEQUENCE ROW# CHR START END SEQUENCE ROW#
fileout=$2			# context_chr{?,??}.txt.out
len=$3				# word length
window=$4			# window to contruct the context, ex: 4

##HERE WE CONSIDER ONLY THE FIRST READ IN PAIR
# rm -f $fileout
# touch $fileout
# while IFS='\t' read -r line; do
#     strlen=$(echo $line | awk '{print length($4)}') # evaluate length of the read sequence numb 1 
#     for begin in `seq 1 $len`; do		    # loop over differen starting points
# 	for pos in `seq $begin $len $(($strlen - $len))`; do # define words as windows of non-overlapping #len characters; loop over different words
#     	    word=`echo $line | awk -v start="$pos" -v len="$len" '{print substr($9,start,len)}'`
# 	    if [ "$pos" -ge "$(($strlen - $len -$len + 1))" ] # check if there is still an entire word after this one
# 	    then
#     		echo -en $word "\n" >> $fileout # insert newline only in this case
# 	    else
# 		echo -en $word"," >> $fileout # do not insert newline
# 	    fi
# 	done
#     done
# done < $filein

# # NOW YOU NEED TO COUNT WORD PAIRS IN EVERY ROW CONSIDERED AS A SENTENCE
python count_pairs.py $fileout $window

echo Done with $filein
