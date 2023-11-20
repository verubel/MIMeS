# already implemented: bbmap
# tool for the removal of duplicates
# also able to remove optical duplicates

for i in `cat /work/RPTU-MIMeS/pipeline_pilot_DNA/first_steps/samples.txt`
do
  echo ${i}
  SAMPLE=$(echo ${i})
  mkdir ${SAMPLE}
  module load bioconda/latest
  sbatch -N 1 --account=RPTU-MIMeS --tasks=24 --mem=100000 --time=06:00:00 --wrap="clumpify.sh in=/work/RPTU-MIMeS/pipeline_pilot_DNA/first_steps/step2_bbduk/${SAMPLE}/${SAMPLE}_cleaned_R1.fastq.gz \
  in2=/work/RPTU-MIMeS/pipeline_pilot_DNA/first_steps/step2_bbduk/${SAMPLE}/${SAMPLE}_cleaned_R1.fastq.gz out=${SAMPLE}/${SAMPLE}_dedup_R1.fastq.gz out2=${SAMPLE}/${SAMPLE}_dedup_R2.fastq.gz \
  dedupe optical dist=40"
done
