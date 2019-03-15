#!/usr/bin/bash -l

#SBATCH -p short
#SBATCH --ntasks=4
#SBATCH --mem=64G
#SBATCH --time=2:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/calls/vc_bc_comparison/filter_comparison.stdout
#SBATCH --job-name='filter'

WORK=/rhome/jmarz001/bigdata/CCXXIRAD/calls
cd $WORK
RESULT=/rhome/jmarz001/bigdata/CCXXIRAD/calls/vc_bc_comparison
mkdir $RESULT
FILE=$WORK/rad.chr1H_1_279267716.freebayes.snps.vcf
NAME=$(basename $FILE | cut -d. -f1-2)

module load vcftools
module load bcftools/1.8

# these two should be the same, they're even in the same order
vcftools --vcf $FILE --max-missing 0.5 --recode --recode-INFO-all --out $RESULT/$NAME.missingv
bcftools view -i 'F_MISSING<0.5' $FILE -o $RESULT/$NAME.missingb.vcf

vcftools --vcf $FILE --minQ 30.0 --recode --recode-INFO-all --out $RESULT/$NAME.qualv
bcftools view -i 'QUAL>30' $FILE -o $RESULT/$NAME.qualb.vcf

vcftools --vcf $FILE --minDP 0.0 --recode --recode-INFO-all --out $RESULT/$NAME.minDPv
bcftools view -i 'DP>0' $FILE -o $RESULT/$NAME.minDPb.vcf

vcftools --vcf $FILE --maxDP 4031.0 --recode --recode-INFO-all --out $RESULT/$NAME.maxDPv
bcftools view -i 'DP<4031' $FILE -o $RESULT/$NAME.maxDPb.vcf