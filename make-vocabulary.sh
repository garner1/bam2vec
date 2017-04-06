#!/usr/bin/env bash

datadir=~/Work/dataset
samfile=~/Work/dataset/bliss/RM79_BICRO21/outdata_GTCGTATC/RM79_BICRO21.sam
thr=30				# threshodl on mapping quality 
len=15				# words' length

# use the bedopts tools to generate a bed file from a sam file
# sam2bed < $samfile | awk -v threshold=$thr '$5 >= threshold'| cut -f-6,12 > $datadir/bedfile.bed 

# filter on quality?

# head $datadir/bedfile.bed > testfile.txt

cd $datadir
rm -f x*
split -C 10m $datadir/bedfile.bed 
cd -

parallel 'bash writevoc.sh {} {}.out' ::: `ls $datadir/x*`
cat $datadir/*.out > $datadir/vocabulary.bed


