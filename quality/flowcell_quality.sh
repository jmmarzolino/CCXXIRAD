#!/bin/bash -l

#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/retained.stdout
#SBATCH --mail-user=jmarz001@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name='retained'

#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=10G

#SBATCH --time=1:00:00
#SBATCH -p intel

#Get the number of reads from before and after trimming
RAD=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts

###4 RAW READS
#FASTQ's
A=/rhome/jmarz001/shared/SEQ_RUNS/9_14_2018/FASTQ/slimsdata.genomecenter.ucdavis.edu/Data/2tyrhwu7zo/Unaligned/Project_DKJM_HvRADA2/HvRADA2_S8_L008_R1_001.fastq
P=/rhome/jmarz001/shared/SEQ_RUNS/9_14_2018/FASTQ/slimsdata.genomecenter.ucdavis.edu/Data/tyvcdh8myc/Unaligned/Project_DKJM_HvRADP3/HvRADP3_S5_L005_R1_001.fastq
O=/rhome/jmarz001/shared/SEQ_RUNS/9_14_2018/FASTQ/slimsdata.genomecenter.ucdavis.edu/Data/9e0rmu9j/Unaligned/Project_DKJM_HvRADO2/HvRADO2_S7_L007_R1_001.fastq
Y=/rhome/jmarz001/shared/SEQ_RUNS/9_14_2018/FASTQ/slimsdata.genomecenter.ucdavis.edu/Data/0g5kd427pb/Unaligned/Project_DKJM_HvRADY3/HvRADY3_S6_L006_R1_001.fastq

printf "Filename \t Average Quality \n" > $RAD/flowcell_qualA
python avg_qual.py $A >> $RAD/flowcell_qualA
printf "Filename \t Average Quality \n" > $RAD/flowcell_qualO
python avg_qual.py $O >> $RAD/flowcell_qualO
printf "Filename \t Average Quality \n" > $RAD/flowcell_qualP
python avg_qual.py $P >> $RAD/flowcell_qualP
printf "Filename \t Average Quality \n" > $RAD/flowcell_qualY
python avg_qual.py $Y >> $RAD/flowcell_qualY

python < script.py > outfile
###BARCODE SPLIT
BAR=/rhome/jmarz001/bigdata/CCXXIRAD/barcode
files=*.fq

for $files in $BAR; do
  python avg_qual.py
done

###TRIMMED
TRIM=/rhome/jmarz001/bigdata/CCXXIRAD/trimmed/

