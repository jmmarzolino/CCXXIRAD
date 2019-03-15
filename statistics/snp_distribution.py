#!/usr/bin/env python

#SBATCH -p batch
#SBATCH --ntasks=4
#SBATCH --mem-per-cpu=15G
#SBATCH --time=72:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/calls/filtered/qual_distribution
#SBATCH --job-name='snp_qual_dist'

#Read in each line of the example file, split it into separate components, and write certain output to another file
LineNumber = 0
InFileName = '/rhome/jmarz001/bigdata/CCXXIRAD/calls/files'
InFile = open(InFileName, 'r')

for i in InFile:
    i = i.strip('\n')
    #file = open('/rhome/jmarz001/bigdata/CCXXIRAD/calls/' + i)
    filei = open('/rhome/jmarz001/bigdata/CCXXIRAD/calls/24_467.freebayes.vcf')
    foo = 0
    for c in file:
        foo = foo + 1
        if foo == 69:
            f = c.strip('\t')
            ID = f[9]
            #CHROM  POS     ID      REF     ALT     QUAL    FILTER  INFO    FORMAT  24_419
            #out=('/rhome/jmarz001/bigdata/CCXXIRAD/calls/filtered/' + repr(i))
            #out.write(repr(i)+'dist')
        if foo > 69:
            Line = c.strip('\n')
            Elements = Line.strip('\t')
            QUAL = Elements[5]
            OUT = "%s\t %s\t %s\n" % \
        (foo, ID, QUAL)
            print OUT + "\n"
InFile.close()

#check the distribution of snps to see if there are outliers, talk to chris
#calculate distribution of calls for each individual: missing data % per individual, what % homozygous alt/ref and what % het

#depth of the variant, or site, quality: plot distribution and look for outliers, outlier threshhold and apply filters
#filter out variants called one or two times and points covered too high (repetative)
#bcftools...querry: extract specific fields

#20x real to 50x bad
#use het and depth
#high hetero can be contamination: look for missing sample next to it and too high hetero
#true hetero are rare and won't be at every site

#haplotype variant call, ie limit the variant proximity



