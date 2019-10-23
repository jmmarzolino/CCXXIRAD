#!/bin/bash -l

#SBATCH --ntasks=10
#SBATCH --mem-per-cpu=20G
#SBATCH --time=168:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/combined_CCXXI/scripts/cmd003_align.stdout
#SBATCH --job-name='align'
#SBATCH -p koeniglab
#SBATCH --array=1-468%10

module load minimap2/2.17 samtools/1.9
MINDEX=/rhome/jmarz001/shared/GENOMES/BARLEY/2019_Release_Morex_vers2/Barley.mmi # minimap2 index
INDEX=/rhome/jmarz001/shared/GENOMES/BARLEY/2019_Release_Morex_vers2/Barley_Morex_V2_pseudomolecules.fasta
PROJECT_DIR=/rhome/jmarz001/bigdata/CCXXIRAD/combined_CCXXI
# Define location variables
TRIMMED=$PROJECT_DIR/data/trimmed
BAMS=$PROJECT_DIR/data/bams
mkdir $BAMS

SEQS=$PROJECT_DIR/args/trimmed_files
cd $TRIMMED ; ls *trimmed.fq.gz > $SEQS

# Define files to run over
FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQS | tail -n 1)
# 267_188_trimmed.fq.gz -> 267_188_trimmed -> 267_188
sample_name=$(basename "$FILE" | cut -d. -f1 | cut -d_ -f1-2)

##RGPU (String)	Read Group platform unit (eg. run barcode) Required.

##RGLB (String)	Read Group library Required.
# RGLB=<"24=F25, 267=F11, 25=F29">
# yields generation number
generation=$(basename "$FILE" | cut -d. -f1 | cut -d_ -f1)
# KL numbers
X=267
Y=24
Z=25

if [ "$generation" == "$X" ]
then
  RGLB=F11
elif [ "$generation" == "$Y" ]
then
  RGLB=F25
elif [ "$generation" == "$Z" ]
then
  RGLB=F29
else
  RGLB=error
fi

# Minimap2 mapping
minimap2 -t 10 -ax sr $MINDEX -R "@RG\tID:${sample_name}_${SLURM_ARRAY_TASK_ID}\tSM:${sample_name}\tPU:illumina\tLB:$RGLB" $TRIMMED/$FILE > $BAMS/${sample_name}.sam
# Convert sam to sorted bam and index bams with csi
samtools view -b -T $INDEX $BAMS/${sample_name}.sam | samtools sort -@ 20 > $BAMS/${sample_name}.bam
samtools index -c $BAMS/${sample_name}.bam
# Get mapping stats out of bams
mkdir $BAMS/mappingstats/
samtools flagstat $BAMS/${sample_name}.bam > $BAMS/mappingstats/${sample_name}_mapstats.txt

# extract & export unmapped reads
#samtools view -f4 -b $RESULTSDIR/"$SHORT".bam > $RESULTSDIR/"$SHORT".unmapped.bam
#bedtools bamtofastq -i $RESULTSDIR/"$SHORT".unmapped.bam -fq $RESULTSDIR/"$SHORT".unmapped.fq
