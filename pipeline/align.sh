#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=32G
#SBATCH --time=72:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/rad_aligns.stdout
#SBATCH --mail-user=jmarz001@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name='rad_align'
#SBATCH -p koeniglab
#SBATCH --array=1-384

########################################     Alignment      ##########################################
# bwa mem ref.fa reads.fq > aln-se.sam

# Load software
module load bwa
module load samtools
module load bamtools

# Define location variables
WORKINGDIR=/rhome/jmarz001/bigdata/CCXXIRAD/trim
RESULTSDIR=/rhome/jmarz001/bigdata/CCXXIRAD/raw_aligns
SEQLIST=/rhome/jmarz001/bigdata/CCXXIRAD/trim/filenames.txt
INDEX=/rhome/jmarz001/bigdata/H_Murinum/Practice_Set/Hordeum_vulgare.Hv_IBSC_PGSB_v2.dna.toplevel/Hordeum_vulgare.Hv_IBSC_PGSB_v2.dna.toplevel

# cd to working directory
cd $WORKINGDIR

# Define files to run over
# get filenames from list
FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1)
# get basename of file, stripping at "."
#yields first part of basename, ie. everything before decimal (267_188_trimmed.fq -> 267_188_trimmed)
NAME=$(basename "$FILE" | cut -d. -f1)
#yields numeric basename, ie. (267_188_trimmed -> 267_188)
SHORT=$(basename "$FILE" | cut -d. -f1 | cut -d_ -f1-2)

# BWA Alignment into raw sorted alignment
# then sam to sorted bam
#bwa mem ref.fa reads.fq > aln-se.sam

#need to add read groups
# -R STR	read group header line. ’\t’ = TAB. read group ID is attached to every read. example: ’@RG\tID:foo\tSM:bar’
# -R "@RG:\tID:$SLURM_ARRAY_TASK_ID\tSM:$SAMPLE\tPU:$LANE\tLB:$GROUP"

bwa mem -t 8 $INDEX $WORKINGDIR/"$NAME".fq > $RESULTSDIR/"$SHORT".sam

# mapping stats
samtools flagstat $RESULTSDIR/"$SHORT".sam > $RESULTSDIR/mappingstats/"$SHORT"_mapstats.txt

# sam to sorted bam
samtools view -bS $RESULTSDIR/"$SHORT".sam | samtools sort -o $RESULTSDIR/"$SHORT".bam

# extract unmapped reads
samtools view -f4 -b $RESULTSDIR/"$SHORT".bam > $RESULTSDIR/"$SHORT".unmapped.bam

module load bedtools
# export unmapped reads from original reads
bedtools bamtofastq -i $RESULTSDIR/"$SHORT".unmapped.bam -fq $RESULTSDIR/"$SHORT".unmapped.fq
