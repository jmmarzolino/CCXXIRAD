#!/bin/bash -l

#SBATCH --ntasks=20
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=5G
#SBATCH --time=5:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/csi.stdout
#SBATCH --job-name='csi'
#SBATCH -p koeniglab
#SBATCH --array=1-384

WORKINGDIR=/rhome/jmarz001/bigdata/CCXXIRAD/align
cd $WORKINGDIR
# first move umapped.bam files into unmapped dir, then ls *.bam >> bams
SEQLIST=$WORKINGDIR/bams
FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1)
NAME=$(basename "$FILE" | cut -d. -f1)

#samtools index [-bc] [-m INT] aln.bam|aln.cram [out.index]
#Index a coordinate-sorted BAM or CRAM file for fast random access
# -b Create a BAI index. This is currently the default when no format options are used.

module load samtools
samtools index -c $NAME.bam