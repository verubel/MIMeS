#! /bin/bash

module load cutadapt/latest vsearch/latest

group=$1
echo "Removing primers from reads of group $group"
echo ""

cutprim () {
	FWD_LIB=$1
	RVS_LIB=$2
	FWD=CCTACGGGNGGCWGCAG
	RVS=GACTACHVGGGTATCTAATCC
	FWD_RC=$(echo ">fwd#$FWD" | tr "#" "\n" | vsearch --quiet --fastx_revcomp - --fastaout - | grep -v ">")
	RVS_RC=$(echo ">rvs#$RVS" | tr "#" "\n" | vsearch --quiet --fastx_revcomp - --fastaout - | grep -v ">")
	echo "################"
	echo "# Sample ${FWD_LIB%%.*} #"
	echo "################"
	echo "## Cut in Forward primer direction ##"
	cutadapt -g ^$FWD -G ^$RVS -e 0.2 --discard-untrimmed -o cut_primers/${FWD_LIB/\.fastq/\.cut\.fastq} -p cut_primers/${RVS_LIB/\.fastq/\.cut\.fastq} demultiplex/$FWD_LIB demultiplex/$RVS_LIB
	# No sequences orientated in reverse primer direction in R1 and conversely for R2
}
export -f cutprim

# parallel execution
awk -v L=$group '$5==L{print $3,$4}' overview_demultiplexed_libraries.tsv | parallel -j $SLURM_CPUS_PER_TASK -k --colsep " " cutprim {1} {2}

