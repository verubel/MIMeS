This folder "metagenomics_pipeline" will contain all steps conducted in the MIMeS project regarding the metagenomic analyses. 
The scripts of the individual steps are seperated in distinct directories:

# concatenate runs

Samples from 2019 and 2021 are already available with a requested sequencing depth of approx. 30 Mio reads per metagenome. 
As some sequencing runs did not yield 30 Mio reads, additional sequencing runs were conducted. 
The first task was to combine the avialable sequences by concatenating the files containing the reads. 
Concatention was conducted using a mapping file containing the raw sequencing files of each run and information about the corresponding sample. 

# Trimmomatic

After concatenation of files, the files were trimmed by quality and length using a standard MPI inhouse script based on trimmomatic (https://github.com/usadellab/Trimmomatic). 
Trimmomatic was contucted in paired-end mode as the sequeing was also conducted paired end (R1&R2 are available)

# SortMeRNA

SortMeRNA is a popular tool to detect and remove rRNA.
Additionally, the goal of the SortMeRNA (https://github.com/sortmerna/sortmerna) ananlysis was to identify reads which belong to bacteria or eukaryotes using the 16S and 18S SortmeRNA databases. 

# Non-pareil analysis

Nonpareil analysis (https://github.com/lmrodriguezr/nonpareil) can be used to estimate the required sequencing depth of a metagenomic data set. 
In our case, samples from 2019 and 2021 were used to estimate the diversity coverage to infer required sequencing depth for further experiments.

# Kraken2

Kraken2 (https://github.com/DerrickWood/kraken2) was conducted to taxonomically assign the short reads to be able to split the data set into bacterial and eukaryotic reads.
Kraken2 was conducted to get the Kraken2 output file and the Kraken2 report file. 
The Kraken2 output file and the Kraken2 report file are then passed to the KrakenTools Application "extract_kraken_reads.py" (https://github.com/jenniferlu717/KrakenTools) to extract reads which have been specfically assigned to the target organisms. 
The script was used tree times to extract bacteria, eukaryotes and archael reads. 
Aferwards, the files must be reformatted to the correct .fasta format as the KrakenTools Application inserts non-compatible linebreaks. 

# MEGAHIT

MEGAHIT (https://github.com/voutcn/megahit) was used to co-assable multiple (n=6) similar samples to achive a good metagenome coverage.
As an output, contigs are generated. 
Also, assemblies of single files can be conducted. 
MEGAHIT can be run in interleaved mode (R1 and R2 reads are combined in a single file), or PE (paired-end mode) if R1 and R2 reads are stored in separate files. 

# SPAdes / metaSPAdes / rnaSPAdes

SPAdes (https://github.com/ablab/spades/) is a assembly tool which has been adjusted to different types of input data as metaSPAdes for metagenomic assemblies or rnaSPAdes for RNA assembly. 

# phyloFlash 

phyloFlash (http://hrgv.github.io/phyloFlash/) was used on the raw data to rapidly assemble reads and map them against the SILVA 138.1. database.

# bowtie2

bowtie2 (https://bowtie-bio.sourceforge.net/bowtie2/manual.shtml) is used for remapping of the MEGAHIT-generated (Step 6) contigs to the sequence reads (paired-end). As an outbut, alignment files in SAM/BAM format are generated. 

# quast

quast (https://github.com/ablab/quast) is a standalone assembly evaluation tool calculating statistics on the conducted assemblies. 
