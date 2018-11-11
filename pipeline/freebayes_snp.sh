#!/bin/bash -l

#SBATCH --ntasks=15
#SBATCH --time=168:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/freebayes.stdout
#SBATCH --job-name='freebayes'
#SBATCH -p koeniglab
#SBATCH --array=1-384

WORKINGDIR=/rhome/jmarz001/bigdata/CCXXIRAD/raw_aligns
RESULTSDIR=/rhome/jmarz001/bigdata/CCXXIRAD/calls
REFERENCE=/rhome/jmarz001/bigdata/H_Murinum/Practice_Set/Hordeum_vulgare.Hv_IBSC_PGSB_v2.dna.toplevel/Hordeum_vulgare.Hv_IBSC_PGSB_v2.dna.toplevel
SEQLIST=$WORKINGDIR/bams

FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1)
# get basename of file, stripping at "." (267_188.bam -> 267_188)
NAME=$(basename "$FILE" | cut -d. -f1)

#freebayes/1.2.0(default)
module load freebayes
#freebayes -f [reference] [infiles.bam] > [outfiles.vcf]

#  -L --bam-list FILE
#                   A file containing a list of BAM files to be analyzed.
# --populations FILE
#                   Each line of FILE should list a sample and a population which
#                   it is part of.  The population-based bayesian inference model
#                   will then be partitioned on the basis of the populations.
#   -m --min-mapping-quality Q
#                   Exclude alignments from analysis if they have a mapping
#                   quality less than Q.  default: 1
#   -q --min-base-quality Q
#                   Exclude alleles from analysis if their supporting base
#                   quality is less than Q.  default: 0
#   -Q --mismatch-base-quality-threshold Q
#                   Count mismatches toward --read-mismatch-limit if the base
#                   quality of the mismatch is >= Q.  default: 10
#   -w --hwe-priors-off
#                   Disable estimation of the probability of the combination
#                   arising under HWE given the allele frequency as estimated
#                   by observation frequency.

freebayes -w -f $REFERENCE \
$WORKINGDIR/$NAME.bam > $RESULTSDIR/$NAME.freebayes.vcf
