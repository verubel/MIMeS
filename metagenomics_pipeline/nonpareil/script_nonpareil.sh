#!/bin/sh
#SBATCH -N 1
#SBATCH --account=RPTU-MIMeS
#SBATCH --tasks=24
#SBATCH --mem=100000
#SBATCH --time=06:00:00

SAMPLE_LIST="/work/RPTU-MIMeS/DNA_processing/subset_samples.txt"

# usage: bash ./script_nonpareil2.sh
# first specify which samples you want to use
# for nonpareil analysis, quality trimmed/ length trimmed files (after trimmomatic) should be used
# subsequently, constructed files are used for building nonpareil curve plots
# script used can be found here: https://git.io-warnemuende.de/bio_inf/workflow_templates/src/branch/master/metaG_Illumina_PE/scripts/nonpareil_parse.R


for SAMPLE in $(cat "$SAMPLE_LIST"); do
  # create sub directories for each sample
  mkdir ${SAMPLE}
  cd ${SAMPLE}
  # convert .fastq to .fastq using awk
  zcat /work/RPTU-MIMeS/DNA_processing/clumpify/${SAMPLE}/${SAMPLE}_dedup_R1.fastq.gz | paste - - - - | awk 'BEGIN{FS="\t"}{print ">"substr($1,2)"\n"$2}' > /work/RPTU-MIMeS/DNA_processing/nonpareil/${SAMPLE}/${SAMPLE}_R1.fasta
  # load required module to be able to load conda environment
  module load bioconda/latest
  # load conda environment (dependencies can be found here: https://git.io-warnemuende.de/bio_inf/workflow_templates/src/branch/master/metaG_Illumina_PE/envs/nonpareil.yaml)
  source activate myenv
  # construct nonpareil curves
  sbatch -N 1 --tasks=24 --mem=100000 --time=06:00:00 --account=RPTU-MIMeS --wrap="nonpareil -s /work/RPTU-MIMeS/DNA_processing/nonpareil/${SAMPLE}/${SAMPLE}_R1.fasta -T kmer -f fasta -b ${SAMPLE}_nonpareil -R 100000 -t 24"
  # deactive conda environment
  conda deactivate
  cd ..
done
