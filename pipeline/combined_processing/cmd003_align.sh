#!/bin/bash -l

#SBATCH --ntasks=10
#SBATCH --mem-per-cpu=20G
#SBATCH --time=168:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/combined_CCXXI/scripts/cmd003_align.stdout
#SBATCH --job-name='align'
#SBATCH -p koeniglab
#SBATCH --array=1-468

module load minimap2 samtools
INDEX=/rhome/jmarz001/shared/GENOMES/BARLEY/2019_Release_Morex_vers2/Barley_Morex_V2_pseudomolecules.fasta

PROJECT_DIR=/rhome/jmarz001/bigdata/CCXXIRAD/combined_CCXXI
# Define location variables
TRIMMED=$PROJECT_DIR/data/trimmed
BAMS=${PROJECT_DIR}/data/bams
mkdir $BAMS

SEQS=${PROJECT_DIR}/args/trimmed_files
cd $TRIMMED ; ls *trimmed.fq.gz >> $SEQS

# Define files to run over
FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQS | tail -n 1)
# 267_188_trimmed.fq.gz -> 267_188_trimmed -> 267_188
sample_name=$(basename "$FILE" | cut -d. -f1 | cut -d_ -f1-2)

run_name=$(head -n ${SLURM_ARRAY_TASK_ID} $SEQS | tail -n 1 | cut -f3 | cut -d_ -f3)



##RGPU (String)	Read Group platform unit (eg. run barcode) Required.
#define the ID# list based on which lane they're from
BAR=/rhome/jmarz001/bigdata/CCXXIRAD/barcode/BARCODE_FILES/
#file with info containing file name/ID in one column and plate on another (from group_test.sh script which copied lines from Hv## barcode files into new 'plates' file with addition of plate info column based on which barcode file they came from)
PLATES=$BAR/plates
RGPU=$(grep "$SHORT" $PLATES | cut -f4)
#cut so only the plate info is used

##RGLB (String)	Read Group library Required.
#RGLB=<"24=F25=late, 267=F11=early">
#yields numeric basename/generation, ie. (267_188 -> 267)
X=$(basename "$SHORT" | cut -d_ -f1)
Y=24

if [ "$X" == "$Y" ]; then
  RGLB=F25
else
  RGLB=F11
fi

# BWA mapping
bwa mem -R "@RG\tID:$SLURM_ARRAY_TASK_ID\tSM:$SHORT\tPU:$RGPU\tLB:$RGLB" -t 10 $INDEX $WORKINGDIR/"$NAME".fq > $RESULTSDIR/"$SHORT".sam

# Minimap2 mapping
minimap2 -t 10 -ax sr /rhome/jmarz001/shared/GENOMES/BARLEY/2019_Release_Morex_vers2/Barley.mmi \

-R "@RG\tID:${sample_barcode}_${sample_name}_${SLURM_ARRAY_TASK_ID}\tPL:illumina\tSM:${sample_name}\tLB:${sample_name}" \
$TRIMMED/${sample_name}_${run_name}.fq.gz \
> $BAMS/${sample_name}_${run_name}.sam

# Get mapping stats
mkdir $BAMS/mappingstats/
samtools flagstat $BAMS/${sample_name}_${run_name}.sam > $BAMS/mappingstats/${sample_name}_mapstats.txt

# Convert sam to sorted bam and index bams with csi
samtools view -b -T $INDEX $BAMS/${sample_name}_${run_name}.sam | samtools sort -@ 20 > $BAMS/${sample_name}_${run_name}.bam
samtools index -c $BAMS/${sample_name}_${run_name}.bam
