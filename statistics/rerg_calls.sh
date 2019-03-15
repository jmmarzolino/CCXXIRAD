#!/bin/bash -l
#SBATCH --ntasks=12
#SBATCH --mem-per-cpu=10G
#SBATCH --time=5-00:00:00
#SBATCH --output=gatk_short_snps.stdout
#SBATCH --job-name="gatk_snp"
#SBATCH --partition=koeniglab
#SBATCH --array=1-27%3

WORK=/rhome/jmarz001/bigdata/convergent_evolution/data/align_rerg
SEQ=$WORK/file_list
ls $WORK/*_rg.bam > $SEQ
FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQ | tail -n 1)
NAME=$(basename "$FILE" | cut -d. -f1)
RES=/rhome/jmarz001/bigdata/convergent_evolution/data/dup_rerg
module load java picard
PICARD=/opt/linux/centos/7.x/x86_64/pkgs/picard/2.18.3/lib/picard.jar
java -jar $PICARD MarkDuplicates \
  I=$FILE \
  O=$RES/${NAME}_dupfree.bam \
  M=$WORK/$NAME.marked_dup_metrics.txt

module load java gatk/4.0.12.0 samtools
GATK=/opt/linux/centos/7.x/x86_64/pkgs/gatk/4.0.12.0/build/libs/gatk-package-4.0.12.0-20-gf9a2e5c-SNAPSHOT-local.jar
REF=/rhome/jmarz001/shared/GENOMES/NEW_BARLEY/GENOME_SPLIT/barley_split_reference.fa
CHR=/rhome/jmarz001/bigdata/convergent_evolution/small_sample/args/intervals.list
#
SNP=/rhome/jmarz001/bigdata/convergent_evolution/data/calls_rerg

samtools index $RES/${NAME}_dupfree.bam
for region in $CHR
do
gatk HaplotypeCaller -R $REF -L ${region} -I $RES/${NAME}_dupfree.bam -O $SNP/${FILE}.vcf
done

module load bcftools/1.8
SEQS=$WORK/seqs
ls $WORK/*.vcf > $SEQS
FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQS | tail -n 1 | cut -d. -f1)
# bcftools stats [options] A.vcf.gz [B.vcf.gz]
bcftools stats $SNP/$FILE.vcf > $SNP/$FILE.stats

# find the file ID, number of records (reads), and number of snps
# write them into the out file, and then copy the allele frequencies
#ID=(grep "^ID[^D]" $FILE | cut -f3)
RECS=(grep "number of records:" $SNP/$FILE.stats)
SNPS=(grep "number of SNPs:" $SNP/$FILE.stats)
printf "$FILE\n $RECS\n $SNPS\n" >> $SNP/$FILE.records
grep "^AF" $SNP/$FILE.stats >> $SNP/$FILE.AF
grep "^QUAL" $SNP/$FILE.stats >> $SNP/$FILE.QUAL
grep "^DP" $SNP/$FILE.stats >> $SNP/$FILE.DP

grep "^chr" $SNP/$FILE.stats | cut -f6 > $SNP//$FILE.quals
grep "^chr" $SNP/$FILE.stats | cut -f8 | cut -d\; -f8 | cut -d= -f2 > $SNP/$FILE.depth
grep "^chr" $SNP/$FILE.stats | cut -f8 | cut -d\; -f4 | cut -d= -f2 > $SNP/$FILE.allelefreq

# bcftools filter [options] <file>
#bcftools view -i 'F_MISSING<0.5 & DP>0 & DP<4031 & QUAL>30 & N_ALT=1 & COUNT(GT="het")<124 & COUNT(GT="alt")>0 & COUNT(GT="ref")>0' $FILE -o $RESULT/$NAME.124.vcf
#bcftools view -i 'F_MISSING<0.5 & DP>0 & DP<4031 & QUAL>30 & N_ALT=1' $FILE -o $RESULT/$NAME.minalt.vcf