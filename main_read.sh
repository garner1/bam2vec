#!/usr/bin/env bash

datadir=~/Work/dataset
samfile=~/Work/dataset/bliss/RM79_BICRO21/outdata_GTCGTATC/RM79_BICRO21.sam
thr=60				# threshodl on mapping quality 
len=9				# words' length, at the moment 3x3 consistently with the protvec algorithm with 3 aminoacid per word
window=2		# window to construct the context ex:4
distance=100		# max distance allowd btw reads to be considered in the same context
######################################
# use the bedopts tools to generate a bed file from a sam file
######################################

# java -jar ~/tools/picard-tools-2.1.0/picard.jar SortSam INPUT="$samfile" OUTPUT="$datadir"/sorted_reads.bam SORT_ORDER=coordinate # sort the samfile
# java -jar ~/tools/picard-tools-2.1.0/picard.jar MarkDuplicates INPUT="$datadir"/sorted_reads.bam OUTPUT="$datadir"/dedup_reads.bam METRICS_FILE=metrics.txt REMOVE_DUPLICATES=true # remove duplicates from samfile

# bam2bed < "$datadir"/dedup_reads.bam | # trasform to bed file
# awk -v threshold=$thr '$5 >= threshold'| # filter out low quality mapped reads
# cut -f-3,12 | # select only locations: chr start end read
# sort -k1,1 -k2,2n - > $datadir/bedFromBam.bed # !!!this contains pcr duplicates!!!

# # PAIRED CLOSEST READS UP TO SOME THRESHOLD DIST
# bedtools closest -a $datadir/bedFromBam.bed -b $datadir/bedFromBam.bed -io -d | awk -v d="$distance" '$NF <= d' | # each pair is counted twice
# awk -F"\t" -v dir="$datadir" '{print > dir"/sentences_"$1".txt"}'  # split by chromosome
# # READS WITH NO CLOSE ENOUGH SECOND READS
# bedtools closest -a $datadir/bedFromBam.bed -b $datadir/bedFromBam.bed -io -d | awk -v d="$distance" '$NF > d' | cut -f-4 | 
# # LC_ALL=C sort | LC_ALL=C uniq |
# awk -F"\t" -v dir="$datadir" '{print >> dir"/sentences_"$1".txt"}'  # split by chromosome

# # PRODUCE WORD-CONTEXT COUNT
# parallel python count_pairs.py {} $window $len ::: `ls $datadir/sentences_chr{?,??}.txt`  # file output is *_counter.txt
# parallel -k "cat {} | tr -d '(',')',\"'\" | tr ' ' '\t' > {}.aux && mv {}.aux {}" ::: `ls $datadir/sentences_chr{?,??}.txt_counter.txt`

# # PREPARE VOCABULARY: A 1TO1 WORD-INDEX MAP
# cat $datadir/sentences_chr{?,??}.txt_counter.txt | cut -f1 > $datadir/file_1 # sort wrt word
# cat $datadir/sentences_chr{?,??}.txt_counter.txt | cut -f2 > $datadir/file_2 # sort wrt context
# cat $datadir/file_? | LC_ALL=C sort -u | cat -n | awk '{print $2,$1}' > $datadir/vocabulary
# rm -f $datadir/file_{1,2}

# # ASSOCIATE MATRIX INDECES TO WORD-CONTEXT PAIRS: the final .mat has word-context-count-row-col format
# parallel "cat {}| LC_ALL=C sort -k1,1 | LC_ALL=C join -1 1 -2 1 -o 1.1,1.2,1.3,2.2 - '$datadir'/vocabulary | tr ' ' '\t' > {}.joined_1" ::: `ls $datadir/sentences_chr{?,??}.txt_counter.txt`
# parallel "cat {}| LC_ALL=C sort -k2,2 | LC_ALL=C join -1 2 -2 1 -o 1.1,1.2,1.3,1.4,2.2 - '$datadir'/vocabulary | tr ' ' '\t' > {.}.mat" ::: `ls $datadir/sentences_chr{?,??}.txt_counter.txt.joined_1`

# # COUNT THE MARGINALES OF EACH WORD AND CONTEXT
# parallel "cat {} | datamash -s -g 4 sum 3|LC_ALL=C sort -n -k1,1 > {.}.wordMarginale"  ::: `ls $datadir/sentences_chr{?,??}.txt_counter.txt.mat`
# parallel "cat {} | datamash -s -g 5 sum 3|LC_ALL=C sort -n -k1,1 > {.}.contextMarginale"  ::: `ls $datadir/sentences_chr{?,??}.txt_counter.txt.mat`

# # PREPARE THE SPARSE MATRIX IN COO FORMAT: WORD-CONTEXT-COUNT-WORDMARG-CONTEXTMARG-PMI
# parallel "LC_ALL=C sort -n -k4,4 {} | LC_ALL=C join -o 1.4,1.5,1.3,2.2  -1 4 -2 1 - {.}.wordMarginale | tr ' ' '\t' > {.}.file1" ::: `ls $datadir/sentences_chr{?,??}.txt_counter.txt.mat`
# parallel "LC_ALL=C sort -n -k2,2 {} | LC_ALL=C join -o 1.1,1.2,1.3,1.4,2.2  -1 2 -2 1 - {.}.contextMarginale | 
# awk '{print \$1,\$2,\$3,\$4,\$5,\$3/(\$4*\$5)}' | tr ' ' '\t' > {.}.normalized.mat" ::: `ls $datadir/sentences_chr{?,??}.txt_counter.txt.file1`

# for file in `ls $datadir/sentences_chr{?,??}.txt_counter.txt.normalized.mat`;
# do
#     name=`echo $file | cut -d '.' -f1 | cut -d '_' -f2`
#     D=`cat $file|wc -l` 
#     cat $file | awk -v D="$D" '{OFS="\t";print $1,$2,$3,$4,$5}' > $datadir/"$name".mat
# done

D=`cat $datadir/vocabulary|wc -l` # dimensionality of the vocabulary
k=2				  # shift factor
rank=3				  # truncation dim in svd
# parallel python cooccurrence_matrix.py {} $D $k ::: `ls $datadir/chr{?,??}.mat`
for file in `ls $datadir/chr{?,??}.mat`; 
do
    python cooccurrence_matrix.py $file $D $k $rank
done

rm -f $datadir/sentences_chr{?,??}.txt_* # clean directory

