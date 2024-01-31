#!/bin/sh
#SBATCH -N 1
#SBATCH --account=RPTU-MIMeS
#SBATCH --tasks=12
#SBATCH --mem=10000
#SBATCH --time=01:00:00

SAMPLE_LIST="/work/RPTU-MIMeS/concat_rawfiles_SO295/samples.txt"

# Loop through each sample in the list
for SAMPLE in $(cat "$SAMPLE_LIST"); do
  # Create a directory for each sample
  mkdir "${SAMPLE}"
  # Load the required modules
  module load bioconda/latest
  # Submit the sbatch job for each sample
  bbduk.sh in1=/work/RPTU-MIMeS/concat_rawfiles_SO295/${SAMPLE}_R1.fastq.gz \
  in2=/work/RPTU-MIMeS/concat_rawfiles_SO295/${SAMPLE}_R2.fastq.gz out1=${SAMPLE}/${SAMPLE}_cleaned_R1.fastq.gz out2=${SAMPLE}/${SAMPLE}_cleaned_R2.fastq.gz \
  threads=12 qtrim=rl trimq=30 minlength=100
done
