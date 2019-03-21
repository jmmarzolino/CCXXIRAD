# convert vcf file to plink format file
module load plink/1.90b3.38
plink --id-delim _  --aec --vcf CCXXIRAD.ref_alt_ratio.vcf --recode --out ../../results/myplink

# loads a (possibly gzipped) vcf file: --vcf <filename>
# By default, when the GT field is absent, the variant is kept and all genotypes are set to missing. To skip the variant instead, use --vcf-require-gt.
# --out <prefix>
# --id-delim causes sample IDs to be parsed as <FID><delimiter><IID>
# the default delimiter is '_'. If any sample ID does not contain exactly one instance of the delimiter, an error is normally reported; however, if you have simultaneously specified --double-id or --const-fid, PLINK will fall back on that approach to handle zero-delimiter IDs.
# plink --vcf myvcf.vcf.gz --recode --out myplink
# --pca [count] ['header'] ['tabs'] ['var-wts']
module load plink/1.90b3.38
plink --aec --vcf CCXXIRAD.ref_alt_ratio.vcf --pca 20 'header' 'tabs' 'var-wts' --out ../../results/pca
# >pca.eigenval
# >pca.eigenvec
# >pca.eigenvec.var
# >pca.log
# >pca.nosex


####################################################
# filter by minor allele frequency
# remove variants with minor allele frequency below 5%

# --maf [minimum freq]
# --maf filters out all variants with minor allele frequency below the provided threshold (default 0.01)
# --mac and --max-mac impose lower and upper minor allele count bounds, respectively.

# When a minor allele code is missing from the main dataset but present in the --read-freq file, it is now loaded.
# --read-freq <.freq/.frq/.frq.count/.frqx filename>
# --read-freq loads a PLINK 1.07, PLINK 1.9, or GCTA allele frequency report, and estimates MAFs (and heterozygote frequencies, if the report is from --freqx) from the file instead of the current genomic data table. It can be combined with --maf-succ if the file contains observation counts.
# how to generate the frequency data
# --freq gz & --freqx gz
plink --aec --freq gz --vcf CCXXIRAD.ref_alt_ratio.vcf --out ../../results/
# then take the MAF column (cut -f5) from that per-site frequency file > minor_allele_freq

# start working on doing this for the individual families (F11 and F25)
plink --aec --id-delim _ --family --freq gz --vcf CCXXIRAD.ref_alt_ratio.vcf --out ../../results/F11
plink --aec --id-delim _ --family --freq gz --vcf CCXXIRAD.ref_alt_ratio.vcf --out ../../results/F25
zcat F11.frq.strat.gz | awk '$3 ~ /24/{print $6;}' > F25_MAF
zcat F11.frq.strat.gz | awk '$3 ~ /267/{print $6;}' > F11_MAF
# load files into R studio for MAF spectrum graphing
######################################################################################################################################################

# need to create a bed file from the vcf in order to enact the maf filter with following command:
#--make-bed creates a new PLINK 1 binary fileset, after applying sample/variant filters and other operations
# load the binary fileset plink.bed + plink.bim + plink.fam files with --bfile [prefix]
# individual "b" file prefixes can be set with --bed <filename>, --bim <filename> etc.

module load plink/1.90b3.38
plink --aec --vcf CCXXIRAD.ref_alt_ratio.vcf --make-bed --maf 0.05 --out ../../results/CCXXIRAD_maf

###### MAF FILTER RESULTS
> wrote .bed, .bim, and .fam
40733 variants loaded from .bim file.
Total genotyping rate is 0.61556.
21515 variants removed due to minor allele threshold(s)
(--maf/--max-maf/--mac/--max-mac).
19218 variants and 351 people pass filters and QC.

########################################################
# filter by linkage disequilibrium
# 1. find argument for measuring/filtering LD
# 2. find or create metrics for filtering LD, decide what works
# 3. find arguments for filtering out variants in LD
# 4. create pca again from pruned and filtered data

# --indep <window size>['kb'] <step size (variant ct)> <VIF threshold>
# LD-based variant pruner and haplotype block estimator, and commands to explicitly report LD statistics.
# produce a pruned subset of markers that are in approximate linkage equilibrium with each other, writing the IDs to plink.prune.in (and the IDs of all excluded variants to plink.prune.out)
# Output files are valid input for --extract/--exclude in a future PLINK run.

module load plink/1.90b3.38

plink --aec --bfile CCXXIRAD_maf --indep 10kb 100 10 --out CCXXIRAD_MAF_10LD
Pruned 12 variants from chromosome 27, leaving 1234.
Pruned 18 variants from chromosome 28, leaving 1364.
Pruned 19 variants from chromosome 29, leaving 1392.
Pruned 21 variants from chromosome 30, leaving 1305.
Pruned 28 variants from chromosome 31, leaving 1514.
Pruned 14 variants from chromosome 32, leaving 1463.
Pruned 23 variants from chromosome 33, leaving 1155.
Pruned 16 variants from chromosome 34, leaving 1355.
Pruned 17 variants from chromosome 35, leaving 1116.
Pruned 24 variants from chromosome 36, leaving 1426.
Pruned 4 variants from chromosome 37, leaving 1298.
Pruned 19 variants from chromosome 38, leaving 1423.
Pruned 9 variants from chromosome 39, leaving 1418.
Pruned 15 variants from chromosome 40, leaving 1227.
Pruned 0 variants from chromosome 41, leaving 74.
Pruned 9 variants from chromosome 42, leaving 206.
Pruning complete.  248 of 19218 variants removed.

# when you're done graph the pca again
plink --aec --bfile CCXXIRAD_maf --extract CCXXIRAD_MAF_10LD.prune.in --pca 20 'header' 'tabs' 'var-wts' --out pca_MAF_exclude_10LD

# updtae with informed r^2 values for LD pruning (window=100kb, step=100, r^2=0.8 or 0.9)
# --indep-pairwise <window size>['kb'] <step size (variant ct)> <r^2 threshold>
cd /rhome/jmarz001/bigdata/CCXXIRAD/results
plink --aec --bfile CCXXIRAD_maf --indep-pairwise 100kb 100 0.8 --out CCXXIRAD_MAF_LD
Pruned 13 variants from chromosome 27, leaving 1233.
Pruned 27 variants from chromosome 28, leaving 1355.
Pruned 20 variants from chromosome 29, leaving 1391.
Pruned 23 variants from chromosome 30, leaving 1303.
Pruned 37 variants from chromosome 31, leaving 1505.
Pruned 16 variants from chromosome 32, leaving 1461.
Pruned 25 variants from chromosome 33, leaving 1153.
Pruned 20 variants from chromosome 34, leaving 1351.
Pruned 18 variants from chromosome 35, leaving 1115.
Pruned 23 variants from chromosome 36, leaving 1427.
Pruned 10 variants from chromosome 37, leaving 1292.
Pruned 26 variants from chromosome 38, leaving 1416.
Pruned 15 variants from chromosome 39, leaving 1412.
Pruned 18 variants from chromosome 40, leaving 1224.
Pruned 0 variants from chromosome 41, leaving 74.
Pruned 9 variants from chromosome 42, leaving 206.
Pruning complete.  300 of 19218 variants removed.

# pca time
plink --aec --bfile CCXXIRAD_maf --extract CCXXIRAD_MAF_LD.prune.in --pca 10 'header' 'tabs' 'var-wts' --out pca_MAF_LD
# and now take the files over to R for graphing

##############
# Not yet used notes

# --pheno <filename>
# reads phenotype values from third column of the file (first column must be family ID, second column is within-family ID)
