#!/usr/bin/bash -l

#SBATCH -p koeniglab
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=20G
#SBATCH --time=5-00:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/combined_CCXXI/scripts/cmd001_barsplit.stdout
#SBATCH --job-name='barcode_split'
#SBATCH --array=1-4

#Separate raw RAD reads by barcode using STACKS program
module load stacks/2.0
#process_radtags -f in_file [-b barcode_file] -o out_dir -e enz
# -q removes reads with low quality scores
#--filter_illumina: discard reads that have been marked by Illumina's chastity/purity filter as failing

# define file locations
FASTQ_FILES=/rhome/jmarz001/bigdata/CCXXIRAD/combined_CCXXI/args/fastq_files
FILE=$(head -n $SLURM_ARRAY_TASK_ID $FASTQ_FILES | cut -f1 | tail -n 1)
BARCODE_FILE=$(head -n $SLURM_ARRAY_TASK_ID $FASTQ_FILES | cut -f2 | tail -n 1)
SPLIT_FASTQS=/rhome/jmarz001/bigdata/CCXXIRAD/combined_CCXXI/data/raw_reads

process_radtags -f $FILE \
-b $BARCODE_FILE \
-o $SPLIT_FASTQS \
-e kpnI --retain_header
