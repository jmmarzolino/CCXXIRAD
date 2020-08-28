#!/usr/bin/bash -l
#SBATCH -p short
#SBATCH --ntasks=4
#SBATCH --mem=20G
#SBATCH --time=2:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/combined_CCXXI/filter002.stdout
#SBATCH --job-name='filter'
#SBATCH --array=1-4
#468%25

module load bcftools/1.8 samtools/1.9
# Define directories
PROJECT_DIR=/rhome/jmarz001/bigdata/CCXXIRAD/combined_CCXXI
SNPS=$PROJECT_DIR/data/calls
FILT=$SNPS/filter

cd $FILT
ls *_filt001.vcf > $PROJECT_DIR/args/filtered_vcf_files
bcftools concat --file-list $PROJECT_DIR/args/filtered_vcf_files -o $FILT/CCXXIRAD.genomesnps.vcf

FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQS | tail -n 1)
sample_name=$(basename "$FILE" | cut -d_ -f2-3)


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
