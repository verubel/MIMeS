#!/bin/bash
#SBATCH -J G1_megahit
#SBATCH -t 168:00:00
#SBATCH -e megahit.err
#SBATCH -n 8
#SBATCH --account=RPTU-MIMeS
#SBATCH --mail-type=END
#SBATCH --tasks=32
#SBATCH --mem=900000

#load required modules
module load bioconda/latest

# Run MEGAHIT co-assembly
# -m 0.90 allows memomry allocation of 90%
# --presets meta-large sets kmers k list: 27,37,47,57,67,77,87,97,107,117,127 

megahit \
  -1 /G1_fastq/R1_paired_5462_K.fastq \
  -1 /G1_fastq/R1_paired_5707_H.fastq \
  -1 /G1_fastq/R1_paired_5462_M.fastq \
  -1 /G1_fastq/R1_paired_5707_I.fastq \
  -1 /G1_fastq/R1_paired_5707_F.fastq \
  -1 /G1_fastq/R1_paired_5707_G.fastq \
  -2 /G1_fastq/R2_paired_5462_K.fastq \
  -2 /G1_fastq/R2_paired_5707_H.fastq \
  -2 /G1_fastq/R2_paired_5462_M.fastq \
  -2 /G1_fastq/R2_paired_5707_I.fastq \
  -2 /G1_fastq/R2_paired_5707_F.fastq \
  -2 /G1_fastq/R2_paired_5707_G.fastq \
  -m 0.9 -t 32 --presets meta-large -o G1_megahit_out
