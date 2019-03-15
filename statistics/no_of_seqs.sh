#!/bin/bash -l

#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/no_of_seqs.stdout
#SBATCH --mail-user=jmarz001@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name='no_of_seqs'

#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=10G

#SBATCH --time=1:00:00
#SBATCH -p intel

RAD=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts
cd $RAD

printf "HvRADA2 \n" > $RAD/flowcell_reads
cd /bigdata/koeniglab/shared/SEQ_RUNS/9_14_2018/FASTQ/slimsdata.genomecenter.ucdavis.edu/Data/2tyrhwu7zo/Unaligned/Project_DKJM_HvRADA2
grep "^@" HvRADA2_S8_L008_R1_001.fastq | wc -l >> $RAD/flowcell_reads

printf "HvRADP3 \n" >> $RAD/flowcell_reads
cd /rhome/jmarz001/shared/SEQ_RUNS/9_14_2018/FASTQ/slimsdata.genomecenter.ucdavis.edu/Data/tyvcdh8myc/Unaligned/Project_DKJM_HvRADP3
grep "^@" HvRADP3_S5_L005_R1_001.fastq | wc -l >> $RAD/flowcell_reads

printf "HvRADO2 \n" >> $RAD/flowcell_reads
cd /rhome/jmarz001/shared/SEQ_RUNS/9_14_2018/FASTQ/slimsdata.genomecenter.ucdavis.edu/Data/9e0rmu9j/Unaligned/Project_DKJM_HvRADO2
grep "^@" HvRADO2_S7_L007_R1_001.fastq | wc -l >> $RAD/flowcell_reads

printf "HvRADY3 \n" >> $RAD/flowcell_reads
cd /rhome/jmarz001/shared/SEQ_RUNS/9_14_2018/FASTQ/slimsdata.genomecenter.ucdavis.edu/Data/0g5kd427pb/Unaligned/Project_DKJM_HvRADY3
grep "^@" HvRADY3_S6_L006_R1_001.fastq | wc -l >> $RAD/flowcell_reads


#next time remember that you can just grep -c to count instead of finding seqs and piping it to word count -l