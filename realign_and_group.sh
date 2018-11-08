#!/bin/bash -l

#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/read_groups.stdout
#SBATCH --job-name='realign and group'
#SBATCH -p koeniglab
#SBATCH --array=1-384
#SBATCH --ntasks=12
#SBATCH --time=24:00:00

#Alignment has been done so I'll add read groups and replace the rest just in case

##Adding Read Groups
#add read groups to produced .sam files

# Load software
module load samtools
module load bamtools
module load picard
module load bedtools

##RGSM (String)	Read Group sample name Required.
##RGSM="$NAME"
RESULTSDIR=/rhome/jmarz001/bigdata/CCXXIRAD/raw_aligns
SEQLIST=$RESULTSDIR/files
FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1)
NAME=$(basename "$FILE" | cut -d. -f1)


##RGPU (String)	Read Group platform unit (eg. run barcode) Required.
#set location for lane separated lists
BAR=/rhome/jmarz001/bigdata/CCXXIRAD/barcode/BARCODE_FILES
cd $BAR
#define the ID# list based on which lane they're from
#cut so only the second column is used (ID name not barcode string)
A=HvRADA2_barcodes.txt
P=HvRADP3_barcodes.txt
Y=HvRADY3_barcodes.txt
O=HvRADO2_barcodes.txt
#look for the file name in the Avocado barcode file
#if the name matches in the file, then say that it's read group is A
#Avocado
EVAL=`grep "$NAME" "$A" | cut -f2`
if [ "$EVAL" == "$NAME" ]; then
  RGPU=Avocado
fi
#Pink
EVAL=`grep "$NAME" "$P" | cut -f2`
if [ "$EVAL" == "$NAME" ]; then
  RGPU=Pink
fi
#Yellow or Orange
EVAL=`grep "$NAME" "$Y" | cut -f2`
if [ "$EVAL" == "$NAME" ]; then
  RGPU=Yellow
else
  RGPU=Orange
fi
#alt ideas (if grep = \d+_\d+ or "")


##RGLB (String)	Read Group library Required.
#RGLB=<"24=F25=late, 267=F11=early">
X=`cut $NAME --delimiter=_ -f1`

if ["$X"="24"]; then
  RGLB="F25"
else
  RGLB="F11"
fi


##RGPL (String)	Read Group platform (e.g. illumina, solid) Required.
#RGPL=illumina
java -jar /opt/linux/centos/7.x/x86_64/pkgs/trimmomatic/0.36/trimmomatic.jar \
AddOrReplaceReadGroups \
      I=$RESULTSDIR/"$NAME".sam \
      O=$RESULTSDIR/"$NAME".bam \
      RGLB="$RGLB" \
      RGPL=illumina \
      RGPU="$RGPU" \
      RGSM="$NAME" \
| samtools sort -o $RESULTSDIR/"$NAME".bam

# extract unmapped reads
samtools view -f4 -b $RESULTSDIR/"$NAME".bam > $RESULTSDIR/"$NAME".unmapped.bam

# export unmapped reads from original reads
bedtools bamtofastq -i $RESULTSDIR/"$NAME".unmapped.bam -fq $RESULTSDIR/"$NAME".unmapped.fq
