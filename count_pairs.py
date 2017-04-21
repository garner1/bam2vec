#! /usr/bin/python

from itertools import combinations
from collections import Counter
import os.path
import csv
import sys

def collect_pairs(file_name):
    pair_counter = Counter()
    with open(file_name, 'rb') as infile:
        reader = csv.reader(infile,delimiter=',')
        for line in infile:
            your_list = sorted(line.strip().split(','))
            combos = combinations(your_list, 2)
            pair_counter += Counter(combos)
    return pair_counter  # return the actual Counter object

# dir_name = '/home/garner1/Work/dataset' 
# base_filename = 'testfile2.txt'
# file_name = os.path.join(dir_name, base_filename)

file_name = str(sys.argv[1])
p = collect_pairs(file_name)

with open(file_name + "_counter.txt",'w') as f:
    for k,v in  p.most_common():
        f.write( "{} {}\n".format(k,v) )

# print p.most_common(2)
