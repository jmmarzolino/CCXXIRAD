# convert vcf file to plink format file
module load plink/1.90b3.38(default)
plink --id-delim _  --chr-set 12 --vcf CCXXIRAD.ref_alt_ratio.vcf --recode --out ../../results/myplink

# loads a (possibly gzipped) vcf file: --vcf <filename>
# By default, when the GT field is absent, the variant is kept and all genotypes are set to missing. To skip the variant instead, use --vcf-require-gt.
# --out <prefix>
# --id-delim causes sample IDs to be parsed as <FID><delimiter><IID>
# the default delimiter is '_'. If any sample ID does not contain exactly one instance of the delimiter, an error is normally reported; however, if you have simultaneously specified --double-id or --const-fid, PLINK will fall back on that approach to handle zero-delimiter IDs.
# plink --vcf myvcf.vcf.gz --recode --out myplink
# --pca [count] ['header'] ['tabs'] ['var-wts']
module load plink/1.90b3.38(default)
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

# generate frequency data
# --freq gz & --freqx gz
# plink --aec --freqx gz --vcf CCXXIRAD.ref_alt_ratio.vcf --out ../../results/
# --read-freq <.freq/.frq/.frq.count/.frqx filename>
# --read-freq loads a PLINK 1.07, PLINK 1.9, or GCTA allele frequency report, and estimates MAFs (and heterozygote frequencies, if the report is from --freqx) from the file instead of the current genomic data table. It can be combined with --maf-succ if the file contains observation counts.

When a minor allele code is missing from the main dataset but present in the --read-freq file, it is now loaded.



########################################################
# filter by linkage disequilibrium

# LD-based variant pruner and haplotype block estimator, and commands to explicitly report LD statistics.
# produce a pruned subset of markers that are in approximate linkage equilibrium with each other, writing the IDs to plink.prune.in (and the IDs of all excluded variants to plink.prune.out)
# Output files are valid input for --extract/--exclude in a future PLINK run.

# PARAMETER DECISIONS

--indep-?? <window size>['kb'] <step size (variant ct)> <r^2 threshold>






# when you're done graph the pca again

##############
# Not yet used notes
# --pheno <filename>
# reads phenotype values from third column of the file (first column must be family ID, second column is within-family ID)
