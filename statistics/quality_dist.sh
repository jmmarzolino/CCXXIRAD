#!/usr/bin/bash -l

#SBATCH -p koeniglab
#SBATCH --ntasks=16
#SBATCH --mem=150G
#SBATCH --time=72:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/qual_dist.stdout
#SBATCH --job-name='qual'
#SBATCH --array=1-16

# creates stats read outs for each chr section, includes bins of allele frequency & quality bins and snp counts in each bin
# one approach is to strip the useful section's columns from this stats file and then feed this into R for making histograms
# or I could strip the useful columns and add the snp #'s together so then it can be read into R as a single set

WORK=/rhome/jmarz001/bigdata/CCXXIRAD/calls
cd $WORK
SEQS=$WORK/files
ls *.vcf > $SEQS
FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQS | tail -n 1)
RESULT=/rhome/jmarz001/bigdata/CCXXIRAD/calls/dist

grep "^chr" $FILE | cut -f6 > $RESULT/$FILE.quals
grep "^chr" $FILE | cut -f8 | cut -d\; -f8 | cut -d= -f2 > $RESULT/$FILE.depth
grep "^chr" $FILE | cut -f8 | cut -d\; -f4 | cut -d= -f2 > $RESULT/$FILE.allelefreq

cat $RESULT/$FILE.quals >> $RESULT/QUAL
cat $RESULT/$FILE.depth >> $RESULT/DP
cat $RESULT/$FILE.allelefreq >> $RESULT/AF
