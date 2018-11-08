#!/bin/bash -l

#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/group_test.stdout
#SBATCH --job-name='realign and group'
#SBATCH -p koeniglab
#SBATCH --array=1-384
#SBATCH --ntasks=12
#SBATCH --time=24:00:00

RESULTSDIR=/rhome/jmarz001/bigdata/CCXXIRAD/raw_aligns
SEQLIST=$RESULTSDIR/files
FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1)
NAME=$(basename "$FILE" | cut -d. -f1)

#set location for lane separated lists
BAR=/rhome/jmarz001/bigdata/CCXXIRAD/barcode/BARCODE_FILES
cd $BAR
#define the ID# list based on which lane they're from
#cut so only the second column is used (ID name not barcode string)
A=HvRADA2_barcodes.txt
#P=`$BAR/HvRADP3_barcodes.txt | cut -f2`
#Y=`$BAR/HvRADY3_barcodes.txt | cut -f2`
#O=`$BAR/HvRADO2_barcodes.txt | cut -f2`
#look for the file name in the Avocado barcode file
#if the name matches in the file, then say that it's read group is A
EVAL=`grep "$NAME" "$A" | cut -f2`
if [ "$EVAL" == "$NAME" ]; then
  echo "RGPU=A"
else
  echo "Nothin"
fi

#(if grep = \d+_\d+ or "")

#if
#  grep $NAME $P = ""
#    then