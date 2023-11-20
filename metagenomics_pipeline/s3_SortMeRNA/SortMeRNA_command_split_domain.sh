# first specify which samples you want to process

for i in `cat samples.txt`
do
  echo ${i}
  SAMPLE=$(echo ${i})
  mkdir ${SAMPLE}
  cd ${SAMPLE}
  # for each sample, a new dir is consructed contaning 3 dirs per domain
  mkdir bac
  cd bac
  module load bioconda/latest
  sbatch -N 1 --account=RPTU-MIMeS --tasks=16 --mem=8192M --time=01:00:00 --wrap="sortmerna --ref /software/bioconda/sortmerna/data/rRNA_databases/silva-bac-16s-id90.fasta \
  --ref /software/bioconda/sortmerna/data/rRNA_databases/silva-bac-23s-id98.fasta \
  --reads /work/RPTU-MIMeS/MG_1921/5462_MG/trimmomatic/${SAMPLE}/R1_paired_${SAMPLE}.fastq \
  --aligned /work/RPTU-MIMeS/MG_1921/5462_MG/nonpareil_sortmerna/${SAMPLE}/bac/sortme_BAC_${SAMPLE}.fastq \
  --other /work/RPTU-MIMeS/MG_1921/5462_MG/nonpareil_sortmerna/${SAMPLE}/bac/sortme_BAC_notaligned_${SAMPLE}.fastq \
  --fastx -a 16 --workdir /work/RPTU-MIMeS/MG_1921/5462_MG/nonpareil_sortmerna/${SAMPLE}/bac"
  cd ..
  mkdir euk
  cd euk
  sbatch -N 1 --account=RPTU-MIMeS --tasks=16 --mem=8192M --time=01:00:00 --wrap="sortmerna --ref /software/bioconda/sortmerna/data/rRNA_databases/silva-euk-18s-id95.fasta \
  --ref /software/bioconda/sortmerna/data/rRNA_databases/silva-euk-28s-id98.fasta \
  --reads /work/RPTU-MIMeS/MG_1921/5462_MG/trimmomatic/${SAMPLE}/R1_paired_${SAMPLE}.fastq \
  --aligned /work/RPTU-MIMeS/MG_1921/5462_MG/nonpareil_sortmerna/${SAMPLE}/euk/sortme_EUK_${SAMPLE}.fastq \
  --other /work/RPTU-MIMeS/MG_1921/5462_MG/nonpareil_sortmerna/${SAMPLE}/euk/sortme_EUK_notaligned_${SAMPLE}.fastq \
  --fastx -a 16 --workdir /work/RPTU-MIMeS/MG_1921/5462_MG/nonpareil_sortmerna/${SAMPLE}/euk"
  cd ..
  mkdir arc
  cd arc
  sbatch -N 1 --account=RPTU-MIMeS --tasks=16 --mem=8192M --time=01:00:00 --wrap="sortmerna --ref /software/bioconda/sortmerna/data/rRNA_databases/silva-arc-16s-id95.fasta \
  --ref /software/bioconda/sortmerna/data/rRNA_databases/silva-arc-23s-id98.fasta \
  --reads /work/RPTU-MIMeS/MG_1921/5462_MG/trimmomatic/${SAMPLE}/R1_paired_${SAMPLE}.fastq \
  --aligned /work/RPTU-MIMeS/MG_1921/5462_MG/nonpareil_sortmerna/${SAMPLE}/arc/sortme_ARC_${SAMPLE}.fastq \
  --other /work/RPTU-MIMeS/MG_1921/5462_MG/nonpareil_sortmerna/${SAMPLE}/arc/sortme_ARC_notaligned_${SAMPLE}.fastq \
  --fastx -a 16 --workdir /work/RPTU-MIMeS/MG_1921/5462_MG/nonpareil_sortmerna/${SAMPLE}/arc"
  cd ..
  cd ..
done
