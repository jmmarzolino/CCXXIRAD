#!/usr/bin/bash -l

#SBATCH -p koeniglab
#SBATCH --ntasks=5
#SBATCH --mem=150G
#SBATCH --time=72:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/qual_filter.stdout
#SBATCH --job-name='filter'
#SBATCH --array=1-384

WORK=/rhome/jmarz001/bigdata/CCXXIRAD/calls
cd $WORK
RESULT=/rhome/jmarz001/bigdata/CCXXIRAD/calls/filtered
SEQS=$WORK/files
FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQS | tail -n 1)
NAME=$(basename "$FILE" | cut -d. -f1)

module load bcftools/1.8
# bcftools filter [options] <file>
bcftools filter

bcftools filter --regions-file $pathToBed/BEDFILE.bed $inputVCF | bcftools filter -e "QUAL < 10 || F_MISSING > 0.01 || MAF > 0.98" | bcftools view -m2 -M2 -v snps --output-type z --output-file $outputDIR/$name._filtered.vcf.gz | bcftools index -t --output-file $outputDIR/$name._filtered.vcf.gz.tbi
# bcftools query [options] file.vcf.gz...
bcftools querry
Format:
%GT             Genotype (e.g. 0/1)
%TGT            Translated genotype (e.g. C/A)
%INFO/TAG       Any tag in the INFO column

# bcftools stats [options] A.vcf.gz [B.vcf.gz]
bcftools stats

bcftools plot-vcfstats [options] file.vchk ...
#first filter applied: minimum quality= 30, minor allele count=3, minor allele frequency= 0.1, minimum call depth=

# max missing (keep variants successfully genotyped in #% of individuals), try at different levels 0.5, 0.7 and see how many reads or snps left-over
# missing-indiv, graph to set cutoff
# min mean depth, overall depth=36x, min=20?, 10?, can be run by population too!
