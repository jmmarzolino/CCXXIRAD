#!/usr/bin/bash -l

#SBATCH -p koeniglab
#SBATCH --ntasks=5
#SBATCH --mem=100G
#SBATCH --time=168:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/qual_filter.stdout
#SBATCH --job-name='filter'
#SBATCH --array=1-384%5

WORK=/rhome/jmarz001/bigdata/CCXXIRAD/calls
cd $WORK
RESULT=/rhome/jmarz001/bigdata/CCXXIRAD/calls/filtered
SEQS=$WORK/files
FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQS | tail -n 1)
NAME=$(basename "$FILE" | cut -d. -f1)

module load bcftools/1.8
# bcftools filter [options] <file>
bcftools filter -e "QUAL < 30 || F_MISSING > 0.5" $FILE -o $RESULT/$NAME.filtered.vcf
bcftools view -i "F_MISSING > 0.5" $FILE -o $RESULT/$NAME.missing
#bcftools filter --regions-file $pathToBed/BEDFILE.bed $inputVCF | bcftools filter -e "QUAL < 10 || F_MISSING > 0.01 || MAF > 0.98" | bcftools view -m2 -M2 -v snps --output-type z --output-file $outputDIR/$name._filtered.vcf.gz | bcftools index -t --output-file $outputDIR/$name._filtered.vcf.gz.tbi
# -q, --min-af FLOAT[:nref|:alt1|:minor|:major|:nonmajor
# bcftools view -q 0.01:minor chr.all.vcf.gz