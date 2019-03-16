#!/usr/bin/bash -l

#SBATCH -p koeniglab
#SBATCH --ntasks=4
#SBATCH --mem=60G
#SBATCH --time=168:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/indv_concat.stdout
#SBATCH --job-name='indv_geno'

WORK=/rhome/jmarz001/bigdata/CCXXIRAD/calls/bcftools_filtered
cd $WORK
RESULT=/rhome/jmarz001/bigdata/CCXXIRAD/calls/indvs
ls *.gtcounts.vcf > seqs
FILE=$WORK/seqs

module load bcftools/1.8
#bcftools concat [options] <file1> <file2> [...]
bcftools concat --file-list $FILE -o CCXXIRAD.genomesnps.vcf
#results in whole genome file with info fields for every individual