#!/bin/bash -l

#SBATCH --ntasks=10
#SBATCH --mem-per-cpu=30G
#SBATCH --time=168:00:00
#SBATCH --output=jc003_align.stdout
#SBATCH --job-name='jc003'
#SBATCH -p batch
#SBATCH --array=1-96

# BWA Alignment into raw sorted alignment
# then sam to sorted bam
# bwa mem ref reads.fq > aln.sam
# assign read groups and get mapping statistics

module load bwa samtools bedtools

TRIM=/rhome/jmarz001/bigdata/CCXXIRAD/CCXXIRAD2/trim
cd $TRIM
ls *trimmed.fq.gz >> filenames
SEQS=$TRIM/filenames
BAM=/rhome/jmarz001/bigdata/CCXXIRAD/CCXXIRAD2/align
INDEX=/rhome/jmarz001/shared/GENOMES/NEW_BARLEY/GENOME_SPLIT/barley_split_reference.fa

FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQS | tail -n 1)
# (267_188_trimmed.fq -> 267_188_trimmed)
NAME=$(basename "$FILE" | cut -d. -f1)
# (267_188_trimmed -> 267_188)
SHORT=$(basename "$FILE" | cut -d. -f1 | cut -d_ -f1-2)

##RGLB (String)	Read Group library Required.
#RGLB=<"24=F25=late, 267=F11=early">
#yields numeric basename/generation, ie. (267_188 -> 267)
X=$(basename "$SHORT" | cut -d_ -f1)
Y=25

if [ "$X" == "$Y" ]; then
  RGLB=F25
else
  RGLB=F11
fi

bwa mem -R "@RG\tID:$SHORT_$SLURM_ARRAY_TASK_ID\tSM:$SHORT\tPU:$RGLB\tLB:Illumina_lib1" -t 10 $INDEX $TRIM/"$NAME".fq.gz > $BAM/"$SHORT".sam

# mapping stats
samtools flagstat $BAM/"$SHORT".sam > $BAM/mappingstats/"$SHORT"_mapstats.txt

# sam to sorted bam and index long bams with csi file
samtools view -bS $BAM/"$SHORT".sam | samtools sort -o $BAM/"$SHORT".bam
samtools index -c $BAM/"$SHORT".bam

# extract unmapped reads
mkdir $BAM/unmapped/
samtools view -f4 -b $BAM/"$SHORT".bam > $BAM/unmapped/"$SHORT".unmapped.bam

# export unmapped reads from original reads
bedtools bamtofastq -i $BAM/unmapped/"$SHORT".unmapped.bam -fq $BAM/unmapped/"$SHORT".unmapped.fq
