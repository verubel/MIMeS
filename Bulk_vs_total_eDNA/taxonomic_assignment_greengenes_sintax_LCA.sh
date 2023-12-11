#!/bin/sh
#SBATCH -t 6:00:00
#SBATCH --mem=32000
#SBATCH -n 8


module load vsearch/latest

vsearch --threads 8 --sintax Seqs_nochim.fasta --db /groups/Ecology/Documents/LCA_databases/gg_16s_13.5.fa --sintax_cutoff 0.51 --tabbedout taxo_out_sh.table

exit 0
