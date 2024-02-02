# list approach

library(dplyr)
library(tibble)
library(ggplot2)
library(vegan)

asv_tab_tot <- read.csv("data/ASV_table_div_total_final_single.csv", row.names = 1) %>% t()
asv_tab_bulk <- read.csv("data/ASV_table_div_bulk_final_single.csv", row.names = 1) %>% t()

mapping <- read.csv("data/mapping_file.csv")

# 1. make boxplot using total samples only
# create binary table
data_df <- as.data.frame((asv_tab_tot)) %>% rownames_to_column("ASV")
data_df[-1] <- sapply(data_df[-1], function(x) { as.numeric(x > 0) })
binary_df <- data_df %>% column_to_rownames("ASV")
sams <- colnames(binary_df)
num_samples <- length(sams)

# Create a list of species for each column
species_lists <- lapply(binary_df, function(col) rownames(binary_df)[col == 1])
# combine all 
combined_species_list <- unique(unlist(species_lists))

# get values from combinations n=4 until n=15 as there are more then 1000 possibilities, but make only 1000 iterations
for (j in 4:15) {
  num_iter <- 1000
  combinations_matrix <- combn(1:num_samples, j)
  size_combinations_matrix <- dim(combinations_matrix)[2]
  res_comb <- matrix(nrow = num_iter, ncol=1)
  for (i in 1:num_iter) {
    # randomly select one of all thousands of combinations  of the combinations matrix
    sams_to_comb <- combinations_matrix[,sample(size_combinations_matrix, 1, replace=TRUE)]
    species_list_spec <- unique(unlist(species_lists[sams[sams_to_comb]]))
    res_comb[i] <- length(species_list_spec)
  write.csv(res_comb, paste0("res_comb", j, ".csv"))
  }
}

# get values from combinations 1,2,3,16,17,18,19 separately (as the have less combinations then 1000 iterations)
nums_smol <- c( 1,2,3,16,17,18,19)
for (j in nums_smol) {
  combinations_matrix <- combn(1:num_samples, j)
  size_combinations_matrix <- dim(combinations_matrix)[2]
  num_iter <- size_combinations_matrix
  res_comb <- matrix(nrow = num_iter, ncol=1)
  for (i in 1:num_iter) {
    sams_to_comb <- combinations_matrix[,i]
    species_list_spec <- unique(unlist(species_lists[sams[sams_to_comb]]))
    res_comb[i] <- length(species_list_spec)
    write.csv(res_comb, paste0("res_comb", j, ".csv"))
  }
}


# read all result tables
data_list <- list()
for (i in 1:19) {
  file_name <- paste0("res_comb", i, ".csv")
  data <- read.csv(file_name)
  data_list[[i]] <- data
}

# number of combinations
row_counts <- sapply(data_list, nrow)

# combine all data frames into a single long-format data frame and add leading zeros
combined_data_long <- bind_rows(data_list, .id = "comb")
combined_data_long <- rbind(data.frame(comb = "0", X = 0, V1 = 0), combined_data_long)
combined_data_long$comb <- ifelse(nchar(combined_data_long$comb) == 1,
                                  paste0("0", combined_data_long$comb),
                                  combined_data_long$comb)
# boxplot
ggplot(combined_data_long, aes(x = comb, y = V1)) +
  geom_boxplot(alpha = 0.5) +
  labs(title = "Distribution of Total ASVs for Different Combination Sizes",
       x = "Combination Size",
       y = "Total Number of ASVs") +
  theme_minimal() +
  theme(legend.position = "none") 

# 2. fit a linear model (linear, mean values)
# Calculate min and max values for each Combination
min_max_values <- combined_data_long %>%
  group_by(comb) %>%
  summarize(min_value = min(V1),
            max_value = max(V1))

# Calculate linear models for median, min, and max
linear_model_median <-  lm(V1 ~ comb, data = combined_data_long)
linear_model_min <- lm(min_value ~ comb, data = min_max_values)
linear_model_max <- lm(max_value ~ comb, data = min_max_values)

# Create a ggplot with a linear model
plot1 <- ggplot(combined_data_long, aes(x = comb, y = V1)) +
  geom_boxplot(alpha = 0.5) +
  labs(title = "Distribution of Total ASVs for Different Combination Sizes",
       x = "Combination Size",
       y = "Total Number of ASVs") +
  geom_abline(intercept = coef(linear_model_median)[1], slope = coef(linear_model)[2], color = "red") +
  theme_minimal()+
  coord_cartesian(ylim = c(0, max(combined_data_long$V1) + 400)) 
plot1
ggsave("plot1.pdf", plot1, height=5,width=6)

# estimate how many samples are needed 
asv_tab_bulk_clean <- asv_tab_bulk[which(rowSums(asv_tab_bulk)>0),]
mean_spec_test <- mean(specnumber(t(asv_tab_bulk_clean)))
target_asvs <- mean_spec_test
estimated_samples_needed <- (target_asvs - coef(linear_model)[1]) / coef(linear_model)[2]
estimated_samples_needed
# one bulk sample equals 6 total samples
# total set of diversity:
target_asvs <- dim(asv_tab_bulk_clean)[1]
estimated_samples_needed <- (target_asvs - coef(linear_model)[1]) / coef(linear_model)[2]
estimated_samples_needed
# total diversity = 90 total samples to complete diversity of bulk


# calculate a saturation curve model --> is still mostly linear
mean_data <- combined_data_long %>% select(-X) %>%
  group_by(comb) %>%
  summarise(mean_Y = mean(V1)) %>%
  mutate(X=0:19) %>% select(-comb)

# fit the Michaelis-Menten model
fit <- nls(mean_Y ~ Vmax * X / (Km + X), data = mean_data, start = list(Vmax = max(mean_data$mean_Y), Km = median(mean_data$X)))

# create a sequence of X values for prediction
x_seq <- seq(min(mean_data$X), max(mean_data$X)+2, length.out = 100)

# predict Y values based on the fitted model
y_pred <- predict(fit, newdata = data.frame(X = x_seq))

mm_line_data <- data.frame(X = x_seq, mean_Y = y_pred)

combined_plot <- plot1 +
  geom_line(data = mm_line_data, aes(x = X, y = mean_Y), col = "blue", size = 0.5) +
  labs(title = "Distribution of Total ASVs for Different Combination Sizes with \nLinear Model (red) and Michaelis-Menten Model (blue)",
       x = "Combination Size",
       y = "Total Number of ASVs", color="s")
combined_plot
ggsave("plot2.pdf", combined_plot, height=5,width=6)

# write a function to estimate the number of samples based on the Michaelis-Menten model
target_asvs <- 1500
estimate_samples <- function(target_asvs, model) {
  Vmax <- coef(model)["Vmax"]
  Km <- coef(model)["Km"]
  # Use the rearranged Michaelis-Menten equation
  samples <- (Km * target_asvs) / (Vmax - target_asvs)
  return(samples)
}

# estimate the number of samples needed 
estimated_samples <- estimate_samples(target_asvs, fit)
estimated_samples
