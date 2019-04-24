module load plink
#  pca generation
VCF=/rhome/jmarz001/bigdata/CCXXIRAD/calls/bcftools_filtered
RESULTS=/rhome/jmarz001/bigdata/CCXXIRAD/results
# minor allele frequency filtering
plink --id-delim _ --aec --vcf $VCF/CCXXIRAD2.ref_alt_ratio.vcf --make-bed --maf 0.05 --out $RESULTS/CCXXIRAD2
# linkage pruning
plink --aec --bfile $RESULTS/CCXXIRAD2 --indep-pairwise 100kb 100 0.8 --out $RESULTS/CCXXIRAD2
# make filtered pca
plink --aec --bfile $RESULTS/CCXXIRAD2 --extract $RESULTS/CCXXIRAD2.prune.in --pca 5 'header' 'tabs' 'var-wts' --out $RESULTS/CCXXIRAD2_filt_pruned
