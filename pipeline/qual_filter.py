#!/usr/bin/env python

#SBATCH -p intel
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=10G
#SBATCH --time=1:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/barcode/results/A_results
#SBATCH --job-name='radtag_parser'

#Read in each line of the example file, split it into separate components, and write certain output to another file
InFileName = '/rhome/jmarz001/bigdata/CCXXIRAD/calls/files'
InFile = open(InFileName, 'r')
foo = 0

for i in InFile:
    file = open('/rhome/jmarz001/bigdata/CCXXIRAD/calls/' + repr(i))
    for c in file:
        foo = foo + 1
        if foo <= 69: #copy every line that starts with "^#" (first 69 lines)
            out='/rhome/jmarz001/bigdata/CCXXIRAD/calls/filtered/' + 'i'
            out.write(c) #write those lines out
        if foo == 69: #and for lines > 69,
            c = c.strip('\n')
            element = c.split('\t') #cut the columns into elements
            ID = element[9] #element 9 is the plant ID, just store this as ID
        if foo > 69:
            v = c.strip('\n')
            element = v.split('\t')
            qual = element[5] #element 5 is the quality score
            if qual >= 30: #if quality is greater than or equal to a #
                out.write(c) #then copy it to the new file name
            else:
                continue #if not high quality, ignore
        #OutputString = "%s\t %s\t %s" % (PlantID, Retained, NoRADTag)
        #print OutputString+"\n"

InFile.close()
file.close()
#CHROM  POS     ID      REF     ALT     QUAL    FILTER  INFO    FORMAT  24_419