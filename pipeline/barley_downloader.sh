#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1G
#SBATCH --time=1-00:00:00
#SBATCH --output=download.stdout
#SBATCH --job-name='reference_download'
#SBATCH -p intel

wget ftp://ftp.ensemblgenomes.org/pub/plants/release-37/fasta/hordeum_vulgare/dna/Hordeum_vulgare.Hv_IBSC_PGSB_v2.dna.toplevel.fa.gz