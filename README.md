### CCXXIRAD
  
## Background
CCXXI F11 (UCRKL000267)  
CCXXI F25 (UCRKL000024)  
 384 plants, ~192 of each  
RAD libraries were made on 4 plates for 4 RAD sequencing lanes, 96 individuals per plate and lane  

## Scripts
download reference genome  
  (barley_downloader.sh)  
  (faidx.sh)


download FASTQ files  
upload plate barcode and ID files   
  "HvRADA2_barcodes.txt"  
  "HvRADO2_barcodes.txt"  
  "HvRADP3_barcodes.txt"  
  "HvRADY3_barcodes.txt"  
  
check quality of downloaded FASTQs   
  (fastq_fastqc.sh)  
  (fastq_qc.sh)  
  
  
  (flowcell_quality.sh)
     
split by barcodes   
  (barcode_splitter.sh)  
  (barcode_qc.sh)  
  
  (RAD_parser.py)
After successfully running radtag_parser.py on the A, P, Y, O logs, I had to manually remove two text lines from the top of the A and P _results outfiles  
then I saved those, imported to R  
wrote an Rmd script which sort by ID/file name, remove the file name clasues, etc  
  
  (trim.sh)
  (trim_qc.sh)/(trim_fastqc.sh)
  
script can be used to concatenate the fastqc files into one output
  (fastqc_cat.sh)  

  
align to reference and assign read groups based on ID, population, and growth position  
  (align_and_group.sh)  
 
(bam_index.sh)
(csi_lengths.sh)

(freebayes_snp.sh)
(snp_caller.sh)

(filter.sh)
(filter_stats.sh)
(filter2.sh)
(qual_filter.sh)


(snp_dist.sh)
(snp_dist2.sh)

