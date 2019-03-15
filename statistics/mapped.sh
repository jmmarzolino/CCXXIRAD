#!/bin/bash -l

#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/mapped.stdout
#SBATCH --job-name='mapped'
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=10G
#SBATCH --time=1:00:00
#SBATCH -p short


DIR=/rhome/jmarz001/bigdata/CCXXIRAD/align/mappingstats
cd $DIR

printf "ID \t Total Reads \t Mapped Reads\n" > $DIR/mapped

map_list=`ls *.txt`
for line in $map_list; do
  B=`grep "total" $line | cut --delimiter=\  -f1`
  C=`grep "mapped (" $line | cut --delimiter=\  -f1`
  D=`grep "mapped (" $line | cut --delimiter=\  -f5 | cut -d\( -f2`
  printf "$line \t $B \t $C \t $D \n" >> $DIR/mapped
done

ls *.txt > map_list
for line in map_list; do
  A=`cut $line --delimiter=_  -f1,2`
  B=`grep "total" $DIR/$line | cut --delimiter=\  -f1`
  C=`grep "mapped (" $DIR/$line | cut --delimiter=\  -f1`
  D=`grep "mapped (" $DIR/$line | cut --delimiter=\  -f5 | cut -d\( -f2`
  printf "$A \t $B \t $C \t $D \n" >> $DIR/mapped
done