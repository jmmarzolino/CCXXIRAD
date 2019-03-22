#!/bin/bash -l

#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=20G
#SBATCH --time=1:00:00
#SBATCH --output=density.stdout
#SBATCH --job-name="den"
#SBATCH --partition=short

module load vcftools/0.1.13
vcftools --vcf /rhome/jmarz001/bigdata/CCXXIRAD/calls/bcftools_filtered/CCXXIRAD.ref_alt_ratio.vcf --SNPdensity 10kb --out CCXXIRAD_density
vcftools --vcf /rhome/jmarz001/bigdata/CCXXIRAD/calls/bcftools_filtered/CCXXIRAD.ref_alt_ratio.vcf --SNPdensity 10000 --out CCXXIRAD_full_density
