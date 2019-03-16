
# first convert vcf file to plink format file


module load plink/1.90b3.38(default)
plink --id-delim _  --chr-set 12 --vcf CCXXIRAD.ref_alt_ratio.vcf --recode --out ../../results/myplink


# loads a (possibly gzipped) vcf file
--vcf <filename>

# By default, when the GT field is absent, the variant is kept and all genotypes are set to missing. To skip the variant instead, use --vcf-require-gt.

--out <prefix>

plink --vcf myvcf.vcf.gz --recode --out myplink

--id-delim causes sample IDs to be parsed as <FID><delimiter><IID>; the default delimiter is '_'. If any sample ID does not contain exactly one instance of the delimiter, an error is normally reported; however, if you have simultaneously specified --double-id or --const-fid, PLINK will fall back on that approach to handle zero-delimiter IDs.


# next generate a pca

--pca [count] ['header'] ['tabs'] ['var-wts']

plink --aec --vcf CCXXIRAD.ref_alt_ratio.vcf --pca 20 'header' 'tabs' 'var-wts' --out ../../results/pca
# turns out you don't need to do the first step at all!

>pca.eigenval
>pca.eigenvec
>pca.eigenvec.var
>pca.log
>pca.nosex

# Plotting
This is straightforward in R.

1. Load the .eigenvec file.  E.g. "eigenvec_table <- read.table('plink.eigenvec')"

2. Use plot() on the columns you're interested in.  Top eigenvector will be in column 3, second eigenvector will be in column 4, etc., so if you want a set of pairwise plots covering the top 4 eigenvectors, use e.g. "plot(eigenvec_table[3:6])"'


pca <- read.delim("/bigdata/koeniglab/jmarz001/CCXXIRAD/results/pca.eigenvec")

plot(pca[3:4])
# replace KL numbers with generation numbers for plotting
pca$FID <- gsub("24", "F25", pca$FID)
pca$FID <- gsub("267", "F11", pca$FID)
# this is code that generates a beautiful plot <3
ggplot(pca, aes(PC1, PC2)) +  geom_point(aes(color = pca$FID)) + xlab("PC1 (8.036%)") + theme_minimal() + ylab("PC2 (7.045%)") + scale_color_manual("Generations", values=wes_palette("GrandBudapest1")) + theme(axis.text=element_text(size=12), axis.title=element_text(size=14,face="bold"))

# extreme values of PC1 from
# 24_427 w/ PC1=-0.17002700
# 24_348 w/ PC1= 0.08540640

# extreme values of PC2 from
# 24_317 with PC2=-0.27650500
# 267_235 with PC2=0.10439700

# now using plink to generate frequency data
--freq gz & --freqx gz
plink --aec --freqx gz --vcf CCXXIRAD.ref_alt_ratio.vcf --out ../../results/


--pheno <filename>
reads phenotype values from third column of the file (first column must be family ID, second column is within-family ID)


--maf [minimum freq]
--maf filters out all variants with minor allele frequency below the provided threshold (default 0.01)
--mac and --max-mac impose lower and upper minor allele count bounds, respectively.
--read-freq <.freq/.frq/.frq.count/.frqx filename>
--read-freq loads a PLINK 1.07, PLINK 1.9, or GCTA allele frequency report, and estimates MAFs (and heterozygote frequencies, if the report is from --freqx) from the file instead of the current genomic data table. It can be combined with --maf-succ if the file contains observation counts.
filter MAF < 5%

When a minor allele code is missing from the main dataset but present in the --read-freq file, it is now loaded.
