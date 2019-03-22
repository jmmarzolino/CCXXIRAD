#!/bin/bash -l

#SBATCH --ntasks=2
#SBATCH --mem-per-cpu=20G
#SBATCH --time=2:00:00
#SBATCH --output=cut_sites.stdout
#SBATCH --job-name="kpni"
#SBATCH --partition=short

grep -c "GGTACC" /rhome/jmarz001/shared/GENOMES/NEW_BARLEY/GENOME_SPLIT/barley_split_reference.fa > /rhome/jmarz001/bigdata/CCXXIRAD/calls/bcftools_filtered/kpni5_sites

grep -c "CCATGG" /rhome/jmarz001/shared/GENOMES/NEW_BARLEY/GENOME_SPLIT/barley_split_reference.fa > /rhome/jmarz001/bigdata/CCXXIRAD/calls/bcftools_filtered/kpni3_sites

# 5' sites: 543801
# 3' sites: 1455615
# total = 1,999,416 ~ 2,000,000
