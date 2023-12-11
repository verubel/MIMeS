## output to table
## combine blast output with ASVs sequence reads
## using leftjoin and cleaning of asv table

library(plyr)
library(dplyr)
library(tibble)

table <- read.csv("ASVTable_nochim.tsv", head=T, sep="\t") %>% rename(ASV=asv)
# richtig formatierten taxonomy assigment output einlesen
tax_ass <- read.table("output_formatted.table", head=T, sep=",")
# Tabellen joinen
both <- left_join(table, tax_ass, by="ASV")

#keep target ASVs only
table(both$kingdom)
# both %>% 
#   group_by(domain) %>%
#   summarise(no_rows = length(domain))
target_asvs <- both %>% filter(kingdom=="Bacteria") %>% droplevels()
asv_tab_taxo <- data.frame(target_asvs, stringsAsFactors = F)
asv_tab_taxo_no_singletons <- asv_tab_taxo[which(rowSums(asv_tab_taxo[,2:13])>1),]
write.csv2(asv_tab_taxo_no_singletons, "ASV_Table_Taxo.csv")
