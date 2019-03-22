#!/usr/bin/bash -l

#SBATCH -p batch
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=10G
#SBATCH --time=12:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/trim.stdout
#SBATCH --job-name='rad_trim'

module load trimmomatic/0.36

TRIMMOMATIC=/opt/linux/centos/7.x/x86_64/pkgs/trimmomatic/0.36/trimmomatic.jar
ADAPTERDIR=/opt/linux/centos/7.x/x86_64/pkgs/trimmomatic/0.33/adapters

WORK=/rhome/jmarz001/bigdata/CCXXIRAD/barcode/ssv
RESULT=/rhome/jmarz001/bigdata/CCXXIRAD/trim/ssv
mkdir $RESULT

java -jar $TRIMMOMATIC SE -threads 4 \
$WORK/267_75.fq $RESULT/267_75_trimmed.fq \
ILLUMINACLIP:"$ADAPTERDIR"/TruSeq3-SE.fa:2:30:10 \
LEADING:5 TRAILING:5 SLIDINGWINDOW:4:20 MINLEN:36

java -jar $TRIMMOMATIC SE -threads 4 \
$WORK/267_206.fq $RESULT/267_206_trimmed.fq \
ILLUMINACLIP:"$ADAPTERDIR"/TruSeq3-SE.fa:2:30:10 \
LEADING:5 TRAILING:5 SLIDINGWINDOW:4:20 MINLEN:36

java -jar $TRIMMOMATIC SE -threads 4 \
$WORK/24_343.fq $RESULT/24_343_trimmed.fq \
ILLUMINACLIP:"$ADAPTERDIR"/TruSeq3-SE.fa:2:30:10 \
LEADING:5 TRAILING:5 SLIDINGWINDOW:4:20 MINLEN:36

java -jar $TRIMMOMATIC SE -threads 4 \
$WORK/24_380.fq $RESULT/24_380_trimmed.fq \
ILLUMINACLIP:"$ADAPTERDIR"/TruSeq3-SE.fa:2:30:10 \
LEADING:5 TRAILING:5 SLIDINGWINDOW:4:20 MINLEN:36
