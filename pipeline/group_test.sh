#!/bin/bash -l

#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/group_test.stdout
#SBATCH -p short
#SBATCH --array=1-97

#set location for lane separated lists
BAR=/rhome/jmarz001/bigdata/CCXXIRAD/barcode/BARCODE_FILES
cd $BAR
SEQLIST=$BAR/HvRADY3_barcodes.txt
LINE=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1)

#What ended up working was replacing the SEQLIST and which plate name gets printed out, four different scripts
printf "$LINE \t Yellow \n" >> plates

#Also you really really need to just manually delete the first/header line of the barcode files to make things easier on yourself