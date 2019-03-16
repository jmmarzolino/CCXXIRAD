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

#bcftools view -H N_PASS(F_MISSING<0.98) $FILE -o pass.missing.vcf
#bcftools view -H MAX(F_MISSING) $FILE -o maxmiss.vcf
#bcftools view -H MIN(F_MISSING) $FILE -o minmiss.vcf

# extract allele frequency at each position
bcftools query -f '%CHROM %POS %AF\n' $FILE -o AF.vcf

# extract individual genotypes
bcftools query -f '%CHROM %POS[\t%GT]\n' $FILE -o genotype.vcf