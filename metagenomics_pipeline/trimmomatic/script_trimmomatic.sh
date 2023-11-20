# input a list of files you want to process
# also requires trimmomatic-0.39.jar file
# first, a directory is build based on the sample name
# parameters set: PE -phred33 HEADCROP:10 SLIDINGWINDOW:4:20 MINLEN:100


for i in `cat samples.txt`
do
  echo ${i}
  SAMPLE=$(echo ${i})
  mkdir ${SAMPLE}
  sbatch -N 1 --tasks=24 --mem=50000 --time=02:00:00 --wrap="java -jar /work/vdully/MIMeS/MG_1921/trimmomatic-0.39.jar PE -threads 24 -trimlog ${SAMPLE}/trimlog_${SAMPLE}.txt /work/vdully/MIMeS/MG_1921/5462_MG/runs_combined/${SAMPLE}_R1.fastq.gz /work/vdully/MIMeS/MG_1921/5462_MG/runs_combined/${SAMPLE}_R2.fastq.gz ${SAMPLE}/R1_paired_${SAMPLE}.fastq ${SAMPLE}/R1_unpaired_${SAMPLE}.fastq ${SAMPLE}/R2_paired_${SAMPLE}.fastq ${SAMPLE}/R2_unpaired_${SAMPLE}.fastq -phred33 HEADCROP:10 SLIDINGWINDOW:4:20 MINLEN:100"
done
