#!/usr/bin/env bash

datadir=~/Work/dataset
samfile=~/Work/dataset/bliss/RM79_BICRO21/outdata_GTCGTATC/RM79_BICRO21.sam
thr=60				# threshodl on mapping quality 
len=9				# words' length, at the moment 3x3 consistently with the protvec algorithm with 3 aminoacid per word
contextRange=45		# extension of the context in bedtools window, at the moment 4x(word-length)

######################################
# use the bedopts tools to generate a bed file from a sam file
######################################

# java -jar ~/tools/picard-tools-2.1.0/picard.jar SortSam INPUT="$samfile" OUTPUT="$datadir"/sorted_reads.bam SORT_ORDER=coordinate # sort the samfile
# java -jar ~/tools/picard-tools-2.1.0/picard.jar MarkDuplicates INPUT="$datadir"/sorted_reads.bam OUTPUT="$datadir"/dedup_reads.bam METRICS_FILE=metrics.txt REMOVE_DUPLICATES=true # remove duplicates from samfile

# bam2bed < "$datadir"/dedup_reads.bam | # trasform to bed file
# awk -v threshold=$thr '$5 >= threshold'| # filter out low quality mapped reads
# cut -f-3,12 | # select only locations: chr start end
# LC_ALL=C sort | LC_ALL=C uniq -c | # count copies
# awk '{OFS="\t";print $2,$3,$4,$5,$1}' > $datadir/bedFromBam.bed 

# cp $datadir/bedFromBam.bed $datadir/bedFromBam_copy.bed 
# bedtools window -w $contextRange -a $datadir/bedFromBam.bed -b $datadir/bedFromBam_copy.bed > $datadir/context.bed

# awk -F"\t" -v dir="$datadir" '{print > dir"/context_"$1".txt"}' $datadir/context.bed # split by chromosome

# parallel "./unique_pairs.sh {}" ::: $(ls $datadir/context_chr{?,??}.txt) # find unique pairs of reads in each chromosome

####################################
# The files $datadir/context_chr*.txt contain the pairs of reads that will define the context
####################################

parallel bash writevoc.sh {} {}.out $len ::: `ls $datadir/context_chr{?,??}.txt` # this is not efficient enough



