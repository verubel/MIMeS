# first specify which samples you want to use
# for nonpareil analysis, quality trimmed/ length trimmed files (after trimmomatic) should be used

for i in `cat samples.txt`
do
  echo ${i}
  SAMPLE=$(echo ${i})
  mkdir ${SAMPLE}
  cd ${SAMPLE}
  # convert .fastq to .fastq using awk
  cat /work/RPTU-MIMeS/MG_1921/5707_MG/trimmomatic/${SAMPLE}/R1_paired_${SAMPLE}.fastq | paste - - - - | awk 'BEGIN{FS="\t"}{print ">"substr($1,2)"\n"$2}' > /work/RPTU-MIMeS/MG_1921/5707_MG/nonpareil/${SAMPLE}/R1_paired_${SAMPLE}.fasta
  # load required module to be able to load conda environment
  module load bioconda/latest
  # load conda environment (dependencies can be found here: https://git.io-warnemuende.de/bio_inf/workflow_templates/src/branch/master/metaG_Illumina_PE/envs/nonpareil.yaml)
  source activate myenv
  # construct nonpareil curves
  sbatch -N 1 --tasks=24 --mem=100000 --time=06:00:00 --account=RPTU-MIMeS --wrap="nonpareil -s /work/RPTU-MIMeS/MG_1921/5707_MG/nonpareil/${SAMPLE}/R1_paired_${SAMPLE}.fasta -T kmer -f fasta -b ${SAMPLE}_nonpareil -R 100000 -t 24"
  # deactive conda environment
  conda deactivate
  cd ..
done

# subsequently, constructed files are used for building nonpareil curve plots
# script used can be found here: https://git.io-warnemuende.de/bio_inf/workflow_templates/src/branch/master/metaG_Illumina_PE/scripts/nonpareil_parse.R
