#!/bin/bash -l

#SBATCH -p intel
#SBATCH --nodes=1
#SBATCH --ntasks=6
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=40G
#SBATCH --time=40:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/fastqc.stdout
#SBATCH --mail-user=jmarz001@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name='rad_fastq'

#load more modules than may be necessary but I'm unsure and it doesn't hurt
module load picard
module load fastqc/0.11.7

## Format for fastqc function: in files, out directory specification, number of threads (only use 6 on 32Gb machine and match with ntasks in header), -q (quiet) puts errors in stdout file not stdout and log (saves time and space)
# <fastqc somefile.txt someotherfile.txt --outdir=/some/other/dir/ -t 6 -q>

#pipe all file names into fastqc using ls (fed wildcard for files), tell fastqc to use stdin (ie. the files fed from pipe)
cd /rhome/jmarz001/bigdata/CCXXIRAD/barcode/

for file in *.fq
do
  gunzip "$file"
  fastqc "$file" --outdir=/rhome/jmarz001/bigdata/CCXXIRAD/quality/"$file_qual" -t 6 -q
done