# paired end mode
module load bioconda/latest
for i in `cat /work/RPTU-MIMeS/pipeline_pilot_DNA/first_steps/samples.txt`
do
  echo ${i}
  SAMPLE=$(echo ${i})
  sbatch -N 1 --account=RPTU-MIMeS --tasks=32 --mem=900000 --time=48:00:00 --wrap="megahit -1 /work/RPTU-MIMeS/pipeline_pilot_DNA/first_steps/step3_sortmerna/${SAMPLE}/out/smr_na_${SAMPLE}_R1.fastq.gz -2 /work/RPTU-MIMeS/pipeline_pilot_DNA/first_steps/step3_sortmerna/${SAMPLE}/out/smr_na_${SAMPLE}_R2.fastq.gz -t 32 -o /work/RPTU-MIMeS/pipeline_pilot_DNA/first_steps/step4b_megahit/${SAMPLE}"
done
