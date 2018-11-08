README


#################################    BARCODE SPLITTER    #################################################



#################################    QUALITY SCORES    ###################################################

#load more modules than may be necessary but I'm unsure and it doesn't hurt
module load java/7u40
module load picard
module load fastqc/0.11.7
module load samtools

## Format for fastqc function: in files, out directory specification, number of threads (only use 6 on 32Gb machine and match with ntasks in header), -q (quiet) makes only errors in stdout file
# <fastqc somefile.txt someotherfile.txt --outdir=/some/other/dir/ -t 6 -q>

#pipe all file names into fastqc using ls (fed wildcard for files), tell fastqc to use stdin (ie. the files fed from pipe)
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


################################################### radtag_parser.py

#After successfully running radtag_parser.py on the A, P, Y, O logs, I had to manually remove two text lines from the top of the A and P _results outfiles
# then I saved those, ported them into R
# in R I put together an Rmd script which should include all the changes from that point including the sorting by ID/file name, removing the file name clasues..etc