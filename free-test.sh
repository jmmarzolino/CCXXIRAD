#!/bin/bash -l

#SBATCH --ntasks=1
#SBATCH --time=24:00:00
#SBATCH --mem=30G
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/free.stdout
#SBATCH --job-name='free'
#SBATCH -p koeniglab

WORKINGDIR=/rhome/jmarz001/bigdata/CCXXIRAD/raw_aligns
cd $WORKINGDIR
RESULTSDIR=/rhome/jmarz001/bigdata/CCXXIRAD/calls

#freebayes/1.2.0(default)
module load freebayes
#freebayes -f [reference] [infiles.bam] > [outfiles.vcf]

freebayes -k -f /rhome/jmarz001/bigdata/H_Murinum/Hordeum_vulgare.Hv_IBSC_PGSB_v2.dna.toplevel.fa 24_284.bam > 24_284.freebayes.vcf