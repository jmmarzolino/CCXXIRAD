#!/usr/bin/env R
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/qualR.stdout
#SBATCH -p koeniglab

#Load package
library(ShortRead)

#name and import files
# flowcell raw sequences
Aline = countLines(dirPath="/bigdata/koeniglab/shared/SEQ_RUNS/9_14_2018/FASTQ/slimsdata.genomecenter.ucdavis.edu/Data/2tyrhwu7zo/Unaligned/Project_DKJM_HvRADA2", pattern=".fastq")/4
Pline = countLines(dirPath="/bigdata/koeniglab/shared/SEQ_RUNS/9_14_2018/FASTQ/slimsdata.genomecenter.ucdavis.edu/Data/tyvcdh8myc/Unaligned/Project_DKJM_HvRADP3", pattern=".fastq")/4
Oline = countLines(dirPath="/bigdata/koeniglab/shared/SEQ_RUNS/9_14_2018/FASTQ/slimsdata.genomecenter.ucdavis.edu/Data/9e0rmu9j/Unaligned/Project_DKJM_HvRADO2", pattern=".fastq")/4
Yline = countLines(dirPath="/bigdata/koeniglab/shared/SEQ_RUNS/9_14_2018/FASTQ/slimsdata.genomecenter.ucdavis.edu/Data/0g5kd427pb/Unaligned/Project_DKJM_HvRADY3", pattern=".fastq")/4
lines <- c(Aline, Pline, Oline, Yline)
write(lines, file="/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/raw_lines.stdout")
