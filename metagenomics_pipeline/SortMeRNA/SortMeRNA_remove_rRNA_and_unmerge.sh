# Step3: sortmerna using standard reference databases (default)

for i in `cat /work/RPTU-MIMeS/pipeline_pilot_DNA/first_steps/samples.txt`
do
  echo ${i}
  SAMPLE=$(echo ${i})
  mkdir ${SAMPLE}
  cd ${SAMPLE}
  module load bioconda/latest
  sbatch -N 1 --account=RPTU-MIMeS --tasks=16 --mem=300000 --time=24:00:00 --mail-type=END --wrap="sortmerna --ref /software/bioconda/sortmerna/data/rRNA_databases/rfam-5.8s-database-id98.fasta \
  --ref /software/bioconda/sortmerna/data/rRNA_databases/rfam-5s-database-id98.fasta --ref /software/bioconda/sortmerna/data/rRNA_databases/silva-arc-16s-id95.fasta \
  --ref /software/bioconda/sortmerna/data/rRNA_databases/silva-arc-23s-id98.fasta --ref /software/bioconda/sortmerna/data/rRNA_databases/silva-bac-16s-id90.fasta \
  --ref /software/bioconda/sortmerna/data/rRNA_databases/silva-bac-23s-id98.fasta --ref /software/bioconda/sortmerna/data/rRNA_databases/silva-euk-18s-id95.fasta \
  --ref /software/bioconda/sortmerna/data/rRNA_databases/silva-euk-28s-id98.fasta \
  --reads /work/RPTU-MIMeS/pipeline_pilot_DNA/first_steps/step2_bbduk/${SAMPLE}/${SAMPLE}_cleaned_R1.fastq.gz \
  --reads /work/RPTU-MIMeS/pipeline_pilot_DNA/first_steps/step2_bbduk/${SAMPLE}/${SAMPLE}_cleaned_R2.fastq.gz \
  --fastx --other sortme_notaligned_${SAMPLE} --paired_in -a 16 --workdir /work/RPTU-MIMeS/pipeline_pilot_DNA/first_steps/step3_sortmerna/${SAMPLE}"
  cd ..
done

# Step3b: sortmerna unmerge --> sh script required! --> does not work!
# Check File Integrity: Ensure that the input FASTQ files are not corrupted. You can use the zcat command to check if the files can be uncompressed correctly
# test here: first decompress file, use unmerge script, compress again --> works!

for i in `cat /work/RPTU-MIMeS/pipeline_pilot_DNA/first_steps/samples.txt`
do
  echo ${i}
  SAMPLE=$(echo ${i})
  gunzip -c /work/RPTU-MIMeS/pipeline_pilot_DNA/first_steps/step3_sortmerna/${SAMPLE}/sortme_notaligned_${SAMPLE}.fq.gz > /work/RPTU-MIMeS/pipeline_pilot_DNA/first_steps/step3_sortmerna/${SAMPLE}/sortme_notaligned_${SAMPLE}.fq
  bash ./unmerge-paired-reads.sh /work/RPTU-MIMeS/pipeline_pilot_DNA/first_steps/step3_sortmerna/${SAMPLE}/sortme_notaligned_${SAMPLE}.fq /work/RPTU-MIMeS/pipeline_pilot_DNA/first_steps/step3_sortmerna/${SAMPLE}/out/smr_na_${SAMPLE}_R1.fastq /work/RPTU-MIMeS/pipeline_pilot_DNA/first_steps/step3_sortmerna/${SAMPLE}/out/smr_na_${SAMPLE}_R2.fastq
  gzip /work/RPTU-MIMeS/pipeline_pilot_DNA/first_steps/step3_sortmerna/${SAMPLE}/out/smr_na_${SAMPLE}_R1.fastq
  gzip /work/RPTU-MIMeS/pipeline_pilot_DNA/first_steps/step3_sortmerna/${SAMPLE}/out/smr_na_${SAMPLE}_R2.fastq
done
