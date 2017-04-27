#! /usr/bin/python

from itertools import combinations
from collections import Counter
import os.path
import sys

def collect_pairs(file_name,window,wordsize):
    pair_counter = Counter()
    with open(file_name, 'rb') as infile:
        for line in infile:
            lista1 = line.strip().split('\t')
            lista2 = line.strip().split('\t')
            sentence = []
            for wordstart in range(wordsize): # loop over starting position of the word
                for startpos in xrange(wordstart,len(lista1[3]),wordsize): # loop over words in first sentence
                    word = lista1[3][startpos:startpos+wordsize]
                    if len(word) == 9: sentence.append(word)
                if len(lista2) > 4:
                    for startpos in xrange(wordstart,len(lista2[8]),wordsize): # loop over words in second sentence
                        word = lista2[8][startpos:startpos+wordsize]
                        if len(word) == 9: sentence.append(word)
                for index1 in range(len(sentence)): # count cooccurrences
                    for index2 in range(index1+1,index1+window+1):
                        if index2 < len(sentence): pair_counter[(sentence[index1],sentence[index2])] += 1
    return pair_counter
    
file_name = str(sys.argv[1])    # ex: $datadir/context_chr{?,??}.txt
window = int(sys.argv[2])
wordsize = int(sys.argv[3])

p = collect_pairs(file_name,window,wordsize)

with open(file_name + "_counter.txt",'w') as f:
    for k,v in  p.most_common():
        f.write( "{} {}\n".format(k,v) )

print 'Done with' + file_name
