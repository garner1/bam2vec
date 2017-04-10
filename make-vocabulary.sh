#!/usr/bin/env bash

datadir=~/Work/dataset
samfile=~/Work/dataset/bliss/RM79_BICRO21/outdata_GTCGTATC/RM79_BICRO21.sam
thr=30				# threshodl on mapping quality 
len=70				# words' length

######################################
# use the bedopts tools to generate a bed file from a sam file
######################################
# sam2bed < $samfile | awk -v threshold=$thr '$5 >= threshold'| cut -f-3,6,12 > $datadir/bedfile_1.bed 
cp $datadir/bedfile_1.bed $datadir/bedfile_2.bed 

# cd $datadir
# rm -f x*
# split -C 10m $datadir/bedfile.bed 
# cd -

# #REMEMBER to set the len var in the code!!!!
# parallel 'bash writevoc.sh {} {}.out' ::: `ls $datadir/x*`
# cat $datadir/*.out > $datadir/vocabulary.bed

# rm $datadir/x*			# clean the data directory

# ######################################
# # Split vocabulary.bed per chromosome
# ######################################
# cd $datadir
# awk -F"\t" '{print > "vocabulary_"$1".bed"}' < $datadir/vocabulary.bed 
# cd -
# rm $datadir/vocabulary.bed 


