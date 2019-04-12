#!/usr/bin/bash -l
#SBATCH -p short
#SBATCH --ntasks=2
#SBATCH --mem=100G
#SBATCH --time=2:00:00
#SBATCH --output=jc005_filt.stdout
#SBATCH --job-name='jc005'
#SBATCH --array=1-16
#
module load bcftools/1.8
SNP=/rhome/jmarz001/bigdata/CCXXIRAD/CCXXIRAD2/calls
FILT=/rhome/jmarz001/bigdata/CCXXIRAD/CCXXIRAD2/calls/filter
cd $FILT
ls $SNP/*.vcf | cut -d. -f1-2 > $SNP/seqs
FILE=$(head -n $SLURM_ARRAY_TASK_ID $SNP/seqs | tail -n 1)

bcftools view -i 'F_MISSING<0.5 & DP>1 & DP<4031 & QUAL>30 & N_ALT=1' $SNP/$FILE.vcf -o $FILE.minalt.vcf
bcftools view -i 'COUNT(GT="het")<124 && COUNT(GT="alt")>0 && COUNT(GT="ref")>0' $FILE.minalt.vcf -o $FILE.gtcounts.vcf
