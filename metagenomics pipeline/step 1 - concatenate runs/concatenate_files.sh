#!/bin/bash

# Path to the table file
# table.txt contains 2 columns:
# The fist column contains the seperate fastq.gz files downloaded from the sequencing facility
# The second column contains the sample name.fastq.gz the single runs shall be concatenated to

table_file="table.txt"

# Concatenate files for each unique output file
while IFS=$'\t' read -r file1 output_file
do
    # Concatenate the files and save the result to the specified output file
    cat "$file1" >> "$output_file"
    
    echo "Concatenated $file1 into $output_file"
done < "$table_file"
