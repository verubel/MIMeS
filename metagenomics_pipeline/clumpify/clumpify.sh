#!/bin/sh
#SBATCH -N 1
#SBATCH --account=RPTU-MIMeS
#SBATCH --tasks=24
#SBATCH --mem=90000
#SBATCH --time=01:30:00

SAMPLE_LIST="/work/RPTU-MIMeS/concat_rawfiles_SO295/samples.txt"

# Loop through each sample in the list
for SAMPLE in $(cat "$SAMPLE_LIST"); do
  # Create a directory for each sample
  mkdir "${SAMPLE}"
  # Load the required modules
  module load bioconda/latest
  # Submit the sbatch job for each sample
  clumpify.sh in=/work/RPTU-MIMeS/DNA_processing/bbduk/${SAMPLE}/${SAMPLE}_cleaned_R1.fastq.gz \
  in2=/work/RPTU-MIMeS/DNA_processing/bbduk/${SAMPLE}/${SAMPLE}_cleaned_R2.fastq.gz out=${SAMPLE}/${SAMPLE}_dedup_R1.fastq.gz out2=${SAMPLE}/${SAMPLE}_dedup_R2.fastq.gz \
  dedupe optical dist=40
done

