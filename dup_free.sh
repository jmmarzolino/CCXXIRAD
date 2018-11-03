#Removing Duplicates not necessary for RAD seqs

#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=10
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=10G
#SBATCH --time=24:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/dup_free.stdout
#SBATCH --mail-user=jmarz001@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name='remove duplicates'
#SBATCH -p koeniglab
#SBATCH --array=1-384

#####                   Removing Duplicates                   #####
##samtools rmdup <input.bam> <output.bam>
module load samtools

WORKINGDIR=/rhome/jmarz001/bigdata/CCXXIRAD/raw_aligns
RESULTSDIR=/rhome/jmarz001/bigdata/CCXXIRAD/dup_free
SEQLIST="$WORKINGDIR"/seqlist.txt

# make your results directory
mkdir $RESULTSDIR
# move into working directory
cd $WORKINGDIR
# make seqlist
ls *.bam > seqlist.txt

FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1)
# get basename of file, stripping at "."
#yields first part of basename, ie. everything before decimal (267_188_trimmed.fq -> 267_188_trimmed)
NAME=$(basename "$FILE" | cut -d. -f1)
SHORT=$(basename "$FILE" | cut -d. -f1 | cut -d_ -f1-2)

samtools rmdup \
"$WORKINGDIR"/"$NAME".bam \
"$RESULTSDIR"/"$NAME"_dupfree.bam
