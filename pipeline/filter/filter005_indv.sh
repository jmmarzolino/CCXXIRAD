#!/usr/bin/bash -l
#SBATCH -p short
#SBATCH --ntasks=1
#SBATCH --mem=20G
#SBATCH --time=1:00:00
#SBATCH --output=filter005.stdout
#SBATCH --job-name='filt005'

module load bcftools/1.8 samtools/1.9
WORK=/rhome/jmarz001/bigdata/CCXXIRAD/calls/bcftools_filtered
FILE=$WORK/CCXXIRAD.genomesnps.vcf
SAMP=$WORK/keep_samples.txt
# actually just set it to 98% == 53534 (nMissing) sites per individual
# exclude individuals with too much missing data
bgzip --threads 3 $FILE
bcftools index --threads 3 --csi $FILE.gz
# sample file must contain samples to subset by (ie. those included and not excluded)?
# to exclude the samples in the file use: -S ^$SAMP
bcftools view --threads 3 --samples-file $SAMP --force-samples -o $WORK/CCXXIRAD.inv_filt.vcf $FILE.gz
