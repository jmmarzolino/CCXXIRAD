#!/usr/bin/bash -l

#SBATCH -p short
#SBATCH --ntasks=2
#SBATCH --mem=100G
#SBATCH --time=2:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/bcf_filter.stdout
#SBATCH --job-name='filter'
#SBATCH --array=1-16

# set directories
WORK=/rhome/jmarz001/bigdata/CCXXIRAD/calls
cd $WORK
RESULT=/rhome/jmarz001/bigdata/CCXXIRAD/calls/bcftools_filtered
# define and generate file list
SEQS=$WORK/seqs
ls *.vcf > $SEQS

FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQS | tail -n 1)
NAME=$(basename "$FILE" | cut -d. -f1-2)

module load bcftools/1.8
# bcftools filter [options] <file>
bcftools view -i 'F_MISSING<0.5 & DP>0 & DP<4031 & QUAL>30' $FILE -o $RESULT/$NAME.min.vcf

bcftools view -i 'F_MISSING<0.5 & DP>0 & DP<4031 & QUAL>30 & N_ALT=1' $FILE -o $RESULT/$NAME.minalt.vcf

bcftools view -i 'F_MISSING<0.5 & DP>0 & DP<4031 & QUAL>30 & N_ALT=1 & COUNT(GT="het")<124 & COUNT(GT="alt")>0 & COUNT(GT="ref")>0' $FILE -o $RESULT/$NAME.124.vcf
bcftools view -i 'F_MISSING<0.5 & DP>0 & DP<4031 & QUAL>30 & N_ALT=1 & COUNT(GT="het")<55 & COUNT(GT="alt")>0 & COUNT(GT="ref")>0' $FILE -o $RESULT/$NAME.55.vcf
bcftools view -i 'F_MISSING<0.5 & DP>0 & DP<4031 & QUAL>30 & N_ALT=1 & COUNT(GT="het")<21 & COUNT(GT="alt")>0 & COUNT(GT="ref")>0' $FILE -o $RESULT/$NAME.21.vcf
bcftools view -i 'F_MISSING<0.5 & DP>0 & DP<4031 & QUAL>30 & N_ALT=1 & COUNT(GT="het")<10 & COUNT(GT="alt")>0 & COUNT(GT="ref")>0' $FILE -o $RESULT/$NAME.10.vcf
bcftools view -i 'F_MISSING<0.5 & DP>0 & DP<4031 & QUAL>30 & N_ALT=1 & COUNT(GT="het")<5 & COUNT(GT="alt")>0 & COUNT(GT="ref")>0' $FILE -o $RESULT/$NAME.5.vcf
bcftools view -i 'F_MISSING<0.5 & DP>0 & DP<4031 & QUAL>30 & N_ALT=1 & COUNT(GT="het")<3 & COUNT(GT="alt")>0 & COUNT(GT="ref")>0' $FILE -o $RESULT/$NAME.3.vcf

# INCLUDE: sites missing less than 50%, depth higher than 0 and less than 4031,
# N_ALT=1 makes only options ref/single alt allele (biallelic site instead of 4 alt alleles or something)
# COUNT(GT="ref"/alt) ensures that each included site has at least one alt and ref read (ie. not all mistakes)
# COUNT(GT='het') ensures each site has fewer than # of heterozygous calls. no site is expected to be highly hetero in a 98% selfing species
# experimenting with site heterozygosity of 124, 55, 21, 10, 5...possibly more
# 124, 55, and 21 are based off of various values calculated from split chromosome median +/- factor*IQR from SPLIT CHR HET TOTALS, meaning they may be far too high for a per site threshhold; this is why I introduced a sampling of lower values like 10, 5, etc. for comparison

#MIN(DV)>5
#MIN(DV/DP)>0.3
#MIN(DP)>10 & MIN(DV)>3
#FMT/DP>10  & FMT/GQ>10 .. both conditions must be satisfied within one sample
#FMT/DP>10 && FMT/GQ>10 .. the conditions can be satisfied in different samples
#COUNT(GT="hom")=0
#MIN(DP)>35 && AVG(GQ)>50

#N_ALT number of alternate alleles
#N_SAMPLES number of samples
#AC count of alternate alleles
#MAC minor allele count (similar to AC but is always smaller than 0.5)
#AF frequency of alternate alleles (AF=AC/AN)
#MAF frequency of minor alleles (MAF=MAC/AN)
#AN number of alleles in called genotypes
#N_MISSING number of samples with missing genotype
#F_MISSING fraction of samples with missing genotype

#the number (N_PASS) or fraction (F_PASS) of samples which pass the expression
# N_PASS(GQ>90 & GT!="mis") > 90