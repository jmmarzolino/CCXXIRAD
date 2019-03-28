#!/bin/bash -l

#SBATCH --ntasks=20
#SBATCH --time=168:00:00
#SBATCH --mem=200G
#SBATCH --output=ssv004.stdout
#SBATCH --job-name='ssv004'
#SBATCH -p koeniglab
#SBATCH --array=1-4

# check variant calling step
# seq file contains only these bams
# 267_179.bam
# 24_394.bam
# 267_74.bam
# 24_311.bam

BAM=/rhome/jmarz001/bigdata/CCXXIRAD/align/ssv
cd $BAM
RESULT=/rhome/jmarz001/bigdata/CCXXIRAD/calls/ssv
mkdir $RESULT
REF=/rhome/jmarz001/shared/GENOMES/NEW_BARLEY/GENOME_SPLIT/barley_split_reference.fa

REGION=$(head -n 1 /rhome/jmarz001/bigdata/CCXXIRAD/calls/chr_splits.txt)

module load freebayes/1.2.0

#freebayes -f [reference] [infiles.bam] > [outfiles.vcf]
freebayes -k -f $REF -r $REGION $BAM* > $RESULT/rad.$REGION.freebayes.snps.vcf
