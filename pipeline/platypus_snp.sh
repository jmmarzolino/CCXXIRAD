#!/bin/bash -l

#SBATCH --ntasks=15
#SBATCH --time=168:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/platypus.stdout
#SBATCH --job-name='platypus_calls'
#SBATCH -p koeniglab
#SBATCH --array=1-384

#####                   Calling SNP's                    #####
WORKINGDIR=/rhome/jmarz001/bigdata/CCXXIRAD/raw_aligns
RESULTSDIR=/rhome/jmarz001/bigdata/CCXXIRAD/calls
REFERENCE=/rhome/jmarz001/bigdata/H_Murinum/Practice_Set/Hordeum_vulgare.Hv_IBSC_PGSB_v2.dna.toplevel/Hordeum_vulgare.Hv_IBSC_PGSB_v2.dna.toplevel.fa
SEQLIST=$WORKINGDIR/bams

FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1)
# get basename of file, stripping at "." (267_188.bam -> 267_188)
NAME=$(basename "$FILE" | cut -d. -f1)

module load python

#python Platypus.py callVariants --bamFiles=data.bam --refFile=ref.fa --output=out.vcf
python Platypus.py callVariants --bamFiles=$WORKINGDIR/$NAME.bam --refFile=$REFERENCE --output=$RESULTSDIR/$NAME.vcf