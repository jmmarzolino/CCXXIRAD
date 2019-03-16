#!/usr/bin/bash -l

#SBATCH -p koeniglab
#SBATCH --ntasks=2
#SBATCH --mem=100G
#SBATCH --time=48:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/filter4.stdout
#SBATCH --job-name='filter'
#SBATCH --array=1-16%2

# set directories
WORK=/rhome/jmarz001/bigdata/CCXXIRAD/calls/filtered
cd $WORK
# define and generate file list
SEQS=$WORK/seqs
ls *.1.recode.vcf > $SEQS

FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQS | tail -n 1)
NAME=$(basename "$FILE" | cut -d. -f1-2)

awk '$5 > 0.999' $NAME.imiss | cut -f1 >> $NAME.high.missing.indv
awk '$5 > 0.99' $NAME.imiss | cut -f1 >> $NAME.low.missing.indv

find . -type f -name '*.high.missing.indv' -exec cat {} + >> high.missing.indv
find . -type f -name '*.low.missing.indv' -exec cat {} + >> low.missing.indv

SEQS=$WORK/lmiss
ls *.lmiss > $SEQS

FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQS | tail -n 1)
NAME=$(basename "$FILE" | cut -d. -f1-2)
# search the list for sites with 100% and 99.9% data missing, see if that would topple the data
awk '$5 > 0.999' $NAME.lmiss | cut -f1-2 >> $NAME.high.missing.loci.site
awk '$5 > 0.99' $NAME.lmiss | cut -f1-2 >> $NAME.low.missing.loci.site

find . -type f -name '*.high.missing.loci.site' -exec cat {} + >> high.missing.loci.sites
find . -type f -name '*.low.missing.loci.site' -exec cat {} + >> low.missing.loci.site
