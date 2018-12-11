#!/usr/bin/bash -l

#SBATCH -p koeniglab
#SBATCH --ntasks=15
#SBATCH --mem=150G
#SBATCH --time=72:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/qual_filter.stdout
#SBATCH --job-name='filter'
#SBATCH --array=1-384

WORKINGDIR=/rhome/jmarz001/bigdata/CCXXIRAD/calls
cd $WORKINGDIR
RESULTSDIR=/rhome/jmarz001/bigdata/CCXXIRAD/calls/filtered
SEQLIST=$WORKINGDIR/files
FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1)
NAME=$(basename "$FILE" | cut -d. -f1)

module load vcftools

vcftools --vcf $WORKINGDIR/$NAME.freebayes.vcf \
--minQ 30 --out $RESULTSDIR/$NAME.freebayes.rawsnpsQUAL30 --recode
