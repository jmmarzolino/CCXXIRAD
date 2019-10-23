#!/bin/bash -l

#SBATCH --ntasks=10
#SBATCH --mem-per-cpu=20G
#SBATCH --time=168:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/combined_CCXXI/scripts/cmd004_call.stdout
#SBATCH --job-name='call snps'
#SBATCH -p koeniglab
#SBATCH --array=1-2
#468%10

module load freebayes/1.2.0
INDEX=/rhome/jmarz001/shared/GENOMES/BARLEY/2019_Release_Morex_vers2/Barley_Morex_V2_pseudomolecules.fasta
PROJECT_DIR=/rhome/jmarz001/bigdata/CCXXIRAD/combined_CCXXI

# Define location variables
BAMS=$PROJECT_DIR/data/bams
SNPS=$PROJECT_DIR/data/calls
mkdir $SNPS

SEQS=$PROJECT_DIR/args/bam_files
cd $BAMS ; ls *.bam > $SEQS

# Define files to run over
FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQS | tail -n 1)
# 267_188.bam -> 267_188
sample_name=$(basename "$FILE" | cut -d. -f1)

#freebayes -f [reference] [infiles.bam] > [outfiles.vcf]
freebayes -k -f $INDEX $BAMS/$FILE > $SNPS/rad_${sample_name}_rawsnps.vcf
