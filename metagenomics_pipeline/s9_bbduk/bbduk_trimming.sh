for i in `cat /work/RPTU-MIMeS/pipeline_pilot_DNA/first_steps/samples.txt`
do
  SAMPLE=$(echo ${i})
  mkdir ${SAMPLE}
  module load bioconda/latest
  sbatch -N 1 --account=RPTU-MIMeS --tasks=24 --mem=100000 --time=06:00:00 --wrap="bbduk.sh in1=/work/RPTU-MIMeS/pipeline_pilot_DNA/first_steps/raw_test_data/${SAMPLE}_R1.fastq.gz \
  in2=/work/RPTU-MIMeS/pipeline_pilot_DNA/first_steps/raw_test_data/${SAMPLE}_R2.fastq.gz out1=${SAMPLE}/${SAMPLE}_cleaned_R1.fastq.gz out2=${SAMPLE}/${SAMPLE}_cleaned_R2.fastq.gz \
  threads=24 qtrim=rl trimq=30 minlength=100"
done
