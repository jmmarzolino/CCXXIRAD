#!/bin/bash -l

#SBATCH --ntasks=15
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=5G
#SBATCH --time=5:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/bam-index.stdout
#SBATCH --job-name='index'
#SBATCH -p koeniglab
#SBATCH --array=1-384

WORKINGDIR=/rhome/jmarz001/bigdata/CCXXIRAD/raw_aligns
cd $WORKINGDIR
SEQLIST=$WORKINGDIR/bams
FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1)
NAME=$(basename "$FILE" | cut -d. -f1)

#samtools index [-bc] [-m INT] aln.bam|aln.cram [out.index]
#Index a coordinate-sorted BAM or CRAM file for fast random access
# -b Create a BAI index. This is currently the default when no format options are used.

module load samtools
samtools index -c $NAME.bam