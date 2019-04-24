# remove 4 outlier points from combined data
cd /rhome/jmarz001/bigdata/CCXXIRAD/CCXXIRAD2/results/
# take linkage pruned out file and make a file with four indv to remove
# make filtered pca
# --remove removes all all listed samples from the current analysis
plink --aec --bfile combo_maf --extract combo_maf_LD.prune.in --recode --out combo_filt
# reads in ped file and generated bed and then pca
plink --aec --file combo_filt --remove four_outliers --pca 5 'header' 'tabs' 'var-wts' --out combo_filt_outliers

# remove 4 outlier points from original data set only
# --remove removes all all listed samples from the current analysis
plink --aec --bfile JBL_maf --extract JBL_MAF_LD.prune.in --recode --out JBL_filt
# reads in ped file and generated bed and then pca
plink --aec --file JBL_filt --remove four_outliers --pca 5 'header' 'tabs' 'var-wts' --out JBL_filt_outliers
