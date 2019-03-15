#!/usr/bin/bash -l

#SBATCH -p koeniglab
#SBATCH --ntasks=5
#SBATCH --mem=150G
#SBATCH --time=72:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/qual_filter.stdout
#SBATCH --job-name='filter'
#SBATCH --array=1-16

WORK=/rhome/jmarz001/bigdata/CCXXIRAD/calls
cd $WORK
RESULT=/rhome/jmarz001/bigdata/CCXXIRAD/calls/filtered
SEQS=$WORK/files
ls *.vcf > $SEQS
FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQS | tail -n 1)

module load bcftools/1.8

# bcftools stats [options] A.vcf.gz [B.vcf.gz]
bcftools stats $FILE > $RESULT/$FILE.stats
