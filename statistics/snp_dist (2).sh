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
ls *.freebayes.vcf.stats > stats
SEQS=$WORK/stats
FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQS | tail -n 1)

mkdir dist
RESULT=/rhome/jmarz001/bigdata/CCXXIRAD/calls/dist/

OUT1=$RESULT/allele_freq #these are non-ref allele frequencies
OUT2=$RESULT/quality

# find the file ID, number of records (reads), and number of snps
# write them into the out file, and then copy the allele frequencies
ID=(grep "^ID[^D]" $FILE | cut -f3)
RECS=(grep "number of records:" $FILE | cut -f3-4)
SNPS=(grep "number of SNPs:" $FILE | cut -f3-4)
printf "$ID\n $RECS\n $SNPS\n" >> $OUT1
grep "^AF" $FILE >> $OUT1


# print the same header info (ID, #reads, #snps) and then copies quality
printf "$ID\n $RECS\n $SNPS\n" >> $OUT2
grep "^QUAL" $FILE >> $OUT2


#check the distribution of snps to see if there are outliers, talk to chris
#calculate distribution of calls for each individual: missing data % per individual, what % homozygous alt/ref and what % het

#depth of the variant, or site, quality: plot distribution and look for outliers, outlier threshhold and apply filters
#filter out variants called one or two times and points covered too high (repetative)
#bcftools...querry: extract specific fields

#20x real to 50x bad
#use het and depth
#high hetero can be contamination: look for missing sample next to it and too high hetero
#true hetero are rare and won't be at every site

#haplotype variant call, ie limit the variant proximity