#!/bin/bash -l

#SBATCH --ntasks=10
#SBATCH --mem-per-cpu=20G
#SBATCH --time=02:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/combined_CCXXI/scripts/cmd003_align.stdout
#SBATCH --job-name='align'
#SBATCH -p short
#SBATCH --array=1-468

module load samtools/1.9
PROJECT_DIR=/rhome/jmarz001/bigdata/CCXXIRAD/combined_CCXXI
# Define location variables
BAMS=$PROJECT_DIR/data/bams
SEQS=$PROJECT_DIR/args/bam_files
cd $BAMS ; ls *.bam > $SEQS

# Define files to run over
FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQS | tail -n 1)
# 267_188_trimmed.fq.gz -> 267_188_trimmed -> 267_188
sample_name=$(basename "$FILE" | cut -d. -f1 | cut -d_ -f1-2)

# Get mapping stats out of bams
mkdir $BAMS/mappingstats/
samtools flagstat $BAMS/${sample_name}.bam > $BAMS/mappingstats/${sample_name}_mapstats.txt

head -n5 24_290_mapstats.txt | tail -n1 | cut -d\  -f1
