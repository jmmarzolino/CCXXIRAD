#!/bin/bash -l

#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=32G
#SBATCH --time=20:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/rad_test/scripts/index.stdout
#SBATCH -p koeniglab

module load bwa samtools
##Reference Index Files/Dir
#bwa index [-a algorithm:bwtsw (BWT-SW)] [-p prefix] <in.db.fasta>
bwa index -a bwtsw /rhome/jmarz001/bigdata/REF/Hordeum_vulgare.Hv_IBSC_PGSB_v2.dna.toplevel.fa -p /rhome/jmarz001/bigdata/REF/Hordeum_vulgare.Hv_IBSC_PGSB_v2.dna.toplevel

#Index reference sequence in the FASTA format: faidx will index the file and create <ref.fasta>.fai on the disk.
#samtools faidx <ref.fasta>
samtools faidx /rhome/jmarz001/bigdata/REF/Hordeum_vulgare.Hv_IBSC_PGSB_v2.dna.toplevel.fa
