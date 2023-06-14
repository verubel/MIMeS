This folder "metagenomics_pipeline" will contain all steps conducted in the MIMeS project regarding the metagenomic analyses. 
The scripts of the individual steps are seperated in distinct directories:

# Step 1 - concatenate runs

Samples from 2019 and 2021 are already available with a requested sequencing depth of approx. 30 Mio reads per metagenome. 
As some sequencing runs did not yield 30 Mio reads, additional sequencing runs were conducted. 
The first task was to combine the avialable sequences by concatenating the files containing the reads. 
Concatention was conducted using a mapping file containing the raw sequencing files of each run and information about the corresponding sample. 

# Step 2 - Trimmomatic

After concatenation of files, the files were trimmed by quality and length using a standard MPI inhouse script based on trimmomatic. 
Trimmomatic was contucted in paired-end mode as the sequeing was also conducted paired end (R1&R2 are available)

# Step 3 - SortMeRNA

The goal of this ananlysis was to identify reads which belong to bacteria or eukaryotes using the 16S and 18S sortmeRNA databases. 

# Step 4 - Non-pareil analysis

Nonpareil analysis can be used to estimate the required sequencing depth of a metagenomic data set. 
In our case, samples from 2019 and 2021 were used to estimate the diversity coverage to infer required sequencing depth for further experiments.

