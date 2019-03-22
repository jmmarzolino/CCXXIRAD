#!/bin/bash

#SBATCH -p intel
#SBATCH --ntasks=2
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=10G
#SBATCH --time=12:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/ssv001.stdout
#SBATCH --job-name='ssv'

#Verify raw read sequences are assigned to correct sample ID by barcode using STACKS
module load stacks/2.0

zcat /rhome/jmarz001/shared/SEQ_RUNS/9_14_2018/FASTQ/slimsdata.genomecenter.ucdavis.edu/Data/tyvcdh8myc/Unaligned/Project_DKJM_HvRADP3/HvRADP3_S5_L005_R1_001.fastq.gz | head -n 100 > /rhome/jmarz001/bigdata/CCXXIRAD/barcode/ssv.fastq
process_radtags -f /rhome/jmarz001/bigdata/CCXXIRAD/barcode/ssv.fastq \
-b /rhome/jmarz001/bigdata/CCXXIRAD/barcode/BARCODE_FILES/ssv.txt \
-o /rhome/jmarz001/bigdata/CCXXIRAD/barcode/ssv/ \
-e kpnI --retain_header
