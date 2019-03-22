#!/usr/bin/bash -l

#SBATCH -p batch
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=32G
#SBATCH --time=72:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/trim.stdout
#SBATCH --job-name='rad_trim'
#SBATCH --array=1-384

#load software
module load trimmomatic/0.36

# make variables for location of trimmomatic, adapter file, working directory, results directory, and sequence list
TRIMMOMATIC=/opt/linux/centos/7.x/x86_64/pkgs/trimmomatic/0.36/trimmomatic.jar
ADAPTERDIR=/opt/linux/centos/7.x/x86_64/pkgs/trimmomatic/0.33/adapters

WORKINGDIR=/rhome/jmarz001/bigdata/CCXXIRAD/barcode
RESULTSDIR=/rhome/jmarz001/bigdata/CCXXIRAD/trim
SEQLIST=/rhome/jmarz001/bigdata/CCXXIRAD/barcode/seqs

# cd to working directory
cd $WORKINGDIR

# get filenames from list
FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1)
# get basename of file, stripping at "."
NAME=$(basename "$FILE" | cut -d. -f1)

# Quality/Adapter trimming
java -jar $TRIMMOMATIC SE -threads 4 \
$WORKINGDIR/"$NAME".fq $RESULTSDIR/"$NAME"_trimmed.fq \
ILLUMINACLIP:"$ADAPTERDIR"/TruSeq3-SE.fa:2:30:10 \
LEADING:5 TRAILING:5 SLIDINGWINDOW:4:20 MINLEN:36
