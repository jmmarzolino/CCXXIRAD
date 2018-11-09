#!/bin/bash -l

#SBATCH --ntasks=15
#SBATCH --time=168:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/freebayes.stdout
#SBATCH --job-name='freebayes'
#SBATCH -p koeniglab
#SBATCH --array=1-384

#####                   Calling SNP's                    #####

WORKINGDIR=/rhome/jmarz001/bigdata/CCXXIRAD/raw_aligns
RESULTSDIR=/rhome/jmarz001/bigdata/CCXXIRAD/calls
REFERENCE=/rhome/jmarz001/bigdata/Practice/Hordeum_vulgare.Hv_IBSC_PGSB_v2.dna.toplevel/Hordeum_vulgare.Hv_IBSC_PGSB_v2.dna.toplevel
SEQLIST=$WORKINGDIR/bams

FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1)
# get basename of file, stripping at "." (267_188.bam -> 267_188)
NAME=$(basename "$FILE" | cut -d. -f1)

#freebayes/1.2.0(default)
module load freebayes
#freebayes -f [reference] [infiles.bam] > [outfiles.vcf]
freebayes -f $REFERENCE \
$WORKINGDIR/$NAME.bam > $RESULTSDIR/$NAME.freebayes.vcf