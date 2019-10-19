#!/usr/bin/bash -l

#SBATCH -p short
#SBATCH --ntasks=2
#SBATCH --mem=100G
#SBATCH --time=2:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/combined_CCXXI/filter001.stdout
#SBATCH --job-name='filter'
#SBATCH --array=1-4
#468%25

module load bcftools/1.8
# Define directories
PROJECT_DIR=/rhome/jmarz001/bigdata/CCXXIRAD/combined_CCXXI
SNPS=$PROJECT_DIR/data/calls
FILT=$SNPS/filter
mkdir $FILT
# define file list
SEQS=$PROJECT_DIR/args/vcf_files
ls $SNPS/*.vcf > $SEQS

FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQS | tail -n 1)
sample_name=$(basename "$FILE" | cut -d_ -f2-3)

# get the stats you need!
bcftools stats $FILE > $RESULT/${sample_name}.stats

# bcftools filter [options] <file>
# INCLUDE: sites missing less than 50%, depth higher than 0 and less than 4031,
# N_ALT=1 makes only options ref/single alt allele (biallelic site instead of 4 alt alleles or something)
#bcftools view -i 'F_MISSING<0.5 && DP>0 & DP<4031 && QUAL>30 && N_ALT=1 && COUNT(GT="het")<124 && COUNT(GT="alt")>0 && COUNT(GT="ref")>0' $FILE -o $FILT/${sample_name}_filt001.vcf
#ls $FILT/*_filt001.vcf > $PROJECT_DIR/args/filtered_vcf_files
#bcftools concat --file-list $PROJECT_DIR/args/filtered_vcf_files -o $FILT/CCXXIRAD.genomesnps.vcf
