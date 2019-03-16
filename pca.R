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
ggplot(pca, aes(PC1, PC2)) +  geom_point(aes(color = pca$FID)) + xlab("PC1 (8.036%)") + theme_minimal() + ylab("PC2 (7.045%)") + scale_color_manual("Generations", values=wes_palette("GrandBudapest1")) + theme(axis.text=element_text(size=12)), axis.title=element_text(size=14,face="bold")



# extreme values of PC1 from
# 24_427 w/ PC1=-0.17002700
# 24_348 w/ PC1= 0.08540640

# extreme values of PC2 from
# 24_317 with PC2=-0.27650500
# 267_235 with PC2=0.10439700
