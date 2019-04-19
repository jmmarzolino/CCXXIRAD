#!/usr/bin/bash -l

#SBATCH -p short
#SBATCH --ntasks=2
#SBATCH --mem=100G
#SBATCH --time=2:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/bcf_filter.stdout
#SBATCH --job-name='filter'
#SBATCH --array=1-16

# set directories
WORK=/rhome/jmarz001/bigdata/CCXXIRAD/calls/bcftools_filtered
cd $WORK
# define and generate file list
SEQS=$WORK/seqs
ls *.minalt.vcf > $SEQS

FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQS | tail -n 1)
NAME=$(basename "$FILE" | cut -d. -f1-2)

module load bcftools/1.8
# bcftools filter [options] <file>
bcftools view -i 'COUNT(GT="het")<124 && COUNT(GT="alt")>0 && COUNT(GT="ref")>0' $FILE -o $NAME.gtcounts.vcf
