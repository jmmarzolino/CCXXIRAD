#!/usr/bin/env python

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
        
        
###PERCENT RETAINED READS

##FastQC        0.11.7
#>>Basic Statistics      pass
#Measure        Value
#Filename        267_99_trimmed.fq
#File type       Conventional base calls
#Encoding        Sanger / Illumina 1.9
#Total Sequences 3923974
#Sequences flagged as poor quality       0
#Sequence length 36-143
#%GC     46
#>>END_MODULE

#for percentage: 10% increments
#(from 1 to 100%, by 9s)
#1-10, 11-20,21-30, 31-40...
  
  
###QUALITY
#>>Per sequence quality scores   pass
#Quality        Count
#quality number  number of reads with that quality
#25    2
#41    114017

#>>END_MODULE


#fastq_fastqc
#trim/fastqc/#_trimmed
#then after qual=30 cutoff point

#range
#range/20

#  look through line by line, extract retained reads value ()
#bin those retained reads % into defined categories (or mark them between category limits and count +1 to category)
#count number of lines/entries in each category

#set categories

