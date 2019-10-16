#!/bin/bash -l

#SBATCH --ntasks=10
#SBATCH --mem-per-cpu=20G
#SBATCH --time=168:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/combined_CCXXI/scripts/cmd003_align.stdout
#SBATCH --job-name='align'
#SBATCH -p koeniglab
#SBATCH --array=1-468

module load minimap2 samtools
INDEX=/rhome/jmarz001/shared/GENOMES/BARLEY/2019_Release_Morex_vers2/Barley_Morex_V2_pseudomolecules.fasta
# minimap2 index
MINDEX=/rhome/jmarz001/shared/GENOMES/BARLEY/2019_Release_Morex_vers2/Barley.mmi
PROJECT_DIR=/rhome/jmarz001/bigdata/CCXXIRAD/combined_CCXXI
# Define location variables
TRIMMED=$PROJECT_DIR/data/trimmed
BAMS=${PROJECT_DIR}/data/bams
mkdir $BAMS

SEQS=${PROJECT_DIR}/args/trimmed_files
cd $TRIMMED ; ls *trimmed.fq.gz >> $SEQS

# Define files to run over
FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQS | tail -n 1)
# 267_188_trimmed.fq.gz -> 267_188_trimmed -> 267_188
sample_name=$(basename "$FILE" | cut -d. -f1 | cut -d_ -f1-2)



run_name=$(head -n ${SLURM_ARRAY_TASK_ID} $SEQS | tail -n 1 | cut -f3 | cut -d_ -f3)

##RGPU (String)	Read Group platform unit (eg. run barcode) Required.

##RGLB (String)	Read Group library Required.
#RGLB=<"24=F25, 267=F11, 25=F29">
#yields generation number
generation=$(basename "$FILE" | cut -d. -f1 | cut -d_ -f1)
# KL numbers
X=267 ; Y=24 ; Z=25

# if expression1 then statement1 else if expression2 then statement2 else statement3
if [ "$generation" == "$X" ]; then
  RGLB=F11
else if [ "$generation" == "$Y" ]; then
  RGLB=F25
else if [ "$generation" == "$Z" ]; then
  RGLB=F29
else
  RGLB=error
fi

# BWA mapping
bwa mem -R "@RG\tID:${sample_name}_${SLURM_ARRAY_TASK_ID}\tSM:${sample_name}\tPU:"illumina"\tLB:$RGLB" -t 10 $INDEX $TRIMMED/${sample_name}_${run_name}.fq.gz > $BAMS/bwa_${sample_name}_${run_name}.sam

# Minimap2 mapping
minimap2 -t 10 -ax sr $MINDEX \
-R "@RG\tID:${sample_name}_${SLURM_ARRAY_TASK_ID}\tSM:${sample_name}\tPU:illumina\tLB:$RGLB" \
$TRIMMED/${sample_name}_${run_name}.fq.gz \
> $BAMS/mini_${sample_name}_${run_name}.sam

# Get mapping stats
mkdir $BAMS/mappingstats/
samtools flagstat $BAMS/bwa_${sample_name}_${run_name}.sam > $BAMS/mappingstats/bwa_${sample_name}_${run_name}_mapstats.txt

samtools flagstat $BAMS/mini_${sample_name}_${run_name}.sam > $BAMS/mappingstats/mini_${sample_name}_${run_name}_mapstats.txt

# Convert sam to sorted bam and index bams with csi
samtools view -b -T $INDEX $BAMS/bwa_${sample_name}_${run_name}.sam | samtools sort -@ 20 > $BAMS/bwa_${sample_name}_${run_name}.bam
samtools index -c $BAMS/bwa_${sample_name}_${run_name}.bam

samtools view -b -T $INDEX $BAMS/mini_${sample_name}_${run_name}.sam | samtools sort -@ 20 > $BAMS/mini_${sample_name}_${run_name}.bam
samtools index -c $BAMS/mini_${sample_name}_${run_name}.bam
