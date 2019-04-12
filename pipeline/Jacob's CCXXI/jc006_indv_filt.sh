#!/usr/bin/bash -l
#SBATCH -p short
#SBATCH --ntasks=1
#SBATCH --mem=50G
#SBATCH --time=2:00:00
#SBATCH --output=jc006_indv_filt.stdout
#SBATCH --job-name='jc006'

### combine split vcfs into whole genome files
module load bcftools/1.8
FILT=/rhome/jmarz001/bigdata/CCXXIRAD/CCXXIRAD2/calls/filter
cd $FILT
ls *.gtcounts.vcf > seqs
#bcftools concat [options] <file1> <file2> [...]
bcftools concat --file-list seqs -o JBL.genomesnps.vcf

# get the stats for every sample (in sample file) in the vcf file
REF=/rhome/jmarz001/shared/GENOMES/NEW_BARLEY/GENOME_SPLIT/barley_split_reference.fa
SAMP=/rhome/jmarz001/bigdata/CCXXIRAD/CCXXIRAD2/calls/filter/sample_ids
bcftools stats --fasta-ref $REF --samples-file $SAMP JBL.genomesnps.vcf -o JBL.genomesnps.vcf.stats
# subset every sample's counts and no header info
grep "PSC" JBL.genomesnps.vcf.stats | grep -v "," > $FILT/per_sample_calls

##### this next section is included only for code preservation
### it was not necessary to filter based on sample missingness

#### remove specific samples in violation of missingness and such
#FILE=$WORK/CCXXIRAD.genomesnps.vcf
#SAMP=$WORK/keep_samples.txt
# actually just set it to 98% == 53534 (nMissing) sites per individual
# exclude individuals with too much missing data
#bgzip --threads 3 $FILE
#bcftools index --threads 3 --csi $FILE.gz
# sample file must contain samples to subset by (ie. those included and not excluded)?
#bcftools view --threads 3 --samples-file $SAMP --force-samples -o $WORK/CCXXIRAD.inv_filt.vcf $FILE.gz


#### final site filters

# allele balance
bcftools view -i "INFO/AB > 0.25 && INFO/AB < 0.75 | INFO/AB < 0.01" JBL.genomesnps.vcf -o JBL.allele_balance.vcf
grep -c "^chr" JBL.allele_balance.vcf > allele_balance_sites

# ratio of mapping qualities between reference and alternate alleles
# "The rationale here is that, again, because RADseq loci and alleles all should start from the same genomic location there should not be large discrepancy between the mapping qualities of two alleles."
bcftools view -e "MQM / MQMR > 0.9 & MQM / MQMR < 1.05" JBL.allele_balance.vcf -o JBL.ref_alt_ratio.vcf
grep -c "^chr" JBL.ref_alt_ratio.vcf > ref_alt_ratio_sites

# first get a list of all samples still contained in the vcf for passing into next line
# -l argument: list sample names and exit
bcftools query -l CCXXIRAD.ref_alt_ratio.vcf > post_filter_indv_list
# get the stats for every sample (in sample file) in the vcf file
bcftools stats --fasta-ref $REF --samples-file $SAMP JBL.ref_alt_ratio.vcf > final_stats
