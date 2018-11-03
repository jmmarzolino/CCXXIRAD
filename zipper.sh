#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=25G
#SBATCH --time=24:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts
#SBATCH --mail-user=jmarz001@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name='zipper'
#SBATCH -p koeniglab

DIR=/rhome/jmarz001/bigdata/CCXXIRAD/barcode

gzip $DIR/*.fq