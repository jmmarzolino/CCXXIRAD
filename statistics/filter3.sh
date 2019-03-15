#!/usr/bin/bash -l

#SBATCH -p koeniglab
#SBATCH --ntasks=2
#SBATCH --mem=32G
#SBATCH --time=48:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/filter3.stdout
#SBATCH --job-name='filter'
#SBATCH --array=1-16

# set directories
WORK=/rhome/jmarz001/bigdata/CCXXIRAD/calls
cd $WORK
RESULT=/rhome/jmarz001/bigdata/CCXXIRAD/calls/filtered
# define and generate file list
SEQS=$WORK/files
ls *.vcf > $SEQS

FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQS | tail -n 1)
NAME=$(basename "$FILE" | cut -d. -f1-2)

module load vcftools
# vcftools [ --vcf FILE | --gzvcf FILE | --bcf FILE] [ --out OUTPUT PREFIX ] [ FILTERING OPTIONS ] [ OUTPUT OPTIONS ]

#filtering based on two metrics I have density plots to base decisions off of, quality and density, first
vcftools --vcf $FILE --minQ 30 --minDP 30 --recode --recode-INFO-all --out $RESULT/$NAME.1
#file will come out as $NAME.1.recode.vcf

# take sites from ~400,000 to a 3/4 or 1/2 that ~250000-300000, which I'm fine with/seems reasonable

#then test the effect of minor allele count filters
vcftools --vcf $RESULT/$NAME.1.recode.vcf --mac 1 --recode --recode-INFO-all --out $RESULT/$NAME.mac1
vcftools --vcf $RESULT/$NAME.1.recode.vcf --mac 2 --recode --recode-INFO-all --out $RESULT/$NAME.mac2
vcftools --vcf $RESULT/$NAME.1.recode.vcf --mac 3 --recode --recode-INFO-all --out $RESULT/$NAME.mac3
vcftools --vcf $RESULT/$NAME.1.recode.vcf --mac 4 --recode --recode-INFO-all --out $RESULT/$NAME.mac4

# minor allele count also appears to be too strict for RAD data
# these filters, even the lowest at mac=1 takes Gig files down to Megs and sites down an order of magnitude from ~300,000 to max 20,000