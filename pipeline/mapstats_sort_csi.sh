#!/bin/bash -l

#SBATCH --ntasks=1
#SBATCH --time=24:00:00
#SBATCH --mem=20G
#SBATCH --output=/rhome/jmarz001/bigdata/rad_test/scripts/stats_sort_csi.stdout
#SBATCH --job-name='stats_sort'
#SBATCH -p koeniglab

module load samtools

# mapping stats
samtools flagstat /rhome/jmarz001/bigdata/24_284.sam > 24_284_mapstats.txt

# sam to sorted bam
samtools view -bS 24_284.sam | samtools sort -o 24_284.bam

samtools index -c 24_284.bam

# Then retry the freebayes call: also, you should not need to retrim/ parse
