#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=10
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=10G
#SBATCH --time=72:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/calls.stdout
#SBATCH --mail-user=jmarz001@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name='rad_snp_calls'
#SBATCH -p koeniglab
#SBATCH --array=1-384

#####                   Calling SNP's                    #####
##samtools mpileup -uf ref.fa aln.bam | bcftools call -mv -Oz > calls.vcf.gz
WORKINGDIR=/rhome/jmarz001/bigdata/Master/dupfree_aligns/barley_dupfree_aligned.bam
RESULTSDIR=/rhome/jmarz001/bigdata/Master/calls/barley_calls.vcf.gz
REFERENCE=/rhome/jmarz001/bigdata/Practice/Hordeum_vulgare.Hv_IBSC_PGSB_v2.dna.toplevel/Hordeum_vulgare.Hv_IBSC_PGSB_v2.dna.toplevel

module load samtools
module load bcftools

samtools mpileup -uf $REFERENCE $WORKINGDIR | bcftools call -mv -Oz > $RESULTSDIR

######                  Filtering                       ######

gunzip /rhome/jmarz001/bigdata/Master/calls/barley_calls.vcf.gz

module load vcftools

vcftools --vcf /rhome/jmarz001/bigdata/Master/calls/barley_calls.vcf \
--minQ 30 --out /rhome/jmarz001/bigdata/Master/filtered/barley_rawsnpsQUAL30 --recode

