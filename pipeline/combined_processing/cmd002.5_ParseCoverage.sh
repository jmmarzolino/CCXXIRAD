#!/usr/bin/bash -l

#SBATCH -p short
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=20G
#SBATCH --time=2:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/combined_CCXXI/scripts/cmd002.5_CompareCoverage.stdout
#SBATCH --job-name='coverage'
#SBATCH --array=1-468

# Define directories and file locations
PROJECT_DIR=/rhome/jmarz001/bigdata/CCXXIRAD/combined_CCXXI

# Define names of Jacob vs. Jill's files
#ls *fq.gz > JBL_CCXXI_filelist
#JBL_FILES=
#JM file directory > JM_CCXXI_filelist
# Quick reference: known files to compare
# 267_6.fq.gz vs 267_61.fq.gz & 267_7 vs. 267_70

### LINES IN RAW FASTQ FILES AFTER SPLITTING FROM SEQUENCER FILES
## Count the number of lines in each of the fastq files to establish baseline off of sequencer
FASTQS=$PROJECT_DIR/data/raw_reads
FQ_FILES=$PROJECT_DIR/args/fastq_files
cd $FASTQS ; ls *.fq.gz > $FQ_FILES
FQ_FILE=$(head -n $SLURM_ARRAY_TASK_ID $FQ_FILES | tail -n 1)

# Unzip files & count the number of reads with ^@
RAW_READ_COUNT=$(zcat $FQ_FILE | grep -c "^@")
printf "$FQ_FILE \t $RAW_READ_COUNT \n" >> $PROJECT_DIR/args/raw_read_counts.txt


### LINES IN TRIMED FILES
## Count the number of lines in each trimed fq.gz file to see what percent of reads passed trimming
TRIM=$PROJECT_DIR/data/trimmed
TRIMMED_FILES=$PROJECT_DIR/args/trimmed_files
cd $TRIM ; ls *_trimmed.fq.gz > $TRIMMED_FILES
TRIM_FILE=$(head -n $SLURM_ARRAY_TASK_ID $TRIMMED_FILES | tail -n 1)

# Unzip files and count the number of reads with "^@"
TRIM_READ_COUNT=$(zcat $TRIM_FILE | grep -c "^@")
printf "$TRIM_FILE \t $TRIM_READ_COUNT \n" >> $PROJECT_DIR/args/trim_read_counts.txt


### LINES IN BAM FILES
## Count the number of lines in each bam file to see how many mapped
BAM_STATS=$PROJECT_DIR/data/bams/mappingstats
BAM_STATS_FILES=$PROJECT_DIR/args/bam_stat_files
cd $BAM_STATS ; ls *_mapstats.txt > $BAM_STATS_FILES
STAT_FILE=$(head -n $SLURM_ARRAY_TASK_ID $BAM_STATS_FILES | tail -n 1)
sample_name=$(basename "$STAT_FILE" | cut -d_ -f1-2)

BAM_READ_COUNT=$(head -n5 $BAM_STATS/$STAT_FILE | tail -n1 | cut -d\  -f1)
printf "$sample_name \t $BAM_READ_COUNT \n" >> $PROJECT_DIR/args/bam_read_counts.txt
