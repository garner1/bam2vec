#! /usr/bin/python

from itertools import combinations
from collections import Counter
import os.path
import csv
import sys

def collect_pairs(file_name,window):
    pair_counter = Counter()
    with open(file_name, 'rb') as infile:
        for line in infile:
            lista = line.strip().split(',')
            for index1 in range(len(lista)):
                for index2 in range(index1+1,index1+window+1):
                    if index2 < len(lista): 
                        pair_counter[(lista[index1],lista[index2])] += 1
    return pair_counter

file_name = str(sys.argv[1])
window = int(sys.argv[2])
p = collect_pairs(file_name,window)

with open(file_name + "_counter.txt",'w') as f:
    for k,v in  p.most_common():
        f.write( "{} {}\n".format(k,v) )

