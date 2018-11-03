#!/usr/bin/env python

"""
Compute the average quality for a given FASTQ file.

You can use this script from the shell like this:
$ fastq_avg_qual < reads.fastq
"""

# Iterative mean #
def imean(numbers):
    count = 0
    total = 0
    for num in numbers:
        count += 1
        total += num
    return float(total)/count

# Do it #
import sys
from Bio import SeqIO
records = (r for r in SeqIO.parse(sys.stdin, "fastq"))
scores = (s for r in records for s in r.letter_annotations["phred_quality"])
print imean(scores) >> outfile.txt