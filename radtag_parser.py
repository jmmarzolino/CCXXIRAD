#!/usr/bin/env python

#SBATCH -p intel
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=10G
#SBATCH --time=1:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/barcode/results/A_results
#SBATCH --job-name='radtag_parser'

#Read in each line of the example file, split it into separate components, and write certain output to another file

#initialize line number counter
LineNumber = 0
#set input file name
InFileName = 'process_radtags.Project_DKJM_HvRADA2.log'
#InFileName = 'process_radtags.Project_DKJM_HvRADO2.log'
#InFileName = 'process_radtags.Project_DKJM_HvRADP3.log'
#InFileName = 'process_radtags.Project_DKJM_HvRADY3.log'
#open input file
#initialize line number counter
InFile = open(InFileName, 'r')
#Loop through each line in file
    for Line in InFile:
        Line = Line.strip('\n')
        ElementList = Line.split('\t')
        if LineNumber > 11 and len(ElementList) == 6:
            #print "ElementList:", ElementList #uncomment for debugging
            PlantID = ElementList[1]
            Retained = float(ElementList[5])/float(ElementList[2])
            NoRADTag = float(ElementList[3])/float(ElementList[2])
            Retained = int(Retained * 100)
            NoRADTag = int(NoRADTag * 100)
            Retained = str(Retained)
            NoRADTag = str(NoRADTag)
            OutputString = "%s\t %s\t %s" % \
            (PlantID, Retained, NoRADTag)
            print OutputString+"\n"
        LineNumber = LineNumber + 1
InFile.close()

#if Line.split() == "":
#   break
#python assumed everything is a string