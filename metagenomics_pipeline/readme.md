This folder "metagenomics_pipeline" will contain all steps conducted in the project. 
The individual steps are seperated in distinct directories. 

# Step 1 - concatenate runs

Samples from 2019 and 2021 are already available. 
The sequeincing depth requested was approx. 30 Mio reads per metagenome. 
As some sequeinging runs were not yielding 30 Mio reads, additional sequencing runs were conducted. 
The first task was to combine the avialable sequences by concatenating the reads. 
This was conducted using a file containing the raw sequencing files of each run and a mapping information about the corrssponding sample. 

# Step 2 - Trimmomatic

After concatenation of files, the files were trimmed by quality and length using a standard MPI inhous script based on trimmomatic. 
Trimmomatic was contucted in paired-end mode as the sequeing was also conducted paired end (R1&R2)

# Step 3 - SortMeRNA

The goal of this ananlysis was to identify reads which belong to bacteria or eukaryotes using 16S and 18S sortmeRNA databases. 

# Step 4 - Non-pareil analysis

Nonpareil analysis can be used to estimate the yielded sequencing depth of a metagenomic data set. 
In our case, samples from 2019 and 2021 were used to estimate the diversity coverage to infer required sequencing depth for further experiments.

