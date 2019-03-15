#!/usr/bin/bash -l

#SBATCH -p koeniglab
#SBATCH --ntasks=16
#SBATCH --mem=150G
#SBATCH --time=72:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/snp_stats.stdout
#SBATCH --job-name='stats'
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

module load bcftools/1.8

# bcftools stats [options] A.vcf.gz [B.vcf.gz]
bcftools stats $FILE > $RESULT/$FILE.stats

mkdir dist
OUT1=$RESULT/allele_freq #these are non-ref allele frequencies
OUT2=$RESULT/quality
OUT3=$RESULT/depth

# find the file ID, number of records (reads), and number of snps
# write them into the out file, and then copy the allele frequencies
#ID=(grep "^ID[^D]" $FILE | cut -f3)
RECS=(grep "number of records:" $RESULT/$FILE.stats)
SNPS=(grep "number of SNPs:" $RESULT/$FILE.stats)
printf "$FILE\n $RECS\n $SNPS\n" >> $RESULT/$FILE
grep "^AF" $FILE >> $OUT1
grep "^QUAL" $FILE >> $OUT2
grep "^DP" $FILE >> $OUT3