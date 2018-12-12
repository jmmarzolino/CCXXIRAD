#!/bin/bash -l

#SBATCH --ntasks=20
#SBATCH --time=168:00:00
#SBATCH --mem=200G
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/freebayes.stdout
#SBATCH --job-name='freebayes'
#SBATCH -p koeniglab

WORK=/rhome/jmarz001/bigdata/CCXXIRAD/align
cd $WORK
RESULTSDIR=/rhome/jmarz001/bigdata/CCXXIRAD/calls

module load freebayes #freebayes/1.2.0(default)

#freebayes -f [reference] [infiles.bam] > [outfiles.vcf]
freebayes -k -f /rhome/jmarz001/bigdata/REF/Hordeum_vulgare.Hv_IBSC_PGSB_v2.dna.toplevel.fa \
$WORK/*.bam > $RESULTSDIR/rad.snps.freebayes.vcf

#population priors:
#-k --no-population-priors Equivalent to --pooled-discrete and removal of Ewens Sampling Formula priors
