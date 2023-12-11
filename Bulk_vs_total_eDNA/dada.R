##DADA_ASV-inference - Bacterial V3V4 Marker##
#load libraries
library(dada2)
library(doParallel)
library(plyr)

#set up your number of cpus to be used for functions with multihread option (24 recommended for usage on elwe, 
#if you do in on your own device, choose number of cpus available)
ncpus=24

#set your paths where the already primer trimmed files are and a new folder 
#called "filtered" for the filterAndTrim output and a new folder called "mergers" for your joined R1 and R2 reads
path <- file.path("/scratch/vdully/Biogeo_X/sco_strange/seqs_to_check/dada_singles/test_fhf/")
path.data <- file.path("/scratch/vdully/Biogeo_X/sco_strange/seqs_to_check/dada_singles/test_fhf/cut_primers")
path.filt <- file.path("/scratch/vdully/Biogeo_X/sco_strange/seqs_to_check/dada_singles/test_fhf/filtered")
path.merg<-file.path("/scratch/vdully/Biogeo_X/sco_strange/seqs_to_check/dada_singles/test_fhf/mergers")

#apply pattern of all your files here, e.g. Sample1_RepA-R1.fastq would be the pattern as below. 
#To avoid kuddelmuddel, make sure your samples are following the structure of _ als seperator within the sample description 
#and - as seperator before R1 and R2 information

fnFs <- list.files(path.data, pattern=paste0("_R1.cut.fastq"), full.names = TRUE)
filtFs <- file.path(path.filt, gsub("cut","filt",basename(fnFs)))
fnRs <- list.files(path.data, pattern=paste0("_R2.cut.fastq"), full.names = TRUE)
filtRs <- file.path(path.filt, gsub("cut","filt",basename(fnRs)))

#check if fwd and rvs files are named the same to avoid mismerging in the later pipeline
#all.equal(sapply(strsplit(basename(fnFs), "_R"), `[`, 1),
          sapply(strsplit(basename(fnRs), "_R"), `[`, 1)) # TRUE
#set your sample names in your following object to be able to assign the ASVs to samples
sams <- sapply(strsplit(basename(filtFs), "_R"), `[`, 1)
names(sams)<-sams
names(filtFs)<-sams
names(filtRs)<-sams

# 
# #check quality of reads to set treshhold for trimming fwd and rvs reads
if(length(fnFs)>1) nbs<-1:2 else nbs<-1
# 
pdf(paste0("First5_quality_fwd_1.pdf"),width=7,height=4)
plotQualityProfile(fnFs[1:5])
dev.off()
pdf(paste0("First5_quality_rvs_1.pdf"),width=7,height=4)
plotQualityProfile(fnRs[1:5])
dev.off()



#
# STOP PART 1
#

#filterAndTrim with manual settings in truncation length(truncLen) and maximum allowed errors(maxEE)
#you can also cut your sequences not based on nucleotid length, but set the threshold via quality, 
#therefore just add  e.g. truncQ=30, to cut off the sequences at the first 
#nucleotide having quality lower than 30

track <- filterAndTrim(fwd=fnFs, rev=fnRs, filt=filtFs, filt.rev=filtRs,
                       truncLen=230, maxEE=1,
                       rm.phix=TRUE, multithread = ncpus)

write.csv(track, "track_230_1.csv")

#learn & plot errror rates for each run individually
errF <- learnErrors(filtFs, multithread=ncpus)
errR <- learnErrors(filtRs, multithread=ncpus)

#saveRDS(track, "track.rds")
#saveRDS(errF, "errF.rds")
#saveRDS(errR, "errR.rds")

#errF <- readRDS("errF.rds")
#errR <- readRDS("errR.rds")
#track <- readRDS("track.rds")

#create cluster to accelerate processs of dereplication, denoising and merging
#cl<-makeCluster(ncpus)
#registerDoParallel(cl)

#dereplicate your filtered sequences and infer sequence variants of dereplicates sequences
#(save all objects as RDS to be able to dig deeper -if neccessary- wthout haveing to conduct the whole workflow again)
derepF<-llply(filtFs,derepFastq,.parallel=T,.paropts=list(.packages=c('dada2')))
derepR<-llply(filtRs,derepFastq,.parallel=T,.paropts=list(.packages=c('dada2')))

#saveRDS(derepF, "derepF.rds")
#saveRDS(derepR, "derepR.rds")

# derepF <- readRDS("derepF.rds")
# derepR <- readRDS("derepR.rds")

dadaF<-llply(derepF,dada,errF,.parallel=T,.paropts=list(.packages=c('dada2')))
dadaR<-llply(derepR,dada,errR,.parallel=T,.paropts=list(.packages=c('dada2')))
mergers<-llply(sams,function(i) {
  mergePairs(dadaF[[i]], derepF[[i]], dadaR[[i]], derepR[[i]],minOverlap=20, maxMismatch=2)
},.parallel=T,.paropts=list(.packages=c('dada2'),.export=c('derepF','derepR','dadaF','dadaR')))


#saveRDS(dadaF, "dadaF.rds")
#saveRDS(dadaR, "dadaR.rds")
#dadaR <- readRDS("dadaR.rds")
#stopCluster(cl)

for(i in sams) {
  saveRDS(mergers[[i]], file.path(path.merg, paste(i,"merger.rds",sep="_")))
}

getN <- function(x) sum(getUniques(x))
getS <- function(x) length(which(getUniques(x)==1))

ov1 <- cbind(track,sapply(derepF,getN),sapply(derepF,getS),
            sapply(dadaF,getN),sapply(derepR,getN),sapply(derepR,getS),
            sapply(dadaR,getN), sapply(mergers,getN))
colnames(ov1) <- c("input","filtered","dereplicatedF","singletonsF","denoisedF","dereplicatedR","singletonsR","denoisedR", "merged")
rownames(ov1) <- sams
write.csv(ov1,"SeqOv1.csv")

# create seqtab without chimcheck
# mergers to vsearch table
names(mergers)<-paste(names(mergers))
seqtab <- makeSequenceTable(mergers)
saveRDS(seqtab, "seqtab_for_chimcheck.rds")
write(paste(paste0(">ASV_",1:ncol(seqtab),";size=",unname(colSums(seqtab)),
                   ";"),colnames(seqtab),sep="\n"),file="seqtab_for_chimcheck.fasta",ncolumns=1)

saveRDS(seqtab, "seqtab.rds")
saveRDS(mergers, "mergers.rds")
saveRDS(sams, "sams.rds")
                   
#
# STOP PART 2
# use inhouse chimcheck script -> chimera check using vsearch
# ----> batch ./chimcheck.sh
#

# make seqtab2 with ASVs which have not been flagged as chimeras by vsearch 
library(Biostrings)
library(dplyr)
vsearch_seqs <-  readDNAStringSet("seqtab_all_nonchim.fasta")
sequence1 = paste(vsearch_seqs) %>% as.data.frame()
colnames(sequence1) <- "sequence"
list <- sequence1$sequence
seqtab2 <- seqtab[,colnames(seqtab) %in% list]


sum(seqtab2)/sum(seqtab)

saveRDS(seqtab2, "seqtab_nochim.rds")
mat<-cbind.data.frame(asv=paste0("ASV_",sprintf(paste0("%0",nchar(ncol(seqtab2)),"d"),1:ncol(seqtab2))),t(seqtab2))

write(paste(paste0(">",mat$asv),rownames(mat),sep="\n"),file=file.path(path,"Seqs_nochim.fasta"),ncolumns=1)
rownames(mat) <- NULL
write.table(mat,file.path(path,"ASVTable_nochim.tsv"),sep="\t",col.names=T,row.names=F,quote=F)


getN <- function(x) sum(getUniques(x))
getS <- function(x) length(which(getUniques(x)==1))

ov <- cbind(sapply(mergers,getN),rowSums(seqtab>0), rowSums(seqtab), rowSums(seqtab2>0), rowSums(seqtab2))
colnames(ov) <- c("merged", "ASVs_preCC", "reads_preCC", "ASVs_postCC", "reads_postCC")
write.csv(ov,"SeqOv2.csv")
