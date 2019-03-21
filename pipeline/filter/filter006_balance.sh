#!/usr/bin/bash -l

#SBATCH -p short
#SBATCH --nodes=3
#SBATCH --mem=30G
#SBATCH --time=2:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/bcf_final.stdout
#SBATCH --job-name='bcf_final'

module load bcftools/1.8
WORK=/rhome/jmarz001/bigdata/CCXXIRAD/calls/bcftools_filtered
cd $WORK
FILE=CCXXIRAD.inv_filt.vcf

# allele balance
bcftools view -i "INFO/AB > 0.25 && INFO/AB < 0.75 | INFO/AB < 0.01" $FILE -o CCXXIRAD.allele_balance.vcf
grep -c "^chr" CCXXIRAD.allele_balance.vcf > allele_balance_sites

# ratio of mapping qualities between reference and alternate alleles
# "The rationale here is that, again, because RADseq loci and alleles all should start from the same genomic location there should not be large discrepancy between the mapping qualities of two alleles."
bcftools view -e "MQM / MQMR > 0.9 & MQM / MQMR < 1.05" CCXXIRAD.allele_balance.vcf -o CCXXIRAD.ref_alt_ratio.vcf
grep -c "^chr" CCXXIRAD.ref_alt_ratio.vcf > ref_alt_ratio_sites

REF=/rhome/jmarz001/shared/GENOMES/NEW_BARLEY/GENOME_SPLIT/barley_split_reference.fa
# first get a list of all samples still contained in the vcf for passing into next line
# -l argument: list sample names and exit
bcftools query -l CCXXIRAD.ref_alt_ratio.vcf > post_filter_indv_list
# get the stats for every sample (in sample file) in the vcf file
bcftools stats --fasta-ref $REF --samples-file post_filter_indv_list CCXXIRAD.ref_alt_ratio.vcf > final_stats
