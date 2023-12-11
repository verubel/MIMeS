#!/bin/bash

while read nb group
do
	sbatch -J cut_primer_$group -o logfiles/%x.%j.out -e logfiles/%x.%j.err -t 01:30:00 -N 1 -n 1 --mem=$((3*nb))G -c $nb script_cut_primers_bac.sh $group
done < <(sed '1d' overview_demultiplexed_libraries.tsv | cut -f 5 | sort | uniq -c )
