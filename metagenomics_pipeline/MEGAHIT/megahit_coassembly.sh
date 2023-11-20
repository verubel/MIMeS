#!/bin/bash
#SBATCH -J G1_megahit
#SBATCH -t 168:00:00
#SBATCH -e megahit.err
#SBATCH -n 8
#SBATCH --mail-type=END
#SBATCH --tasks=32
#SBATCH --mem=900000

#load required modules
module load bioconda/latest

# Run MEGAHIT co-assembly
# -m 0.90 allows memomry allocation of 90%
# --presets meta-large sets kmers k list: 27,37,47,57,67,77,87,97,107,117,127 
# example: coassembly of 5 samples, paired end (forward=R1, reverse=R2)

megahit \
  -1 /dir/to/file1_R1.fastq \
  -1 /dir/to/file2_R1.fastq \
  -1 /dir/to/file3_R1.fastq \
  -1 /dir/to/file4_R1.fastq \
  -1 /dir/to/file5_R1.fastq \
  -2 /dir/to/file1_R2.fastq \
  -2 /dir/to/file2_R2.fastq \
  -2 /dir/to/file3_R2.fastq \
  -2 /dir/to/file4_R2.fastq \
  -2 /dir/to/file5_R2.fastq \
  -m 0.9 -t 32 --presets meta-large -o G1_megahit_out
