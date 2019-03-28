#!/usr/bin/bash -l

#SBATCH -p batch
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=10G
#SBATCH --time=12:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/trim.stdout
#SBATCH --job-name='rad_trim'
cd /rhome/jmarz001/bigdata/CCXXIRAD/calls/
# check variant filtering
head -n 100 rad.chr1H_1_279267716.freebayes.snps.vcf > test.vcf
# edit test.vcf by hand: lower quality and make sure it gets filtered in/out

##FORMAT=<ID=DP,Number=1,Type=Integer,Description="Read Depth">
# GT:DP:AD:RO:QR:AO:QA:GL
# made 24_358 depth high enough --> kept
# made 24_326s depth=1 --> kept but it should not be...

module load bcftools/1.8
bcftools view -i 'DP>1 & DP<4031' test.vcf -o test.minalt.vcf

# two individuals, check that a few sequences maintain identity
module load bcftools/1.8 samtools/1.9
cd /rhome/jmarz001/bigdata/CCXXIRAD/calls/bcftools_filtered
# individuals
# 24_358, 24_326, 267_99
# sample file must contain samples to subset by (ie. those included and not excluded)?
bcftools view --samples-file samp.txt --force-samples -o test_indv.vcf CCXXIRAD.genomesnps.vcf.gz

# now use individuals to check plink identity maintinance
module load plink/1.90b3.38
plink --id-delim _  --aec --vcf test_indv.vcf --recode --out /rhome/jmarz001/bigdata/CCXXIRAD/results/test
plink --aec --vcf test_indv.vcf --pca 2 'header' 'tabs' 'var-wts' --out /rhome/jmarz001/bigdata/CCXXIRAD/results/test
