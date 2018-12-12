#!/usr/bin/bash -l

#SBATCH -p koeniglab
#SBATCH --ntasks=5
#SBATCH --mem=100G
#SBATCH --time=168:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/filter2.stdout
#SBATCH --job-name='filter2'
#SBATCH --array=1-384%5

WORK=/rhome/jmarz001/bigdata/CCXXIRAD/calls
cd $WORK
RESULT=/rhome/jmarz001/bigdata/CCXXIRAD/calls/filtered
SEQS=$WORK/files
FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQS | tail -n 1)
NAME=$(basename "$FILE" | cut -d. -f1)

module load bcftools/1.8
# bcftools filter [options] <file>
vcftools --vcf $NAME.vcf --max-missing 0.5 --mac 3 --minDP 3 --recode --recode-INFO-all --out $NAME.g5mac3