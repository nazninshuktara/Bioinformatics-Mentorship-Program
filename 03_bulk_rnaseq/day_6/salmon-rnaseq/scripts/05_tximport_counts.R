# RNA-seq Analysis in R (Part 1): tximport -> Gene-level Count Table


# 1. Install and load packages
pak::pkg_install(c("tidyverse", "tximport", "DESeq2", "EnsDb.Hsapiens.v86"))

library(tidyverse)
library(tximport)
library(DESeq2)
library(EnsDb.Hsapiens.v86)


# 2. Locate the Salmon quant files
# Each sample has its own folder under outputs/salmon_out/, containing quant.sf
samples <- list.dirs("outputs/salmon_out", recursive = FALSE, full.names = FALSE)
samples

# Build the full path to each sample's quant.sf and name it by sample
quant_files <- file.path("outputs/salmon_out", samples, "quant.sf")
names(quant_files) <- samples
print(quant_files)

# Safety check: every file must exist (all should print TRUE)
file.exists(quant_files) 


# 3. Set up metadata frame
# Create the data frame with row names AND a explicit sample column
col_data <- data.frame(
  row.names = samples,
  sample    = samples,
  condition = c("control", "control", "control", "covid19", "covid19", "control", "covid19", "covid19")
)

# condition as factor 
col_data$condition <- factor(col_data$condition)

# Export metadata for later use 
write.csv(col_data, "outputs/metadata/GSE245922_metadata.csv", row.names = FALSE)


# 4. Build the transcript -> gene mapping (tx2gene)
# What are the columns in the database?
EnsDb.Hsapiens.v86
columns(EnsDb.Hsapiens.v86)
keys(EnsDb.Hsapiens.v86)

# Salmon counts transcripts; we want genes. 
# This table tells tximport which transcript belongs to which gene symbol.
# Get the mapping from transcript IDs to gene symbols 
tx2gene <- AnnotationDbi::select(
  EnsDb.Hsapiens.v86,
  keys    = keys(EnsDb.Hsapiens.v86),
  columns = c("TXID", "SYMBOL")
)

# Keep only transcript ID + symbol (drop the gene ID column)
tx2gene <- dplyr::select(tx2gene, TXID, SYMBOL)
head(tx2gene)

# 5. Import and summarize to gene level
txi <- tximport(
  files               = quant_files,
  type                = "salmon",
  tx2gene             = tx2gene,
  ignoreTxVersion     = TRUE,
  countsFromAbundance = "lengthScaledTPM")

class(txi)          # "list"
head(txi$counts)    # raw gene-level counts
head(txi$abundance) # gene-level TPM

# 6. Save the count table (the reusable product of this step)
# Raw counts (row.names = gene symbols) -> keep the gene column when writing CSV
raw_counts <- txi$counts
write.csv(raw_counts, "outputs/tables/GSE245922_raw_counts.csv", row.names = TRUE)
write_rds(raw_counts, "outputs/tables/GSE245922_raw_counts.rds")

# TPM (normalized abundance)
tpm_counts <- txi$abundance
write.csv(tpm_counts, "outputs/tables/GSE245922_tpm_counts.csv", row.names = TRUE)
write_rds(tpm_counts, "outputs/tables/GSE245922_tpm_counts.rds")

#Save the whole tximport object. The DESeq2 step needs it (not just the CSV),
# because DESeqDataSetFromTximport() uses the transcript-length information.
write_rds(txi, "outputs/tables/GSE245922_txi.rds")

# Round to whole numbers just for viewing / plotting
data <- as.data.frame(round(raw_counts))

# 7. Distribution of counts for a single sample
# Using SRR26436341 (control sample). RNA-seq counts are NOT normal:
# many low-count genes, a long right tail, and a huge dynamic range.
p_hist <- ggplot(data) +
  geom_histogram(aes(x = SRR26436341), bins = 200) +
  xlab("Raw expression counts") +
  ylab("Number of genes")

p_hist

ggsave("outputs/figures/GSE245922_count_distribution_SRR26436341.png",
       p_hist, width = 7, height = 5, dpi = 300)

# 8. Mean vs variance across the control replicates
# The four control replicates in our design
control <- c("SRR26436341", "SRR26436342", "SRR26436344", "SRR26436347")

# For each gene, mean and variance across those four samples
mean_counts     <- apply(data[, control], 1, mean)
variance_counts <- apply(data[, control], 1, var)
df <- data.frame(mean_counts, variance_counts)

# Red line = where mean would equal variance (the Poisson assumption).
# Points sitting ABOVE the line show variance > mean (overdispersion),
# which is why we use the Negative Binomial (DESeq2), not Poisson.
p_mv <- ggplot(df) +
  geom_point(aes(x = mean_counts, y = variance_counts), alpha = 0.3) +
  scale_x_log10() +
  scale_y_log10() +
  geom_abline(intercept = 0, slope = 1, color = "red") +
  xlab("Mean count (control replicates)") +
  ylab("Variance (control replicates)")

ggsave("outputs/figures/GSE245922_mean_vs_variance_control.png",
       p_mv, width = 7, height = 5, dpi = 300)


# This must return TRUE before you proceed
# DESeq2 errors out if names/order don't match - verify explicitly.
all(colnames(txi$counts) == rownames(col_data))
stopifnot(all(colnames(txi$counts) == rownames(col_data)))
