#!/usr/bin/bash -l

#SBATCH -p koeniglab
#SBATCH --ntasks=1
#SBATCH --mem=15G
#SBATCH --time=72:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/qual_filter.stdout
#SBATCH --job-name='filter'
#SBATCH --array=1-384%1

# created stats read outs for each file in the RAD 384 set, include (usefully) bins of allele frequency & quality bins and snp counts in each bin for each file
# one approach is to strip the useful section's columns from this stats file and then feed this into R for making histograms
# or I could strip the useful columns and add the snp #'s together so then it can be read into R as a single set

# take in every stats file from the directory
WORK=/rhome/jmarz001/bigdata/CCXXIRAD/calls
cd $WORK
SEQS=$WORK/files
FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQS | tail -n 1)
RESULT=/rhome/jmarz001/bigdata/CCXXIRAD/calls/dist/

grep "^chr" $FILE | cut -f6 > $RESULT/quality

