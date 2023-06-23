#!/bin/sh
#SBATCH --mail-type=END

# This script maps paired-end fastq.gz files (forward and reverse) to an assembly contig file. 
# It then reports the abundance for each contig and each read file. Bowtie2 is used for alignments.

# Use: bowtie.sh [forward-read-file] [reverse-read-file] [contig-file] [output-folder] 2>bowtie.log
# to save the results: It generates the .sam, .bam, etc., files in the specified output folder.

module load bioconda/latest

forward_read=$1
reverse_read=$2
contig_file=$3
output_folder=$4

mkdir -p $output_folder

stub=$(basename $forward_read _1.fastq.gz)

bowtie2-build $contig_file $output_folder/contigs

bowtie2 -x $output_folder/contigs -1 $forward_read -2 $reverse_read -S $output_folder/$stub.sam
samtools view -b -S $output_folder/${stub}.sam -o $output_folder/${stub}.bam
samtools sort $output_folder/${stub}.bam -o $output_folder/${stub}_sorted.bam
samtools index $output_folder/${stub}_sorted.bam
samtools idxstats $output_folder/${stub}_sorted.bam > $output_folder/${stub}_contig_abundances.txt
