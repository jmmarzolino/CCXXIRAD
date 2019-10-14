#!/usr/bin/bash -l

#SBATCH -p short
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=10G
#SBATCH --time=1:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/combined_CCXXI/scripts/cmd001.5_JBLcopy.stdout
#SBATCH --job-name='combine_directories'
#SBATCH --array=1-86

FQ=/rhome/jmarz001/shared/SEQ_RUNS/10_9_2017/PARSED
BAR=/rhome/jmarz001/shared/SEQ_RUNS/10_9_2017/BARCODE/HvRAD16_barcodes.txt
FILE=$(head -n $SLURM_ARRAY_TASK_ID $BAR| tail -n 1 | cut -f2)
cp $FQ/${FILE}.fq.gz /rhome/jmarz001/bigdata/CCXXIRAD/combined_CCXXI/data/raw_reads
