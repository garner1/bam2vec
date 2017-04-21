#! /usr/bin/python

from itertools import combinations
from collections import Counter
import os.path
import csv
import sys

def collect_pairs(file_name):
    pair_counter = Counter()
    window = 2
    with open(file_name, 'rb') as infile:
        reader = csv.reader(infile,delimiter=',')
        for line in infile:
            lista = sorted(line.strip().split(','))
            for index1 in range(len(lista)):
                for index2 in range(index1+1,index1+window+1):
                    if index2 < len(lista): 
                        # print index1,index2
                        # print lista[index1],lista[index2]
                        pair_counter[(lista[index1],lista[index2])] += 1
    return pair_counter  # return the actual Counter object

file_name = str(sys.argv[1])
p = collect_pairs(file_name)

with open(file_name + "_counter.txt",'w') as f:
    for k,v in  p.most_common():
        f.write( "{} {}\n".format(k,v) )

# print p.most_common(2)

