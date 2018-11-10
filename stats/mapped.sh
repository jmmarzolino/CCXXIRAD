#!/bin/bash -l

#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/mapped.stdout
#SBATCH --mail-user=jmarz001@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name='mapped'

#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=10G

#SBATCH --time=1:00:00
#SBATCH -p koeniglab


DIR=/rhome/jmarz001/bigdata/CCXXIRAD/raw_aligns/mappingstats
cd $DIR

printf "ID \t Total Reads \t Mapped Reads \t Percent Mapped \n" > $DIR/mapped
map_list=`ls *.txt`

for line in $map_list; do
  B=`grep "total" $line | cut --delimiter=\  -f1`
  C=`grep "mapped (" $line | cut --delimiter=\  -f1`
  printf "$line \t $B \t $C \n" >> $DIR/mapped
done
