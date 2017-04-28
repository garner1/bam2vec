#! /usr/bin/python

from itertools import combinations
from collections import Counter
import os.path
import sys
import re

file_name = str(sys.argv[1])    # ex: $datadir/context_chr{?,??}.txt
window = int(sys.argv[2])
wordsize = int(sys.argv[3])

def collect_pairs(file_name,window,wordsize):
    pair_counter = Counter()
    with open(file_name, 'rb') as infile:
        for line in infile:
            lista = re.split('\W+',line.strip())
            context = []
            for read in lista[3:]: # loop over reads in lista
                for wordstart in range(wordsize): # loop over starting position of the word
                    for startpos in xrange(wordstart,len(read),wordsize): # loop over words in first read
                        word = read[startpos:startpos+wordsize]
                        if len(word) == wordsize : context.append(word)
            # now I have the context of all the reads, appended togheter; interpreting the gap btw reads as a full stop
            for index1 in range(len(context)): # count cooccurrences
                for index2 in range(index1+1,index1+window+1):
                    if index2 < len(context): pair_counter[(context[index1],context[index2])] += 1
    return pair_counter
    
p = collect_pairs(file_name,window,wordsize)

with open(file_name + "_counter.txt",'w') as f:
    for k,v in  p.most_common():
        f.write( "{} {}\n".format(k,v) )

print 'Done with' + file_name
