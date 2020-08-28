#!/usr/bin/bash -l

#SBATCH -p short
#SBATCH --ntasks=1
#SBATCH --mem=65G
#SBATCH --time=2:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/combined_CCXXI/scripts/filter001.stdout
#SBATCH --job-name='filter'
#SBATCH --array=1-468%5

module load bcftools/1.10 perl/5.24.0
# Define directories
PROJECT_DIR=/rhome/jmarz001/bigdata/CCXXIRAD/combined_CCXXI
SNPS=$PROJECT_DIR/data/calls
FILT=$SNPS/filter
#mkdir $FILT
# define file list
SEQS=$PROJECT_DIR/args/vcf_files
#cd $SNPS; ls *.vcf > $SEQS

FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQS | tail -n 1)
sample_name=$(basename $FILE | cut -d_ -f2-3)

# get the stats you need!
#bcftools stats $SNPS/$FILE > $FILT/${sample_name}.stats

# bcftools filter [options] <file>
bcftools view -i 'F_MISSING<0.5 && INFO/DP>0 && INFO/DP<4031 && QUAL>30 && N_ALT=1' $SNPS/$FILE -o $FILT/${sample_name}_filt001.vcf
#&& COUNT(GT="het")<124 && COUNT(GT="alt")>0 && COUNT(GT="ref")>0

bcftools stats $FILT/${sample_name}_filt001.vcf > $FILT/${sample_name}_filt001.stats
