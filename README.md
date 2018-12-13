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
   
----   
### Pipeline   
#### barcode_splitter.sh  
split by barcodes with STACKS; requires input prepared earlier (restriction enzyme, plate barcodes, plate location and plant ID)   
### Quality   
#### bar_qc.sh   
generate quality files for barcode split files  
  
----     
### Quality
#### RAD_parser.py  
After successfully running radtag_parser.py on the A, P, Y, O logs, I had to manually remove two text lines from the top of the A and P _results outfiles  
then I saved those, imported to R  
wrote an Rmd script which sort by ID/file name, remove the file name clasues, etc  
  
----   


### Pipeline  
#### trim.sh  
  
#### trim_qc.sh  
  
#### trim_fastqc.sh  
  
----   


#### align_and_group.sh  
align to reference and assign read groups based on ID, population, and growth position  
  
### Pipeline    
#### bam_index.sh  
create indexes for the bam files, for the length of the barley genome, these need to be .csi not .bai (which has a length restriction and will cut your genome prematurely)  
### Quality    
#### csi_lengths.sh   
check the length of the .csi files to see how many reads there are

----  
### Pipeline
#### freebayes_snp.sh  
call snps with freebayes software
-k for populations not in Hardy-Weinberg equilibrium
provide freebayes with a list of .bam files so that all individual plant reads will be used together to call snps: this can improve the accuracy and quality of snp calling and filtering because freebayes can factor in every read per site 
#### snp_caller.sh  
  
----   
### Pipeline  
#### filter.sh  
first round of filtering, excludes low quality and high missing data  
#### qual_filter.sh  
filter based on quality; need to determine which is the right first filter...   


#### filter2.sh  
second round of filtering, excludes....

### Quality
#### filter_stats.sh   
#### snp_dist.sh  
#### snp_dist2.sh  
  
  
# Extra
#### fastqc_cat.sh  
script can be used to concatenate the fastqc files into one output  
