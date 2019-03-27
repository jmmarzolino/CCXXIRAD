#!/usr/bin/bash -l

#SBATCH -p batch
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=10G
#SBATCH --time=12:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/trim.stdout
#SBATCH --job-name='rad_trim'

# check alignment files

WORK=/rhome/jmarz001/bigdata/CCXXIRAD/barcode/ssv
RESULT=/rhome/jmarz001/bigdata/CCXXIRAD/trim/ssv
mkdir $RESULT
