#!/bin/sh
#SBATCH -t 01:00:00
#SBATCH --mem=32000



module load vsearch/latest

vsearch --uchime_denovo seqtab_for_chimcheck.fasta \
--sizein \
--sizeout \
--fasta_width 0 \
--minh 0.5 \
--mindiv 2 \
--chimeras seqtab_for_chimcheck_chims.fasta \
--borderline seqtab_for_chimcheck_borderline.fasta \
--nonchimeras seqtab_for_chimcheck_nonchim.fasta 

cat seqtab_for_chimcheck_nonchim.fasta seqtab_for_chimcheck_borderline.fasta > seqtab_all_nonchim.fasta

exit 0
