#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=13
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=15G
#SBATCH --time=168:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/align_and_group.stdout
#SBATCH --job-name='align+group'
#SBATCH -p batch
#SBATCH --array=1-384

# BWA Alignment into raw sorted alignment
# then sam to sorted bam
# bwa mem ref reads.fq > aln.sam
# assign read groups and get mapping statistics

module load bwa samtools bedtools

# Define location variables
WORKINGDIR=/rhome/jmarz001/bigdata/CCXXIRAD/trim
cd $WORKINGDIR
ls *trimmed.fq >> filenames.txt
SEQLIST=/rhome/jmarz001/bigdata/CCXXIRAD/trim/filenames.txt
RESULTSDIR=/rhome/jmarz001/bigdata/CCXXIRAD/align
INDEX=/rhome/jmarz001/shared/GENOMES/NEW_BARLEY/GENOME_SPLIT/barley_split_reference.fa

# Define files to run over
# get filenames from list
FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1)
# get basename of file, stripping at "."
#yields first part of basename, ie. everything before decimal (267_188_trimmed.fq -> 267_188_trimmed)
NAME=$(basename "$FILE" | cut -d. -f1)
#yields numeric basename, ie. (267_188_trimmed -> 267_188)
SHORT=$(basename "$FILE" | cut -d. -f1 | cut -d_ -f1-2)

##RGPU (String)	Read Group platform unit (eg. run barcode) Required.
#define the ID# list based on which lane they're from
BAR=/rhome/jmarz001/bigdata/CCXXIRAD/barcode/BARCODE_FILES/
#file with info containing file name/ID in one column and plate on another (from group_test.sh script which copied lines from Hv## barcode files into new 'plates' file with addition of plate info column based on which barcode file they came from)
PLATES=$BAR/plates
RGPU=$(grep "$SHORT" $PLATES | cut -f4)
#cut so only the plate info is used

##RGLB (String)	Read Group library Required.
#RGLB=<"24=F25=late, 267=F11=early">
#yields numeric basename/generation, ie. (267_188 -> 267)
X=$(basename "$SHORT" | cut -d_ -f1)
Y=24

if [ "$X" == "$Y" ]; then
  RGLB=F25
else
  RGLB=F11
fi

bwa mem -R "@RG\tID:$SLURM_ARRAY_TASK_ID\tSM:$SHORT\tPU:$RGPU\tLB:$RGLB" -t 10 $INDEX $WORKINGDIR/"$NAME".fq > $RESULTSDIR/"$SHORT".sam

# mapping stats
samtools flagstat $RESULTSDIR/"$SHORT".sam > $RESULTSDIR/mappingstats/"$SHORT"_mapstats.txt

# sam to sorted bam and index long bams with csi file
samtools view -bS $RESULTSDIR/"$SHORT".sam | samtools sort -o $RESULTSDIR/"$SHORT".bam
samtools index -c $RESULTSDIR/"$SHORT".bam

# extract unmapped reads
samtools view -f4 -b $RESULTSDIR/"$SHORT".bam > $RESULTSDIR/"$SHORT".unmapped.bam

# export unmapped reads from original reads
bedtools bamtofastq -i $RESULTSDIR/"$SHORT".unmapped.bam -fq $RESULTSDIR/"$SHORT".unmapped.fq
