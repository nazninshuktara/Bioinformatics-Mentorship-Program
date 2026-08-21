# RNA-seq Analysis in R (Part 2): Gene-level Count Table -> count normalization and pca analysis


# 1. Install and load packages
pak::pkg_install(c("tidyverse", "tximport", "DESeq2", "EnsDb.Hsapiens.v86", "RColorBrewer", "pheatmap"))

library(tidyverse)
library(tximport)
library(DESeq2)
library(EnsDb.Hsapiens.v86)
library(RColorBrewer)
library(pheatmap)

# 2. Load the tximport object and metadata
txi <- read_rds("outputs/tables/GSE245922_txi.rds")

col_data <- read.csv("outputs/metadata/GSE245922_metadata.csv", row.names = "sample")
col_data$condition <- factor(col_data$condition)

# Sanity check before building dds
stopifnot(all(colnames(txi$counts) == rownames(col_data)))

# 3. Count Normalization with DESeq2 (median of ratios)
dds <- DESeqDataSetFromTximport(
  txi     = txi,
  colData = col_data,
  design  = ~ condition)

head(counts(dds))   # raw count slot

# 4. Estimate size factors (median of ratios) and get normalized counts
dds <- estimateSizeFactors(dds)
dds

# Size factors should sit around 1; large swings hint at outlier samples.
sizeFactors(dds)
normalized_counts <- counts(dds, normalized = TRUE)

# 5. Save outputs for downstream visualization / QC
write.csv(normalized_counts, "outputs/tables/GSE245922_normalized_counts.csv", row.names = TRUE)
write_rds(normalized_counts, "outputs/tables/GSE245922_normalized_counts.rds")

# Save the dds object too, so later steps can reuse it.
write_rds(dds, "outputs/tables/GSE245922_dds.rds")

# 6. Regularized-log transform (for visualization only)
# blind = TRUE: transform without using the sample groups, so QC stays unbiased.
# (We have 8 samples, so rlog is fine; for >~20 samples prefer vst())
rlog_dds <- rlog(dds, blind = TRUE)


# 7. Principal Component Analysis (PCA)
# Colour by our condition of interest (treatment). Replicates should group.
p_pca_cond <- plotPCA(rlog_dds, intgroup = "condition")
p_pca_cond

ggsave("outputs/figures/GSE245922_pca_condition.png", p_pca_cond,
       width = 7, height = 5, dpi = 300)

# Save the PCA coordinates too
pca_data <- plotPCA(rlog_dds, intgroup = "condition", returnData = TRUE)
write.csv(pca_data, "outputs/tables/GSE245922_pca_data.csv", row.names = FALSE)

# 8. Hierarchical clustering heatmap (sample-sample correlation)
# Extract the rlog matrix, then correlate every pair of samples.
rld_mat <- assay(rlog_dds)
rld_cor <- cor(rld_mat)          # pairwise correlations (expect > 0.99)

# Metadata used to draw the coloured annotation bars on the heatmap
meta <- as.data.frame(colData(dds))

heat_colors <- brewer.pal(6, "Blues")

pheatmap(
  rld_cor,
  annotation    = meta,
  color         = heat_colors,
  border_color  = NA,
  fontsize      = 10,
  fontsize_row  = 10,
  filename      = "outputs/figures/GSE245922_sample_correlation_heatmap.png")
