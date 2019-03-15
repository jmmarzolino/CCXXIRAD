#!/usr/bin/bash -l

#SBATCH -p short
#SBATCH --ntasks=1
#SBATCH --mem=30G
#SBATCH --time=00:20:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/bcf_indv_filter.stdout
#SBATCH --job-name='bcf_indv'

module load bcftools/1.8
WORK=/rhome/jmarz001/bigdata/CCXXIRAD/calls/bcftools_filtered
FILE=$WORK/CCXXIRAD.genomesnps.vcf
SAMP=$WORK/samples.txt
REF=/rhome/jmarz001/shared/GENOMES/NEW_BARLEY/GENOME_SPLIT/barley_split_reference.fa

# get the stats for every sample (in sample file) in the vcf file
bcftools stats --fasta-ref $REF --samples-file $SAMP $FILE
# subset every sample's counts and no header info
grep "PSC" bcf_indv_filter.stdout | grep -v "," > /rhome/jmarz001/bigdata/CCXXIRAD/calls/bcftools_filtered/sample_calls

###########################################################################
#!/usr/bin/bash -l

#SBATCH -p short
#SBATCH --ntasks=1
#SBATCH --mem=30G
#SBATCH --time=1:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/bcf_indv_filter2.stdout
#SBATCH --job-name='bcf_indv'

module load bcftools/1.8 samtools/1.9
WORK=/rhome/jmarz001/bigdata/CCXXIRAD/calls/bcftools_filtered
FILE=$WORK/CCXXIRAD.genomesnps.vcf
SAMP=$WORK/keep_samples.txt
# actually just set it to 98% == 53534 (nMissing) sites per individual
# exclude individuals with too much missing data
bgzip --threads 3 $FILE
bcftools index --threads 3 --csi $FILE.gz

# sample file must contain samples to subset by (ie. those included and not excluded)?
bcftools view --threads 3 --samples-file $SAMP --force-samples -o $WORK/CCXXIRAD.inv_filt.vcf $FILE.gz


