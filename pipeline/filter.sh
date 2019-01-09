#!/usr/bin/bash -l

#SBATCH -p short
#SBATCH --ntasks=2
#SBATCH --mem=100G
#SBATCH --time=2:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/bcf_filter.stdout
#SBATCH --job-name='filter'
#SBATCH --array=1-16

# set directories
WORK=/rhome/jmarz001/bigdata/CCXXIRAD/calls
cd $WORK
RESULT=/rhome/jmarz001/bigdata/CCXXIRAD/calls/bcftools_filtered
# define and generate file list
SEQS=$WORK/seqs
ls *.vcf > $SEQS

FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQS | tail -n 1)
NAME=$(basename "$FILE" | cut -d. -f1-2)

module load bcftools/1.8
# bcftools filter [options] <file>

bcftools view -i 'F_MISSING<0.5 & DP>0 & DP<4031 & QUAL>30 & N_ALT=1' $FILE -o $RESULT/$NAME.minalt.vcf

# INCLUDE: sites missing less than 50%, depth higher than 0 and less than 4031,
# N_ALT=1 makes only options ref/single alt allele (biallelic site instead of 4 alt alleles or something)
