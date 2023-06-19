### KRAKEN2

# three step approach
# 1. kraken2
# 2. extract script
# 3. reformat

# 1. kraken2

for i in `cat samples.txt`
do
  echo ${i}
  SAMPLE=$(echo ${i})
  mkdir ${SAMPLE}
  cd ${SAMPLE}
  module load bioconda/latest
  sbatch -N 1 --tasks=8 --mem=60000M --time=2:30:00 --account=RPTU-MIMeS --wrap="kraken2 --db /scratch/RPTU-MIMeS/database/db_k2_standard_08gb --threads 8 --output out_${SAMPLE}.txt --report report_${SAMPLE}.txt /work/RPTU-MIMeS/MG_1921/5462_MG/nonpareil/${SAMPLE}/R1_paired_${SAMPLE}.fasta --memory-mapping --quick"
  cd ..
done


# 2. extract sequences
# in dir nonpareil_kraken do:

for i in `cat samples.txt`
do
  echo ${i}
  SAMPLE=$(echo ${i})
  cd ${SAMPLE}
  mkdir BAC
  cd BAC
  module load bioconda/latest
  sbatch -N 1 --tasks=24 --mem=8192M --time=2:30:00 --account=RPTU-MIMeS --wrap="python /work/RPTU-MIMeS/MG_1921/tests/test_kraken/test_kraken_new/extract_kraken_reads.py --include-children -t 2 -k /work/RPTU-MIMeS/MG_1921/5462_MG/nonpareil_kraken/${SAMPLE}/out_${SAMPLE}.txt -s /work/RPTU-MIMeS/MG_1921/5462_MG/nonpareil/${SAMPLE}/R1_paired_${SAMPLE}.fasta -o ${SAMPLE}_output_extract_bac.fasta --report /work/RPTU-MIMeS/MG_1921/5462_MG/nonpareil_kraken/${SAMPLE}/report_${SAMPLE}.txt"
  cd ..
  cd ..
done


# 3. reformat to get readable fasta files

for i in */*/*extract_arc.fasta 
do
  filename=$(basename "$i")
  dirn=$(dirname "$i")
  new_filename=$(echo "$filename" | awk -F'_' '{print $1"_"$2}')
  echo $new_filename
  awk '/^>/ { if (seq) print seq; print; seq=""; } /^>/ { next } { seq = seq $0 } END { print seq }' ${i} > ${dirn}/kraken_BAC_${new_filename}.fasta
done
