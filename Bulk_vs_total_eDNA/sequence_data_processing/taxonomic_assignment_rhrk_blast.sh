#!/bin/sh
#SBATCH -t 96:00:00
#SBATCH --mem=32000
#SBATCH -n 8


module load blast/latest

blastn -query seqs_filtered.fasta -db /rhrk/ncbi/GenBank/245.0/database.fna -out taxonomy.txt -num_threads 16 -outfmt '6 qseqid pident stitle' -max_target_seqs 1 -perc_identity 80

exit 0
