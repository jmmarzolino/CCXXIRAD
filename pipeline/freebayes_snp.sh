#!/bin/bash -l

#SBATCH --ntasks=20
#SBATCH --time=168:00:00
#SBATCH --mem=200G
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/chr1.stdout
#SBATCH --job-name='chr1_snps'
#SBATCH -p koeniglab

WORK=/rhome/jmarz001/bigdata/CCXXIRAD/align
cd $WORK
RESULT=/rhome/jmarz001/bigdata/CCXXIRAD/calls
REF=/rhome/jmarz001/shared/GENOMES/NEW_BARLEY/GENOME_SPLIT/barley_split_reference.fa

module load freebayes/1.2.0

#freebayes -f [reference] [infiles.bam] > [outfiles.vcf]
freebayes -k -f $REF -r chr1H_1_279267716 $WORK/*.bam > $RESULT/rad.snps.chr1_1.freebayes.vcf

#population priors:
#-k --no-population-priors Equivalent to --pooled-discrete and removal of Ewens Sampling Formula priors

#-r --region <chrom>:<start_position>..<end_position>
#Limit analysis to the specified region, 0-base coordinates, end_position not included (same as BED format).