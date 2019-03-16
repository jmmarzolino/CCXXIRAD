#!/bin/bash -l

#SBATCH -p koeniglab
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=20G
#SBATCH --time=10:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/fastq_fastqc.stdout
#SBATCH --job-name='fastq_fastqc'

module load fastqc/0.11.7

# Single FASTQ FASTQC, before demultiplex
fastqc /rhome/jmarz001/shared/SEQ_RUNS/9_14_2018/FASTQ/slimsdata.genomecenter.ucdavis.edu/Data/tyvcdh8myc/Unaligned/Project_DKJM_HvRADP3/HvRADP3_S5_L005_R1_001.fastq --outdir=/rhome/jmarz001/bigdata/CCXXIRAD/HvRADP -t 4 -q

fastqc /rhome/jmarz001/shared/SEQ_RUNS/9_14_2018/FASTQ/slimsdata.genomecenter.ucdavis.edu/Data/0g5kd427pb/Unaligned/Project_DKJM_HvRADY3/HvRADY3_S6_L006_R1_001.fastq --outdir=/rhome/jmarz001/bigdata/CCXXIRAD/HvRADY -t 4 -q

fastqc /rhome/jmarz001/shared/SEQ_RUNS/9_14_2018/FASTQ/slimsdata.genomecenter.ucdavis.edu/Data/9e0rmu9j/Unaligned/Project_DKJM_HvRADO2/HvRADO2_S7_L007_R1_001.fastq --outdir=/rhome/jmarz001/bigdata/CCXXIRAD/HvRADO -t 4 -q

fastqc /rhome/jmarz001/shared/SEQ_RUNS/9_14_2018/FASTQ/slimsdata.genomecenter.ucdavis.edu/Data/2tyrhwu7zo/Unaligned/Project_DKJM_HvRADA2/HvRADA2_S8_L008_R1_001.fastq --outdir=/rhome/jmarz001/bigdata/CCXXIRAD/HvRADA -t 4 -q
