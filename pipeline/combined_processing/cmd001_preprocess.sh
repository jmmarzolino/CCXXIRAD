#!/usr/bin/bash -l

#SBATCH -p short
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=10G
#SBATCH --time=2:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/.stdout
#SBATCH --job-name='jc001'
#SBATCH --array=1-96

# Locate and list all files for read processing
FASTQ_DIR=/rhome/jmarz001/shared/SEQ_RUNS/10_9_2017/PARSED
FILE_LIST=/rhome/jmarz001/shared/SEQ_RUNS/10_9_2017/BARCODE/HvRAD16_barcodes.txt
JBL_FILES=$(head -n $SLURM_ARRAY_TASK_ID $FILE_LIST| tail -n 1 | cut -f2)



cp $FQ/${FILE}.fq.gz /rhome/jmarz001/bigdata/CCXXIRAD/CCXXIRAD2/barcode/


#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/barcode_splitter.stdout
#SBATCH --mail-user=jmarz001@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name='RAD_barcode_splitter'

##Script purpose
#Separate raw read sequences by barcode using STACKS program

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
