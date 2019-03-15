#!/usr/bin/bash -l

#SBATCH -p koeniglab
#SBATCH --ntasks=4
#SBATCH --mem=32G
#SBATCH --time=2:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/first_filter.stdout
#SBATCH --job-name='filter'
#SBATCH --array=1-16%4

WORK=/rhome/jmarz001/bigdata/CCXXIRAD/calls
cd $WORK
RESULT=/rhome/jmarz001/bigdata/CCXXIRAD/calls/filtered
# define and generate file list
SEQS=$WORK/seqs
ls *.freebayes.snps.vcf > $SEQS

FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQS | tail -n 1)
NAME=$(basename "$FILE" | cut -d. -f1-2)

module load vcftools

vcftools --vcf $FILE --max-missing 0.5 --minQ 30.0 --minDP 0.0 --maxDP 4031.0 --recode --recode-INFO-all --out $RESULT/$NAME.misQDP