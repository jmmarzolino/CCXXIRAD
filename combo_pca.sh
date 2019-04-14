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

# replace KL numbers with generation numbers for plotting
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
