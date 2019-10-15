#!/usr/bin/bash -l

#SBATCH -p koeniglab
#SBATCH --ntasks=4
#SBATCH --mem-per-cpu=20G
#SBATCH --time=5-00:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/combined_CCXXI/scripts/cmd002_trim.stdout
#SBATCH --job-name='rad_trim'
#SBATCH --array=1-468

#load software
module load trimmomatic/0.36
# set software and adapter variables
TRIMMOMATIC=/opt/linux/centos/7.x/x86_64/pkgs/trimmomatic/0.36/trimmomatic.jar
ADAPTERDIR=/opt/linux/centos/7.x/x86_64/pkgs/trimmomatic/0.33/adapters

# define files and directories
SPLIT_FASTQS=/rhome/jmarz001/bigdata/CCXXIRAD/combined_CCXXI/data/raw_reads
SEQS=raw_file_list
cd $SPLIT_FASTQS ; ls *.fq.gz > $SEQS
mkdir trimmed
TRIMMED=/rhome/jmarz001/bigdata/CCXXIRAD/combined_CCXXI/data/trimmed

# get filenames from list
FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQS | tail -n 1)
# get basename of file, stripping at "."
NAME=$(basename "$FILE" | cut -d. -f1)

# Quality/Adapter trimming
java -jar $TRIMMOMATIC SE -threads 4 \
$SPLIT_FASTQS/${FILE} $TRIMMED/${NAME}_trimmed.fq.gz \
ILLUMINACLIP:${ADAPTERDIR}/TruSeq3-SE.fa:2:30:10 \
LEADING:5 TRAILING:5 SLIDINGWINDOW:4:20 MINLEN:36
