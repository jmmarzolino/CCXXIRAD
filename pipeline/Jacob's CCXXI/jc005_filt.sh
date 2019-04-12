#!/usr/bin/bash -l
#SBATCH -p short
#SBATCH --ntasks=2
#SBATCH --mem=100G
#SBATCH --time=2:00:00
#SBATCH --output=jc005_filt.stdout
#SBATCH --job-name='jc005'
#SBATCH --array=1-16
#
module load bcftools/1.8
SNP=/rhome/jmarz001/bigdata/CCXXIRAD/CCXXIRAD2/calls
FILT=/rhome/jmarz001/bigdata/CCXXIRAD/CCXXIRAD2/calls/filter
cd $FILT
ls $SNP/*.vcf | cut -d. -f1-2 > $SNP/seqs
FILE=$(head -n $SLURM_ARRAY_TASK_ID $SNP/seqs | tail -n 1)

bcftools view -i 'F_MISSING<0.5 & DP>1 & DP<4031 & QUAL>30 & N_ALT=1' $SNP/$FILE.vcf -o $FILE.minalt.vcf
bcftools view -i 'COUNT(GT="het")<124 && COUNT(GT="alt")>0 && COUNT(GT="ref")>0' $FILE.minalt.vcf -o $FILE.gtcounts.vcf

### combine split vcfs into whole genome files

ls *.gtcounts.vcf > seqs
FILE=$WORK/seqs

module load bcftools/1.8
#bcftools concat [options] <file1> <file2> [...]
bcftools concat --file-list $FILE -o CCXXIRAD.genomesnps.vcf
#results in whole genome file with info fields for every individual


# get the stats for every sample (in sample file) in the vcf file
REF=/rhome/jmarz001/shared/GENOMES/NEW_BARLEY/GENOME_SPLIT/barley_split_reference.fa
SAMP=/rhome/jmarz001/bigdata/CCXXIRAD/CCXXIRAD2/calls/filter/sample_ids
bcftools stats --fasta-ref $REF --samples-file $SAMP $FILE
# subset every sample's counts and no header info
grep "PSC" bcf_indv_filter.stdout | grep -v "," > /rhome/jmarz001/bigdata/CCXXIRAD/calls/bcftools_filtered/sample_calls


#### remove specific samples in violation of missingness and such

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
