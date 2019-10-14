#!/usr/bin/bash -l

#SBATCH -p koeniglab
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=20G
#SBATCH --time=5-00:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/combined_CCXXI/scripts/cmd001_barsplit.stdout
#SBATCH --job-name='barcode_split'

#Separate raw RAD reads by barcode using STACKS program
module load stacks/2.0
#process_radtags -f in_file [-b barcode_file] -o out_dir -e enz
# -q removes reads with low quality scores
#--filter_illumina: discard reads that have been marked by Illumina's chastity/purity filter as failing

# define file locations
SPLIT_FASTQS=/rhome/jmarz001/bigdata/CCXXIRAD/combined_CCXXI/data/raw_reads

process_radtags -f /rhome/jmarz001/shared/SEQ_RUNS/9_14_2018/FASTQ/slimsdata.genomecenter.ucdavis.edu/Data/tyvcdh8myc/Unaligned/Project_DKJM_HvRADP3/HvRADP3_S5_L005_R1_001.fastq.gz \
-b /rhome/jmarz001/bigdata/CCXXIRAD/barcode/BARCODE_FILES/HvRADP3_barcodes.txt \
-o $SPLIT_FASTQS \
-e kpnI --retain_header

process_radtags -f /rhome/jmarz001/shared/SEQ_RUNS/9_14_2018/FASTQ/slimsdata.genomecenter.ucdavis.edu/Data/0g5kd427pb/Unaligned/Project_DKJM_HvRADY3/HvRADY3_S6_L006_R1_001.fastq.gz \
-b /rhome/jmarz001/bigdata/CCXXIRAD/barcode/BARCODE_FILES/HvRADY3_barcodes.txt \
-o $SPLIT_FASTQS \
-e kpnI --retain_header

process_radtags -f /rhome/jmarz001/shared/SEQ_RUNS/9_14_2018/FASTQ/slimsdata.genomecenter.ucdavis.edu/Data/9e0rmu9j/Unaligned/Project_DKJM_HvRADO2/HvRADO2_S7_L007_R1_001.fastq.gz \
-b /rhome/jmarz001/bigdata/CCXXIRAD/barcode/BARCODE_FILES/HvRADO2_barcodes.txt \
-o $SPLIT_FASTQS \
-e kpnI --retain_header

process_radtags -f /rhome/jmarz001/shared/SEQ_RUNS/9_14_2018/FASTQ/slimsdata.genomecenter.ucdavis.edu/Data/2tyrhwu7zo/Unaligned/Project_DKJM_HvRADA2/HvRADA2_S8_L008_R1_001.fastq.gz \
-b /rhome/jmarz001/bigdata/CCXXIRAD/barcode/BARCODE_FILES/HvRADA2_barcodes.txt \
-o $SPLIT_FASTQS \
-e kpnI --retain_header
