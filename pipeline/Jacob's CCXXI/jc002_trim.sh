#!/usr/bin/bash -l

#SBATCH -p batch
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=15G
#SBATCH --time=72:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/CCXXIRAD2/scripts/jc002_trim.stdout
#SBATCH --job-name='jc002'
#SBATCH --array=1-96

#load software
module load trimmomatic/0.36

# make variables for location of trimmomatic, adapter file, working directory, results directory, and sequence list
TRIMMOMATIC=/opt/linux/centos/7.x/x86_64/pkgs/trimmomatic/0.36/trimmomatic.jar
ADAPTERDIR=/opt/linux/centos/7.x/x86_64/pkgs/trimmomatic/0.33/adapters

RAW=/rhome/jmarz001/bigdata/CCXXIRAD/CCXXIRAD2/barcode
TRIM=/rhome/jmarz001/bigdata/CCXXIRAD/CCXXIRAD2/trim
SEQS=$RAW/raw_files
ls $RAW/* > $SEQS

# get filenames from list
FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQS | tail -n 1)
# get basename of file, stripping at "."
NAME=$(basename "$FILE" | cut -d. -f1)

# Quality/Adapter trimming
java -jar $TRIMMOMATIC SE -threads 4 \
$RAW/${FILE} $TRIM/"$NAME"_trimmed.fq.gz \
ILLUMINACLIP:"$ADAPTERDIR"/TruSeq3-SE.fa:2:30:10 \
LEADING:5 TRAILING:5 SLIDINGWINDOW:4:20 MINLEN:36
