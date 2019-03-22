#!/bin/bash -l

#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/mapped.stdout
#SBATCH --job-name='mapped'
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=10G
#SBATCH --time=1:00:00
#SBATCH -p short
#SBATCH --array=1-382

WORK=/rhome/jmarz001/bigdata/CCXXIRAD/align
cd $WORK
SEQS=$WORK/bams
module load samtools
FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQS | tail -n 1)
samtools view -c -F 260 $FILE >> file_reads




ls *.txt > map_list
for line in $map_list; do
  B=`grep "total" $line | cut --delimiter=\  -f1`
  C=`grep "mapped (" $line | cut --delimiter=\  -f1`
  D=`grep "mapped (" $line | cut --delimiter=\  -f5 | cut -d\( -f2`
  printf "$line \t $B \t $C \t $D \n" >> $DIR/mapped
done

###AFTER
#set and move to new working dir
POST=/rhome/jmarz001/bigdata/CCXXIRAD/trim/fastqc
cd $POST
printf "Filename \t Total Sequences \n" > $POST/post_fileseqs.txt
#make a list of all the directory names so they can be cd'd into in turn
folders=`ls -d *fastqc/`
#move into each directory from the list
#copy directory name and Total Sequences line from fastqc data file into fileseqs
for dir in $folders; do
  cd $dir
  A=`grep "Filename" fastqc_data.txt | cut -f2`
  B=`grep "Total Sequences" fastqc_data.txt | cut -f2`
  printf "$A\t$B\n" >> $POST/post_fileseqs.txt
  cd ..
done
