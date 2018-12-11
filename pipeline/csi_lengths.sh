#!/bin/bash -l

#SBATCH --ntasks=15
#SBATCH --cpus-per-task=1
#SBATCH --mem=150G
#SBATCH --time=5:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/csi_lengths.stdout
#SBATCH -p koeniglab
#SBATCH --job-name='csi_lengths'
#SBATCH --array=1-384

WORKINGDIR=/rhome/jmarz001/bigdata/CCXXIRAD/align
cd $WORKINGDIR
SEQLIST=$WORKINGDIR/bams
FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1)
NAME=$(basename "$FILE" | cut -d. -f1)

#samtools   idxstats       BAM index stats
# samtools idxstats <aln.bam>

module load samtools
STATS=$(samtools idxstats $NAME.bam)
printf "$NAME \t $STATS \n" >> csi.lengths.txt