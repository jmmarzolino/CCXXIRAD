#!/usr/bin/bash -l

#SBATCH -p short
#SBATCH --ntasks=4
#SBATCH --mem=60G
#SBATCH --time=2:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/indv_het_sites.stdout
#SBATCH --job-name='indv_geno'

module load bcftools/1.8
WORK=/rhome/jmarz001/bigdata/CCXXIRAD/calls/bcftools_filtered
cd $WORK
FILE=CCXXIRAD.genomesnps.vcf








Does not work











# Step 1, bcftools query -f '%CHROM \t %POS \^' temp.vcf
# Step 2, bcftools query -f '[%GT]'
# Step 3, Format GT & AD
# Step 4, cut -f1 | sort | unique -c
# Step 5, in R: table

bcftools query --format '%CHROM \t %POS \t [ %GT] \t \n' $FILE -o $WORK/chr_pos_sam_gt.vcf

bcftools query -f '%CHROM \t %POS \t [ %GT="hom"]\n' $FILE -o homoindv
bcftools query -f '[%GT]="het"\n' $FILE -o hetindv
bcftools query -f '[%GT]="ref"\n' $FILE -o refindv
bcftools query -f '[%GT]="alt"\n' $FILE -o altindv

bcftools view N_PASS(F_MISSING<0.98) -o pass.missing.vcf
bcftools view MAX(F_MISSING)
bcftools view MIN(F_MISSING)

# %AF = allele frequency, or calculate with AN and AC
# Per-sample tags: FORMAT tags, extract with square brackets

#List of samples
bcftools query -l file.bcf
bcftools query -l $FILE > samples.txt
#Number of samples
bcftools query -l file.bcf | wc -l
#List of positions
bcftools query -f '%POS\n' file.bcf