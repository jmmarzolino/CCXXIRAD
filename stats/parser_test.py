#!/usr/bin/env python

#SBATCH -p koeniglab
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=32G
#SBATCH --time=10:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/barcode/parser_test.stdout
#SBATCH --job-name='parse_test'

#Read in each line of the example file, split it into separate components, and write certain output to another file

#set input file name
InFileName = 'process_radtags.Project_DKJM_HvRADA2.log'
#open input file
InFile = open(InFileName, 'r')
#initialize line number counter
LineNumber = 0

#Open output for writing result
OutFileName="parse_test"
# w for write, a for append
OutFile=open(OutFileName, 'w')

#Loop through each line in file
for Line in InFile:
    while LineNumber > 13:
        Line = Line.strip('\n')
        ElementList=Line.split('\t')
        print "ElementList:", ElementList #uncomment for debugging
        
        #PlantID = ElementList[1]
        #Retained = float(ElementList[5])/float(ElementList[2])
        #NoRADTag = float(ElementList[3])/float(ElementList[2])
        
        #Retained=str(Retained)
        #NoRADTag=str(NoRADTag)
        
        #OutputString = "PlantID %s\tPercentRetained %s\tPercentNoRADTag %s" % \
        #(PlantID, Retained, NoRADTag)
            
        #print OutputString
        #if WriteOutFile:
        #    OutFile.write(OutputString+"\n")
    LineNumber = LineNumber + 1
        #if Line.split() == "" :
        #    break

InFile.close()
if WriteOutFile:
    OutFile.close()