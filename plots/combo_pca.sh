module load bcftools
# Combine the vcf files from your CCXXI and JBL's CCXXI
# my vcf
/rhome/jmarz001/bigdata/CCXXIRAD/calls/bcftools_filtered/CCXXIRAD.ref_alt_ratio.vcf.gz
# JBL's vcf
/rhome/jmarz001/bigdata/CCXXIRAD/CCXXIRAD2/calls/filter/JBL.ref_alt_ratio.vcf.gz
# the files need to be bgzipped first so that bcftools can use it
bgzip /rhome/jmarz001/bigdata/CCXXIRAD/calls/bcftools_filtered/CCXXIRAD.ref_alt_ratio.vcf
bgzip /rhome/jmarz001/bigdata/CCXXIRAD/CCXXIRAD2/calls/filter/JBL.ref_alt_ratio.vcf
# files must also be indexed
bcftools index /rhome/jmarz001/bigdata/CCXXIRAD/CCXXIRAD2/calls/filter/JBL.ref_alt_ratio.vcf.gz
bcftools index /rhome/jmarz001/bigdata/CCXXIRAD/calls/bcftools_filtered/CCXXIRAD.ref_alt_ratio.vcf.gz
# what needs to happen to them?
# first the vcf files should be merged with bcftools
bcftools merge --file-list seqs -o /rhome/jmarz001/bigdata/CCXXIRAD/CCXXIRAD2/results/combo.vcf

# move on to the pca generation
cd /rhome/jmarz001/bigdata/CCXXIRAD/CCXXIRAD2/results/
plink --id-delim _ --aec --vcf combo.vcf --recode --out combo
# now generate pca
plink --id-delim _ --aec --vcf combo.vcf --pca 5 'header' 'tabs' 'var-wts' --out combo_raw
# minor allele frequency filtering
plink --id-delim _ --aec --vcf combo.vcf --make-bed --maf 0.05 --out combo_maf
# linkage pruning
plink --aec --bfile combo --indep-pairwise 100kb 100 0.8 --out combo_maf_LD
# make filtered pca
plink --aec --bfile combo_maf --extract combo_maf_LD.prune.in --pca 5 'header' 'tabs' 'var-wts' --out combo_filt

# Plotting in R
# Load the .eigenvec file & plot the columns you're interested in
combo_filt <- read.delim("/bigdata/koeniglab/jmarz001/CCXXIRAD/CCXXIRAD2/results/combo_filt.eigenvec")
> combo_filt$researcher <- "JM"
> combo_filt[352:437,8] <- "JBL"

# replace KL numbers with generation numbers for plotting
combo_filt$FID <- gsub("25", "24", combo_filt$FID)
combo_filt$FID <- gsub("24", "F25", combo_filt$FID)
combo_filt$FID <- gsub("267", "F11", combo_filt$FID)


# eigenvalues
13.8766
13.1211
10.9831
9.58344
8.34972

# produce pca's colored by generation number
# PC 1 & 2
ggplot(combo_filt, aes(PC1, PC2)) + geom_point(aes(color=combo_filt$FID)) + xlab("PC1 (13.8%)") + theme_minimal() + ylab("PC2 (13.1%)") + scale_color_manual("Generations", values=wes_palette("GrandBudapest1")) + theme(axis.text=element_text(size=12), axis.title=element_text(size=14,face="bold"))
# PC 2 & 3
ggplot(combo_filt, aes(PC2, PC3)) + geom_point(aes(color=combo_filt$FID)) + xlab("PC2 (13.1%)") + theme_minimal() + ylab("PC3 (10.9%)") + scale_color_manual("Generations", values=wes_palette("GrandBudapest1")) + theme(axis.text=element_text(size=12), axis.title=element_text(size=14,face="bold"))
# PC 3 & 4
ggplot(combo_filt, aes(PC3, PC4)) + geom_point(aes(color=combo_filt$FID)) + xlab("PC3 (10.9%)") + theme_minimal() + ylab("PC4 (9.5%)") + scale_color_manual("Generations", values=wes_palette("GrandBudapest1")) + theme(axis.text=element_text(size=12), axis.title=element_text(size=14,face="bold"))
# PC 4 & 5
ggplot(combo_filt, aes(PC4, PC5)) + geom_point(aes(color=combo_filt$FID)) + xlab("PC4 (9.5%)") + theme_minimal() + ylab("PC5 (8.3%)") + scale_color_manual("Generations", values=wes_palette("GrandBudapest1")) + theme(axis.text=element_text(size=12), axis.title=element_text(size=14,face="bold"))
# "

# Time to filter out those outlier points in the upper left corner
> combo_filt[which(combo_filt[,4]>0.16),1:4]
    FID IID       PC1      PC2
409 F11   2 -0.123941 0.173132
411 F11  21 -0.139206 0.169382
412 F11  22 -0.126240 0.168915
420 F11   3 -0.132837 0.171113


# outliers from
> JBL_pca_MAF_LD[which(JBL_pca_MAF_LD[,4]<(-0.2)),1:4]
   FID IID       PC1       PC2
47 F11   1 -0.271584 -0.234394
58 F11   2  0.274104 -0.233942
60 F11  21  0.273815 -0.235704
61 F11  22  0.274306 -0.235423
69 F11   3  0.284452 -0.242963
73 F11  34 -0.206073 -0.206459
74 F11  36 -0.215500 -0.211834
77 F11  39 -0.279208 -0.236613



module load plink/1.90b3.38
# generate plink files
cd /rhome/jmarz001/bigdata/CCXXIRAD/CCXXIRAD2/calls/filter
plink --id-delim _ --aec --vcf JBL.ref_alt_ratio.vcf.gz --recode --out ../../results/JBL
# now generate pca
plink --id-delim _ --aec --vcf JBL.ref_alt_ratio.vcf.gz --pca 5 'header' 'tabs' 'var-wts' --out ..
/../results/JBL

# minor allele frequency filtering
plink --id-delim _ --aec --vcf JBL.ref_alt_ratio.vcf.gz --make-bed --maf 0.05 --out ../../results/JBL_maf
# linkage pruning
cd ../../results/
plink --aec --bfile JBL_maf --indep-pairwise 100kb 100 0.8 --out JBL_MAF_LD

# make pca
plink --aec --bfile JBL_maf --extract JBL_MAF_LD.prune.in --pca 5 'header' 'tabs' 'var-wts' --out JBL_pca_MAF_LD
