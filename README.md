# CCXXIRAD
  
## Background
CCXXI F11 (UCRKL000267)  
CCXXI F25 (UCRKL000024)  
 384 plants, ~192 of each  
RAD libraries were made on 4 plates for 4 RAD sequencing lanes, 96 individuals per plate and lane  

## Scripts  
### Pipeline
#### barley_downloader.sh  
download reference genome  
#### faidx.sh  
index the reference genome  
  
   
### Pipeline   
download FASTQ files  
upload plate barcode and ID files   
  "HvRADA2_barcodes.txt"  
  "HvRADO2_barcodes.txt"  
  "HvRADP3_barcodes.txt"  
  "HvRADY3_barcodes.txt"  
### Quality  
#### fastq_qc.sh  
check quality of downloaded FASTQs  
   
   
### Pipeline   
#### barcode_splitter.sh  
split by barcodes with STACKS; requires input prepared earlier (restriction enzyme, plate barcodes, plate location and plant ID)   
### Quality   
#### bar_qc.sh   
generate quality files for barcode split files  
  
  
### Quality
#### RAD_parser.py  
After successfully running radtag_parser.py on the A, P, Y, O logs, I had to manually remove two text lines from the top of the A and P _results outfiles  
then I saved those, imported to R  
wrote an Rmd script which sort by ID/file name, remove the file name clasues, etc  
  
  
### Pipeline 
#### trim.sh  
  
#### trim_qc.sh  
  
#### trim_fastqc.sh  
  
  
#### align_and_group.sh  
align to reference and assign read groups based on ID, population, and growth position  
  
  
#### bam_index.sh  
#### csi_lengths.sh  
  
#### freebayes_snp.sh  
#### snp_caller.sh  
  
#### filter.sh  
#### filter_stats.sh  
#### filter2.sh  
#### qual_filter.sh  
  
  
#### snp_dist.sh
#### snp_dist2.sh
  
  
# Extra
#### fastqc_cat.sh  
script can be used to concatenate the fastqc files into one output  
