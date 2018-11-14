### CCXXIRAD


## Background
CCXXI F11 (UCRKL000267)  
CCXXI F25 (UCRKL000024)  
96x2 = 192 seeds of each generation  
total of 384 seeds  

RAD libraries were made with on 4 plates for 4 RAD sequencing lanes  

## Code
download FASTQ files  
upload plate barcode and ID files   
  (HvRAD(A2etc)_barcodes.txt)  
check quality of downloaded FASTQs   
  (fastq_fastqc.sh)  
  #################################    QUALITY SCORES    ###################################################   
  
module load picard
module load fastqc/0.11.7

Format for fastqc function: in files, out directory specification, number of threads (only use 6 on 32Gb machine and match with ntasks in header), -q (quiet) makes only errors in stdout file
<fastqc somefile.txt someotherfile.txt --outdir=/some/other/dir/ -t 6 -q>

cd /rhome/jmarz001/bigdata/CCXXIRAD/barcode/

for file in *.gz
do
  gunzip "$file" | fastqc stdin \
  --outdir=/rhome/jmarz001/bigdata/CCXXIRAD/quality/"$file_qual" -t 6 -q
done

for file in *.fq
do
  fastqc "$file" --outdir=/rhome/jmarz001/bigdata/CCXXIRAD/quality/"$file_qual" -t 6 -q
done
  
  
split by barcodes   
  (barcode_splitter.sh)  
align  
  (align.sh)  
  
more things I need to add
