
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
bcftools merge --file-list seqs -o combo.vcf
