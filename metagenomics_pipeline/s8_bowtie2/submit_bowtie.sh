sbatch -N 1 --account=account_name --tasks-per-node=16 --mem=90000 --time=168:00:00 \
 --wrap="/path/to/bowtie.sh \
 /path/to/file_R1.fastq.gz \
 /path/to/file_R2.fastq.gz \
 /path/to/megahit_contigs.fa \
 /path/to/outdir \
 2>bowtie.log"
