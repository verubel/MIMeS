#!/bin/sh
#SBATCH -N 1
#SBATCH --account=RPTU-MIMeS
#SBATCH --tasks=32
#SBATCH --mem=900000
#SBATCH --time=48:00:00

# interleaved mode
SAMPLE_LIST="/work/RPTU-MIMeS/concat_rawfiles_SO295/samples.txt"

# Loop through each sample in the list
for SAMPLE in $(cat "$SAMPLE_LIST"); do
  # Load the required modules
  module load bioconda/latest
  # Submit the sbatch job for each sample
  # metaspades
  spades.py --meta --12 /work/RPTU-MIMeS/pipeline_pilot_DNA/first_steps/step3_sortmerna/${SAMPLE}/sortme_notaligned_${SAMPLE}.fq.gz \
  -t 32 -m 900 --phred-offset 33 -o /work/RPTU-MIMeS/pipeline_pilot_DNA/first_steps/step4a_metaspades_INTERLEAVED/${SAMPLE}
done
