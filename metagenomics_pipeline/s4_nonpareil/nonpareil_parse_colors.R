# modification of script nonpareil_parse.sh by Christiane Hassenrück available at https://git.io-warnemuende.de/bio_inf/workflow_templates/src/branch/master/metaG_Illumina_PE/scripts/nonpareil_parse.R
# coloring according to a color mapping table containing sample name and desired color was provided 

#!/usr/bin/env Rscript

library(optparse)

# Check if a package is installed
is.installed <- function(pkg) {
  return(requireNamespace(pkg, quietly = TRUE))
}

# Load required packages
package.list <- c("crayon", "config", "Nonpareil")

# Check if packages are installed
if (!all(sapply(package.list, is.installed))) {
  cat("Not all required packages are available.\n")
  break
}

# Load packages
cat("Loading libraries...")
silent <- suppressMessages(lapply(package.list, library, character.only = TRUE))
rm(silent)
cat(" done\n")

# Read the colors from colors.txt
colors <- readLines("colors_IP.txt")

# Define command line options
option_list <- list(
  make_option(
    c("-d", "--dir"),
    type = "character",
    default = NULL,
    help = "directory with npo files (all such files will be processed)",
    metavar = "character"
  ),
  make_option(
    c("-s", "--summary"),
    type = "character",
    default = NULL,
    help = "tabular summary output",
    metavar = "character"
  ),
  make_option(
    c("-p", "--plot"),
    type = "character",
    default = NULL,
    help = "nonpareil curves output",
    metavar = "character"
  )
)

# Parse command line arguments
opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)

# Check if all parameters are provided
if (is.null(opt$dir) || is.null(opt$summary) || is.null(opt$plot)) {
  print_help(opt_parser)
  stop("All parameters are mandatory.\n", call. = FALSE)
}

# Plot nonpareil curves
npo_files <- list.files(path = opt$dir, pattern = "\\.npo$", full.names = TRUE)
npo_cols <- rep(colors, length.out = length(npo_files))

pdf(opt$plot, width = 7, height = 7)
nps <- Nonpareil::Nonpareil.set(
  npo_files,
  col = npo_cols,
  labels = gsub("_nonpareil.npo$", "", basename(npo_files)),
  plot.opts = list(plot.observed = FALSE)
)
dev.off()

# Summary statistics
nonpareil_summary <- data.frame(
  current_coverage = summary(nps)[, "C"] * 100,
  current_seq_effort_Gbp = sapply(nps@np.curves, function(x) x@LR) / 1e9,
  near_complete_seq_effort_Gpb = summary(nps)[,"LRstar"] / 1e9,
  coverage_10Gbp = sapply(nps$np.curves, predict, 10e9)
)

write.table(
  nonpareil_summary,
  opt$summary,
  quote = FALSE,
  sep = "\t"
)
