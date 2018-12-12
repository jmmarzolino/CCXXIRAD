#!/usr/bin/env python

#SBATCH -p intel
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=10G
#SBATCH --time=1:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/barcode/results/A_results
#SBATCH --job-name='radtag_parser'

#Read in each line of the example file, split it into separate components, and write certain output to another file

LineNumber = 0
InFileName = '/rhome/jmarz001/bigdata/CCXXIRAD/calls/files'
InFile = open(InFileName, 'r')

foo = 0

for i in InFile:
    file = open('/rhome/jmarz001/bigdata/CCXXIRAD/calls/' + repr(i))
    for c in file:
        foo = foo + 1
        if foo <= 69:
            out='/rhome/jmarz001/bigdata/CCXXIRAD/calls/filtered/' + 'i'
            out.write(''))
        if foo == 69:
            f = v.strip('\t')
            ID = f[9]
            #CHROM  POS     ID      REF     ALT     QUAL    FILTER  INFO    FORMAT  24_419
        v = v.strip('\t')
    ElementList = i.split('\t')
    if LineNumber > 11 and len(ElementList) == 6:
        #print "ElementList:", ElementList #uncomment for debugging
        PlantID = ElementList[1]
        OutputString = "%s\t %s\t %s" % \
        (PlantID, Retained, NoRADTag)
        print OutputString+"\n"
    LineNumber = LineNumber + 1
InFile.close()
