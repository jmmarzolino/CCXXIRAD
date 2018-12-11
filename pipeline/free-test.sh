#!/bin/bash -l

#SBATCH --ntasks=1
#SBATCH --time=24:00:00
#SBATCH --mem=30G
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/snp_call.stdout
#SBATCH --job-name='snps'
#SBATCH -p koeniglab

#freebayes/1.2.0(default)
module load freebayes
#freebayes -f [reference] [infiles.bam] > [outfiles.vcf]

freebayes -k -f /rhome/jmarz001/bigdata/REF/Hordeum_vulgare.Hv_IBSC_PGSB_v2.dna.toplevel.fa 24_284.bam > 24_284.freebayes.vcf