#!/usr/bin/bash -l

#SBATCH -p koeniglab
#SBATCH --ntasks=4
#SBATCH --mem=60G
#SBATCH --time=168:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/bcf_query.stdout
#SBATCH --job-name='indv_geno'
#SBATCH --array=1-16%2

WORK=/rhome/jmarz001/bigdata/CCXXIRAD/calls/bcftools_filtered
cd $WORK
FILE=CCXXIRAD.genomesnps.vcf
module load bcftools/1.8

# Goal: to generate file with info:
# individual \t  hetero sites \t  homo sites ...
# Step 1, bcftools query -f '%CHROM \t %POS \^' temp.vcf
# Step 2, bcftools query -f '[%GT]'
# Step 3, Format GT & AD
# Step 4, cut -f1 | sort | unique -c
# Step 5, in R: table

#bcftools query -i '[GT]="hom"' $FILE -o homois
#bcftools query -i '[GT]="het"' $FILE -o hetis
#bcftools query -i '[GT]="ref"' $FILE -o refis
#bcftools query -i '[GT]="alt"' $FILE -o altis

#bcftools view -H N_PASS(F_MISSING<0.98) $FILE -o pass.missing.vcf
#bcftools view -H MAX(F_MISSING) $FILE -o maxmiss.vcf
#bcftools view -H MIN(F_MISSING) $FILE -o minmiss.vcf

bcftools query -f '%CHROM %POS %AF\n' $FILE -o AF.vcf
# extract allele frequency at each position

#Extracting per-sample tags
#FORMAT tags can be extracted using the square brackets [] operator, which loops over all samples. For example, to print the GT field followed by PL field we can write:

bcftools query -f '%CHROM %POS[\t%GT]\n' $FILE -o genotype.vcf