#!/usr/bin/bash -l

#SBATCH -p short
#SBATCH --ntasks=1
#SBATCH --mem=20G
#SBATCH --time=00:20:00
#SBATCH --output=filter004_stats.stdout
#SBATCH --job-name='filt004'

module load bcftools/1.8
WORK=/rhome/jmarz001/bigdata/CCXXIRAD/calls/bcftools_filtered
cd $WORK
FILE=CCXXIRAD.genomesnps.vcf
REF=/rhome/jmarz001/shared/GENOMES/NEW_BARLEY/GENOME_SPLIT/barley_split_reference.fa

# extract allele frequency at each position
bcftools query -f '%CHROM %POS %AF\n' $FILE -o AF.vcf
# extract every sample name and collect ssample stats
bcftools query -l $FILE > samples
bcftools stats --fasta-ref $REF --samples-file $SAMP $FILE > $FILE.stats
# subset every sample's counts and no header info
grep "PSC" $FILE.stats | grep -v "," > $FILE.per_sample_calls

#bcftools view -H N_PASS(F_MISSING<0.98) $FILE -o pass.missing.vcf
#bcftools view -H MAX(F_MISSING) $FILE -o maxmiss.vcf
#bcftools view -H MIN(F_MISSING) $FILE -o minmiss.vcf
