#!/usr/bin/bash -l

#SBATCH -p batch
#SBATCH --ntasks=2
#SBATCH --mem=32G
#SBATCH --time=48:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/vcf_stats.stdout
#SBATCH --job-name='filter'

# set directories
WORK=/rhome/jmarz001/bigdata/CCXXIRAD/calls/bcftools_filtered
cd $WORK
FILE=CCXXIRAD.genomesnps.vcf
module load vcftools/0.1.13
NAME=$(basename $FILE | cut -d. -f1-2)

vcftools --vcf $FILE --missing-indv --out $NAME
#--missing-indv  Generates a file reporting the missingness on a per-individual basis. The file has the suffix ".imiss"
#file will come out as $NAME.1.recode.imiss

vcftools --vcf $FILE --depth --out $NAME
#--depth Generates a file containing the mean depth per individual. This file has the suffix ".idepth".

vcftools --vcf $FILE --het --out $NAME
#--het Calculates a measure of heterozygosity on a per-individual basis. Specfically, the inbreeding coefficient, F, is estimated for each individual using a method of moments. The resulting file has the suffix ".het".

vcftools --vcf $FILE --freq --out $NAME
#To determine the frequency of each allele over all individuals. suffix = .frq

vcftools --vcf $FILE --counts --out $NAME
# raw allele counts for each site  .frq.count
