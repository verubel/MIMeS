#!/bin/sh
#SBATCH -N 1
#SBATCH --account=RPTU-MIMeS
#SBATCH --tasks=32
#SBATCH --mem=900000
#SBATCH --time=48:00:00

SAMPLE_LIST="/work/RPTU-MIMeS/concat_rawfiles_SO295/samples.txt"

# Loop through each sample in the list
for SAMPLE in $(cat "$SAMPLE_LIST"); do
  # Load the required modules
  module load bioconda/latest
  # Submit the sbatch job for each sample
  # metaspades
  spades.py --meta -1 /work/RPTU-MIMeS/DNA_processing/clumpify/${SAMPLE}/${SAMPLE}_dedup_R1.fastq.gz \
  -2 /work/RPTU-MIMeS/DNA_processing/clumpify/${SAMPLE}/${SAMPLE}_dedup_R2.fastq.gz \
  -t 32 -m 900 --phred-offset 33 -o /work/RPTU-MIMeS/DNA_processing/metaspades/${SAMPLE}"
done

