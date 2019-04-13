module load plink/1.90b3.38
# generate plink files
plink --id-delim _ --aec --vcf JBL.ref_alt_ratio.vcf --recode --out ../../results/JBL
# now generate pca
plink --id-delim _ --aec --vcf JBL.ref_alt_ratio.vcf --pca 5 'header' 'tabs' 'var-wts' --out ..
/../results/JBL

# minor allele frequency filtering
plink --id-delim _ --aec --vcf JBL.ref_alt_ratio.vcf --make-bed --maf 0.05 --out ../../results/JBL_maf
# linkage pruning
cd ../../results/
plink --aec --bfile JBL_maf --indep-pairwise 100kb 100 0.8 --out JBL_MAF_LD

# make pca
plink --aec --bfile JBL_maf --extract JBL_MAF_LD.prune.in --pca 5 'header' 'tabs' 'var-wts' --out JBL_pca_MAF_LD
