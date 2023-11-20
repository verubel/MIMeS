### nonpareil lm estimations in R studio
library(Nonpareil)

### plot nonpareil curves ####
npo_files <- list.files(path = "/npo/", pattern = ".npo")
npo_cols <- rainbow(length(npo_files))
nps <- Nonpareil.set(
  file.path(path = "/npo/", npo_files), 
  col = npo_cols,
  labels = gsub("_nonpareil.npo", "", basename(npo_files), fixed = T),
  plot.opts = list(plot.observed = F)
)
nonpareil_summary_df <- data.frame(
  current_coverage = summary(nps)[, "C"],
  current_seq_effort_Gbp = sapply(nps@np.curves, function(x) x@LR),
  near_complete_seq_effort_Gpb = summary(nps)[,"LRstar"]/1e9,
  coverage_10Gbp = sapply(nps$np.curves, predict, 10e9)
)

### add linear model predictions for 90%, 95% and 100%
model <- lm((current_seq_effort_Gbp) ~ current_coverage, data=nonpareil_summary_df)
f3<-data.frame(current_coverage=c(0.9,0.95, 1))
pred<-predict(model,f3)
pred
newdf <- nonpareil_summary_df[,1:2]
newdf[7:9,1] <- c(0.9,0.95, 1)
newdf[7:9,2] <- pred
a_tmp <- format(newdf[7,2], scientific=F)

### draw plot and add lm
plot(newdf$current_coverage, newdf$current_seq_effort_Gbp, 
     xlab="Coverage [%]", ylab="Sequencing effort [Gbp]",
     main = paste0("BEL\n90% = ",a_tmp, "Gbp\nreq: 16-fold!"))
abline(model)

### calculate fold-change
newdf[7,2]/newdf[1,2]
