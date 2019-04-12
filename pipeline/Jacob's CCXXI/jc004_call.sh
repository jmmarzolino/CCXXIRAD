#!/bin/bash -l

#SBATCH --time=168:00:00
#SBATCH --ntasks=10
#SBATCH --mem-per-cpu=30G
#SBATCH --output=jc004_call.stdout
#SBATCH --job-name='jc004'
#SBATCH -p koeniglab
#SBATCH --array=1-16

BAM=/rhome/jmarz001/bigdata/CCXXIRAD/CCXXIRAD2/align
cd $BAM
SNP=/rhome/jmarz001/bigdata/CCXXIRAD/CCXXIRAD2/calls
REF=/rhome/jmarz001/shared/GENOMES/NEW_BARLEY/GENOME_SPLIT/barley_split_reference.fa

CHR=/rhome/jmarz001/bigdata/CCXXIRAD/chr_splits_freebayes.txt
REGION=$(head -n $SLURM_ARRAY_TASK_ID $CHR | tail -n 1)

module load freebayes/1.2.0

#freebayes -f [reference] [infiles.bam] > [outfiles.vcf]
freebayes -k -f $REF -r $REGION $BAM/*.bam > $SNP/rad.$REGION.vcf
