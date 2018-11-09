#!/bin/bash -l

#SBATCH --ntasks=15
#SBATCH --time=72:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/align_and_group.stdout
#SBATCH --job-name='align+group'
#SBATCH -p koeniglab
#SBATCH --array=1-384

########################################     Alignment      ##########################################
# bwa mem ref.fa reads.fq > aln-se.sam
#and assign read groups and get mapping statistics

# Load software
module load bwa
module load samtools
module load bamtools
module load picard
module load bedtools

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
#add read groups
##RGPU (String)	Read Group platform unit (eg. run barcode) Required.
#define the ID# list based on which lane they're from
#cut so only the second column is used (ID name not barcode string)
A=/rhome/jmarz001/bigdata/CCXXIRAD/barcode/BARCODE_FILES/HvRADA2_barcodes.txt
P=/rhome/jmarz001/bigdata/CCXXIRAD/barcode/BARCODE_FILES/HvRADP3_barcodes.txt
Y=/rhome/jmarz001/bigdata/CCXXIRAD/barcode/BARCODE_FILES/HvRADY3_barcodes.txt
O=/rhome/jmarz001/bigdata/CCXXIRAD/barcode/BARCODE_FILES/HvRADO2_barcodes.txt
#look for the file name in the Avocado barcode file
#if the name matches in the file, then say that it's read group is A
#Avocado
EVAL=`grep "$SHORT" "$A" | cut -f2`
if [ "$EVAL" == "$SHORT" ]; then
  RGPU=Avocado
fi
#Pink
EVAL=`grep "$SHORT" "$P" | cut -f2`
if [ "$EVAL" == "$SHORT" ]; then
  RGPU=Pink
fi
#Yellow or Orange
EVAL=`grep "$SHORT" "$Y" | cut -f2`
if [ "$EVAL" == "$SHORT" ]; then
  RGPU=Yellow
else
  RGPU=Orange
fi


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

bwa mem -R "@RG:\tID:$SLURM_ARRAY_TASK_ID\tSM:$SHORT\tPU:$RGPU\tLB:$RGLB" -t 8 $INDEX $WORKINGDIR/"$NAME".fq > $RESULTSDIR/"$SHORT".sam

# mapping stats
samtools flagstat $RESULTSDIR/"$SHORT".sam > $RESULTSDIR/mappingstats/"$SHORT"_mapstats.txt

# sam to sorted bam
samtools view -bS $RESULTSDIR/"$SHORT".sam | samtools sort -o $RESULTSDIR/"$SHORT".bam

# extract unmapped reads
samtools view -f4 -b $RESULTSDIR/"$SHORT".bam > $RESULTSDIR/"$SHORT".unmapped.bam

# export unmapped reads from original reads
bedtools bamtofastq -i $RESULTSDIR/"$SHORT".unmapped.bam -fq $RESULTSDIR/"$SHORT".unmapped.fq
