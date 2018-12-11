#!/bin/bash -l

#SBATCH --ntasks=20
#SBATCH --time=168:00:00
#SBATCH --mem=200G
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/freebayes.stdout
#SBATCH --job-name='freebayes'
#SBATCH -p koeniglab
#SBATCH --array=1-384

cd /rhome/jmarz001/bigdata/CCXXIRAD/align
RESULTSDIR=/rhome/jmarz001/bigdata/CCXXIRAD/calls
SEQLIST=bams
FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1)
NAME=$(basename "$FILE" | cut -d. -f1)

module load freebayes #freebayes/1.2.0(default)

#freebayes -f [reference] [infiles.bam] > [outfiles.vcf]
freebayes -k -f /rhome/jmarz001/bigdata/REF/Hordeum_vulgare.Hv_IBSC_PGSB_v2.dna.toplevel \
$NAME.bam > $RESULTSDIR/$NAME.freebayes.vcf

#population priors:
#-k --no-population-priors Equivalent to --pooled-discrete and removal of Ewens Sampling Formula priors

#mappability priors:
#-w --hwe-priors-off
# Disable estimation of the probability of the combination arising under HWE given the allele frequency as estimated by observation frequency.
