#!/bin/bash -l

#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/retained.stdout
#SBATCH --mail-user=jmarz001@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name='retained'

#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=10G

#SBATCH --time=1:00:00
#SBATCH -p intel


DIR=/rhome/jmarz001/bigdata/CCXXIRAD/raw_aligns/mappingstats
cd $DIR

for file in $DIR; do
  "$file" >> cat_map.txt
  grep "total" | cut --delimiter=\s -f1,5  >> cat_map.txt
  grep "mapped" | cut --delimiter=\s -f1,4 >> cat_map.txt
done

#4272567 + 0 in total (QC-passed reads + QC-failed reads)
#0 + 0 secondary
#47239 + 0 supplementary
#0 + 0 duplicates
#4249916 + 0 mapped (99.47% : N/A)