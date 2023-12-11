#ab merge for chimcheck
library(plyr)
library(dada2)
library(dplyr)
setwd("/scratch/vdully/WWTP_okt2020/dada2/COMBINE_datasets/")
path.merg<-file.path("/scratch/vdully/WWTP_okt2020/dada2/COMBINE_datasets/mergers")
path <- path.merg

sams1 <- readRDS("sams_okt2020.rds")
sams2 <- readRDS("sams_p1.rds")
sams3 <- readRDS("sams_p2.rds")


sams <- c(sams1, sams2, sams3)

mergers<-llply(sams,function(x) {readRDS(file.path(path.merg, paste(x,"merger.rds",sep="_")))})

#mergers to vsearch table
names(mergers)<-paste(names(mergers))
seqtab <- makeSequenceTable(mergers)
#
mat_n<-cbind.data.frame(asv=paste0("ASV_",sprintf(paste0("%0",nchar(ncol(seqtab)),"d"),1:ncol(seqtab))),t(seqtab))
write.table(mat_n,file.path(path,"test.tsv"),sep="\t",col.names=T,row.names=F,quote=F)
#
saveRDS(seqtab, "seqtab_for_chimcheck.rds")
write(paste(paste0(">ASV_",1:ncol(seqtab),";size=",unname(colSums(seqtab)),
                   ";"),colnames(seqtab),sep="\n"),file="seqtab_for_chimcheck.fasta",ncolumns=1)


####
####
####
#### CHIMCHECK using vsearch script
####
####


# make seqtab with ASVs which have not been flagged as chimers by vsearch script 
library(Biostrings)
library(dplyr)
vsearch_seqs <-  readDNAStringSet("/scratch/vdully/WWTP_okt2020/dada2/COMBINE_datasets/seqtab_all_nonchim.fasta")
sequence1 = paste(vsearch_seqs) %>% as.data.frame()
colnames(sequence1) <- "sequence"
list <- sequence1$sequence
seqtab2 <- seqtab[,colnames(seqtab) %in% list]

sum(seqtab)
sum(seqtab2)

saveRDS(seqtab2, "seqtab_nochim.rds")
mat<-cbind.data.frame(asv=paste0("ASV_",sprintf(paste0("%0",nchar(ncol(seqtab2)),"d"),1:ncol(seqtab2))),t(seqtab2))

write(paste(paste0(">",mat$asv),rownames(mat),sep="\n"),file=file.path(path,"Seqs_nochim.fasta"),ncolumns=1)
rownames(mat) <- NULL
write.table(mat,file.path(path,"ASVTable_nochim.tsv"),sep="\t",col.names=T,row.names=F,quote=F)


getN <- function(x) sum(getUniques(x))
getS <- function(x) length(which(getUniques(x)==1))

ov <- cbind(sapply(mergers,getN),rowSums(seqtab>0), rowSums(seqtab), rowSums(seqtab2>0), rowSums(seqtab2))
colnames(ov) <- c("merged", "ASVs_preCC", "reads_preCC", "ASVs_postCC", "reads_postCC")
write.csv(ov,"SeqOv.csv")
