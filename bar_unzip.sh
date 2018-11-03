#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=15
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=10G
#SBATCH --time=1:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/bar_unzip.stdout
#SBATCH --mail-user=jmarz001@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name='barcode unzipper'
#SBATCH -p koeniglab

DIR=/rhome/jmarz001/bigdata/CCXXIRAD/barcode/quality

for file in $DIR/*.zip
do
  unzip "$file"
done