#!/bin/bash

#SBATCH -p intel
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=40G
#SBATCH --time=40:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/barcode_splitter.stdout
#SBATCH --mail-user=jmarz001@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name='RAD_barcode_splitter'

##Script purpose
#Separate raw read sequences by barcode using STACKS program

echo "commence goat_biohazard cleanup"

module load stacks/2.0

#process_radtags -f in_file [-b barcode_file] -o out_dir -e enz
#-o /rhome/jmarz001/bigdata/CCXXIRAD/barcode
#-b /rhome/jmarz001/shared/SEQ_RUNS/9_14_2018/BARCODE_IDS/<file>
#-e [enz]
#[-q #removes reads with low quality scores]
#--retain_header: retain unmodified FASTQ headers in the output
#--filter_illumina: discard reads that have been marked by Illumina's chastity/purity filter as failing

process_radtags -f /rhome/jmarz001/shared/SEQ_RUNS/9_14_2018/FASTQ/slimsdata.genomecenter.ucdavis.edu/Data/tyvcdh8myc/Unaligned/Project_DKJM_HvRADP3/HvRADP3_S5_L005_R1_001.fastq.gz \
-b /rhome/jmarz001/bigdata/CCXXIRAD/barcode/BARCODE_FILES/HvRADP3_barcodes.txt \
-o /rhome/jmarz001/bigdata/CCXXIRAD/barcode/ \
-e kpnI --retain_header

process_radtags -f /rhome/jmarz001/shared/SEQ_RUNS/9_14_2018/FASTQ/slimsdata.genomecenter.ucdavis.edu/Data/0g5kd427pb/Unaligned/Project_DKJM_HvRADY3/HvRADY3_S6_L006_R1_001.fastq.gz \
-b /rhome/jmarz001/bigdata/CCXXIRAD/barcode/BARCODE_FILES/HvRADY3_barcodes.txt \
-o /rhome/jmarz001/bigdata/CCXXIRAD/barcode/ \
-e kpnI --retain_header

process_radtags -f /rhome/jmarz001/shared/SEQ_RUNS/9_14_2018/FASTQ/slimsdata.genomecenter.ucdavis.edu/Data/9e0rmu9j/Unaligned/Project_DKJM_HvRADO2/HvRADO2_S7_L007_R1_001.fastq.gz \
-b /rhome/jmarz001/bigdata/CCXXIRAD/barcode/BARCODE_FILES/HvRADO2_barcodes.txt \
-o /rhome/jmarz001/bigdata/CCXXIRAD/barcode/ \
-e kpnI --retain_header

process_radtags -f /rhome/jmarz001/shared/SEQ_RUNS/9_14_2018/FASTQ/slimsdata.genomecenter.ucdavis.edu/Data/2tyrhwu7zo/Unaligned/Project_DKJM_HvRADA2/HvRADA2_S8_L008_R1_001.fastq.gz \
-b /rhome/jmarz001/bigdata/CCXXIRAD/barcode/BARCODE_FILES/HvRADA2_barcodes.txt \
-o /rhome/jmarz001/bigdata/CCXXIRAD/barcode/ \
-e kpnI --retain_header

echo "you are entering the reign of the goat_queen"
