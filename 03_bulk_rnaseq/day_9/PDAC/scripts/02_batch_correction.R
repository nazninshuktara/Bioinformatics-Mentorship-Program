# Script 02: Batch Effect Detection & Diagnosis

# Module: Batch Correction / Quality Control
# Dataset: GSE130688 (PDAC tumor vs. matched normal, 15 patients, 30 samples)
#
# WHAT THIS SCRIPT DOES:
#   Detects, visualizes, and diagnoses batch effects in the RNA-seq data.
#   It does NOT apply ComBat or other correction methods — instead it teaches
#   WHY correction is unnecessary here (batch is confounded with patient, and
#   the paired DESeq2 design already absorbs batch for the within-patient
#   tumor-vs-normal comparison).
#
# WHY THIS MATTERS (biological & statistical context):
#   Batch effects are the #1 source of spurious signal in multi-batch RNA-seq
#   studies [Leek et al., 2010, Nat Rev Genet]. When samples are processed in
#   different runs, at different times, or on different instruments, technical
#   variation can dwarf biological variation — leading to false positives and
#   false negatives. Every RNA-seq analysis MUST check for batch effects before
#   differential expression.
#
#   GSE130688 contains two batches (inferred from GSM accession number ranges):
#     - Batch 1 (GSM37xxxxx): 28 samples, patients P01-P14
#     - Batch 2 (GSM44xxxxx):  2 samples, patient P15 only
#
#   CRITICAL: Batch is PERFECTLY CONFOUNDED with patient. Patient P15 appears
#   ONLY in Batch 2. This means:
#     1. We CANNOT add `batch` to the DESeq2 design (~ patient + condition +
#        batch) — the model would be unestimable (perfect multicollinearity).
#     2. We CANNOT apply ComBat to the counts — it would break the paired
#        design and, with only 2 samples in Batch 2, the batch estimate would
#        be wildly unstable.
#     3. The PAIRED design (~ patient + condition) ALREADY controls batch for
#        the within-patient tumor-vs-normal comparison, because each patient's
#        tumor and normal pair are in the SAME batch. The batch effect is
#        absorbed into the patient blocking term.
#
#   This is a powerful teaching case: confounding is not always a disaster —
#   a well-chosen experimental design (paired/blocking) can rescue a confounded
#   batch structure for the comparison of interest.
#
# INPUTS:
#   data/counts_filtered.rds          — filtered count matrix (Script 01)
#   data/metadata.rds                 — sample metadata (Script 01)
#
# OUTPUTS:
#   figures/batch_pca.png             — PCA colored by batch, condition, patient
#   figures/batch_rle_plot.png        — RLE (Relative Log Expression) boxplot
#   figures/batch_variance_partition.png — Variance partition barplot
#   tables/batch_variance_partition.csv  — Variance partition table
#   data/metadata.rds                 — updated metadata with batch column
#   data/sample_metadata_enriched.csv — updated CSV with batch column
#
# DEPENDENCIES: DESeq2, ggplot2, reshape2, gridExtra
# =============================================================================

suppressPackageStartupMessages({
  library(DESeq2)
  library(ggplot2)
  library(reshape2)
})

# ---- Setup ------------------------------------------------------------------
data_dir    <- "data"
figures_dir <- "figures"
tables_dir  <- "tables"

# ---- Step 1: Load data and derive batch variable ----------------------------
# WHAT: Load the filtered count matrix and metadata from Script 01. Derive a
#       batch variable from the GSM accession numbers.
# WHY:  The GSM ID encodes the submission batch. GSM numbers below 4,000,000
#       belong to the original submission (Batch 1); numbers at 4,490,000+
#       belong to a later supplementary submission (Batch 2). This is a common
#       pattern in GEO series that combine samples from multiple submissions.
# BIOLOGICAL CONTEXT: Multi-submission GEO series frequently mix samples
#       processed at different times or on different instruments. Detecting
#       this structure is essential before any cross-sample analysis.

counts <- readRDS(file.path(data_dir, "counts_filtered.rds"))
meta   <- readRDS(file.path(data_dir, "metadata.rds"))

# Derive batch from GSM accession number
# GSM37xxxxx (submitted ~2019) -> Batch 1
# GSM44xxxxx (submitted ~2019, later supplement) -> Batch 2
gsm_numbers <- as.numeric(gsub("GSM", "", meta$sample))
meta$batch <- ifelse(gsm_numbers < 4000000, "Batch1", "Batch2")
meta$batch <- as.factor(meta$batch)

sum(meta$batch == "Batch1")
sum(meta$batch == "Batch2")

# ---- Step 2: Confounding diagnosis ------------------------------------------
# WHAT: Cross-tabulate batch x patient to reveal the confounding structure.
# WHY:  If batch and patient are confounded (each patient appears in only one
#       batch), then batch cannot be added as a separate covariate in the
#       DESeq2 model — it would be collinear with the patient blocking term.
#       This diagnosis determines whether batch correction is even possible.

ct <- table(meta$batch, meta$patient)
ct

# Check for confounding
patients_per_batch <- sapply(rownames(ct), function(b) sum(ct[b, ] > 0))
batches_per_patient <- sapply(colnames(ct), function(p) sum(ct[, p] > 0))

is_confounded <- all(batches_per_patient == 1)
cat("\n  >>> CONFOUNDING DIAGNOSIS:", ifelse(is_confounded,
    "BATCH IS CONFOUNDED WITH PATIENT\n      (each patient appears in only ONE batch)",
    "batch and patient are NOT fully confounded"), "\n")

if (is_confounded) {
  cat("\n  IMPLICATIONS:\n")
  cat("  1. Cannot add 'batch' to DESeq2 design (~ patient + condition + batch)\n")
  cat("     -> perfect multicollinearity, model unestimable\n")
  cat("  2. Cannot apply ComBat to counts -> would break paired design\n")
  cat("  3. The PAIRED design (~ patient + condition) ALREADY absorbs batch\n")
  cat("     because each patient's tumor+normal pair is in the SAME batch\n")
  cat("  4. No batch correction needed for the DE comparison\n")
  cat("  5. For visualization/WGCNA: batch is a caveat, not a correction target\n")
}

# Save updated metadata
saveRDS(meta, file.path(data_dir, "metadata.rds"))
write.csv(meta, file.path(data_dir, "sample_metadata_enriched.csv"), row.names = FALSE)

# ---- Step 3: VST transformation for QC visualization ------------------------
# WHAT: Apply Variance Stabilizing Transformation (VST) to the count data with
#       blind=TRUE. blind=TRUE means the transformation does NOT use the design
#       formula — this is correct for QC plots where we want to see ALL
#       variation, including batch effects.
# WHY:  For QC/diagnostic plots, we want to see the raw structure of the data
#       without the model "hiding" batch effects. blind=FALSE (used in Script 04
#       for downstream analysis) would partially account for the design, which
#       is what we want for PCA used in reporting but NOT for batch detection.

# Create a minimal DESeqDataSet for VST (design not used with blind=TRUE)
dds_qc <- DESeqDataSetFromMatrix(countData = counts, 
                                 colData = meta,
                                 design = ~ 1)
vsd_qc <- vst(dds_qc, blind = TRUE)
vst_mat <- assay(vsd_qc)
cat("  VST completed:", nrow(vst_mat), "genes x", ncol(vst_mat), "samples\n")

# ---- Step 4: PCA — batch detection ------------------------------------------
# WHAT: Perform PCA on the top 500 most variable genes and visualize samples
#       colored by batch, condition, and patient. Three side-by-side panels
#       let students compare which factor drives the separation.
# WHY:  PCA is the most intuitive batch detection tool. If samples cluster by
#       batch rather than by biological condition, batch effects dominate.
#       Coloring by multiple factors in separate panels teaches students to
#       distinguish biological from technical variation.
# BIOLOGICAL CONTEXT: In a clean dataset, PC1 should separate tumor from
#       normal (the biological variable of interest). If PC1 separates by
#       batch instead, technical variation is dominating biology.

# Select top 500 variable genes
gene_vars <- apply(vst_mat, 1, var)
top_genes <- names(sort(gene_vars, decreasing = TRUE))[1:500]
pca_data <- t(vst_mat[top_genes, ])

# Compute PCA
pca_res <- prcomp(pca_data, scale. = TRUE)
pca_summary <- summary(pca_res)
var_explained <- pca_summary$importance[2, ] * 100  # proportion of variance * 100
cat("  PC1:", round(var_explained[1], 1), "% variance\n")
cat("  PC2:", round(var_explained[2], 1), "% variance\n")

# Build PCA data frame for plotting
pca_df <- data.frame(
  PC1 = pca_res$x[, 1],      # 30 rows
  PC2 = pca_res$x[, 2],      # 30 rows
  sample = meta$sample,
  batch = meta$batch,
  condition = meta$condition,
  patient = meta$patient
)

# Three-panel PCA: batch, condition, patient
p1 <- ggplot(pca_df, aes(PC1, PC2, color = batch)) +
  geom_point(size = 4, alpha = 0.85) +
  geom_text(aes(label = patient), size = 2.8, vjust = -0.9, hjust = 0.5,
            show.legend = FALSE, color = "grey30") +
  scale_color_manual(values = c("Batch1" = "#0279EE", "Batch2" = "#FF9400")) +
  labs(title = "PCA colored by Batch",
       x = paste0("PC1 (", round(var_explained[1], 1), "%)"),
       y = paste0("PC2 (", round(var_explained[2], 1), "%)")) +
  theme_bw(base_size = 12)

p2 <- ggplot(pca_df, aes(PC1, PC2, color = condition)) +
  geom_point(size = 4, alpha = 0.85) +
  geom_text(aes(label = patient), size = 2.8, vjust = -0.9, hjust = 0.5,
            show.legend = FALSE, color = "grey30") +
  scale_color_manual(values = c("normal" = "#75A025", "tumor" = "#FD9BED")) +
  labs(title = "PCA colored by Condition",
       x = paste0("PC1 (", round(var_explained[1], 1), "%)"),
       y = paste0("PC2 (", round(var_explained[2], 1), "%)")) +
  theme_bw(base_size = 12)

p3 <- ggplot(pca_df, aes(PC1, PC2, color = patient)) +
  geom_point(size = 4, alpha = 0.85) +
  labs(title = "PCA colored by Patient",
       x = paste0("PC1 (", round(var_explained[1], 1), "%)"),
       y = paste0("PC2 (", round(var_explained[2], 1), "%)")) +
  theme_bw(base_size = 12) +
  theme(legend.position = "right")

# Combine three panels
library(gridExtra)
pca_combined <- grid.arrange(p1, p2, p3, ncol = 3, top = NULL)
ggsave(file.path(figures_dir, "batch_pca.png"), pca_combined,
       width = 16, height = 6, dpi = 300, bg = "white")

# ---- Step 5: RLE (Relative Log Expression) plot -----------------------------
# WHAT: Compute the Relative Log Expression (RLE) for each sample. RLE is the
#       log-ratio of each gene's expression in a sample vs. the median
#       expression of that gene across all samples. Plot as boxplots grouped
#       by batch.
# WHY:  In a batch-free dataset, RLE medians should be centered at 0 with
#       similar spread across samples. Systematic deviations (medians far from
#       0, or very different spreads) indicate library preparation or batch
#       effects. RLE is more sensitive than PCA for detecting subtle
#       technical biases.
# BIOLOGICAL CONTEXT: RLE complements PCA — PCA shows global structure, RLE
#       shows per-sample distributional shifts. Together they give a complete
#       picture of technical vs. biological variation.

# Compute RLE: log2(sample / median across samples) for each gene
gene_medians <- apply(vst_mat, 1, median)
rle_mat <- sweep(vst_mat, 1, gene_medians, FUN = function(x, m) x - m)

# Build data frame for plotting
rle_df <- melt(rle_mat)
colnames(rle_df) <- c("gene", "sample", "rle")
rle_df$batch <- meta$batch[match(rle_df$sample, meta$sample)]
rle_df$condition <- meta$condition[match(rle_df$sample, meta$sample)]

# Order samples by batch then condition
sample_order <- meta$sample[order(meta$batch, meta$condition)]
rle_df$sample <- factor(rle_df$sample, levels = sample_order)

rle_plot <- ggplot(rle_df, aes(sample, rle, fill = batch)) +
  geom_boxplot(outlier.size = 0.3, outlier.alpha = 0.2) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "grey40") +
  scale_fill_manual(values = c("Batch1" = "#0279EE", "Batch2" = "#FF9400")) +
  labs(title = "RLE Plot: Relative Log Expression by Batch",
       x = "Sample (ordered by batch, then condition)",
       y = "Relative Log Expression (RLE)") +
  theme_bw(base_size = 11) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 7),
        legend.position = "top")

ggsave(file.path(figures_dir, "batch_rle_plot.png"), rle_plot,
       width = 12, height = 7, dpi = 300, bg = "white")

# Compute RLE median per sample for reporting
rle_medians <- colMedians <- apply(rle_mat, 2, median)
cat("  RLE median range:", round(min(rle_medians), 3), "to",
    round(max(rle_medians), 3), "\n")
cat("  Batch1 RLE median range:",
    round(min(rle_medians[meta$batch == "Batch1"]), 3), "to",
    round(max(rle_medians[meta$batch == "Batch1"]), 3), "\n")
cat("  Batch2 RLE median range:",
    round(min(rle_medians[meta$batch == "Batch2"]), 3), "to",
    round(max(rle_medians[meta$batch == "Batch2"]), 3), "\n")

# ---- Step 6: Variance partition ---------------------------------------------
# WHAT: Quantify the percentage of variance in gene expression explained by
#       each factor (batch, condition, patient) using a linear mixed model
#       framework. This decomposes total expression variance into components
#       attributable to each source.
# WHY:  Variance partition answers "how much of the variation is biological
#       vs. technical?" numerically. If batch explains a large fraction,
#       correction is warranted. If condition (the biological variable)
#       dominates and batch is minor, the analysis is robust. This is the
#       most quantitative batch assessment tool.
# BIOLOGICAL CONTEXT: In a well-designed study, the biological variable of
#       interest (condition: tumor vs normal) should explain more variance
#       than technical factors (batch). Patient-to-patient variation is
#       expected and is controlled by the paired design.

# Use a subset of genes for speed (variance partition on all 23k is slow)
# Select top 2000 most variable genes — representative of the signal
set.seed(42)
top_vp_genes <- names(sort(gene_vars, decreasing = TRUE))[1:2000]
vst_vp <- vst_mat[top_vp_genes, ]

# Prepare metadata
vp_meta <- data.frame(
  batch = meta$batch,
  condition = meta$condition,
  patient = meta$patient,
  row.names = meta$sample
)

# ---- Manual variance partition via sequential ANOVA -------------------------
# WHAT: For each gene, fit a linear model ~ batch + condition + patient and
#       decompose the total variance into components attributable to each factor
#       using Type I (sequential) sums of squares. The variance fraction for
#       each factor = SS_factor / SS_total.
# WHY:  This is a transparent, dependency-light alternative to the
#       variancePartition package (which has a compatibility issue with the
#       current lme4/reformulas versions). The sequential ANOVA approach gives
#       the same type of result: the proportion of expression variance
#       explained by each factor. We order factors as batch, condition, patient
#       so that batch is assessed first (most conservative for detecting batch
#       effects — any variance shared with later factors is attributed to batch).
# NOTE: Because batch is confounded with patient, the patient term will absorb
#       little additional variance after batch is already in the model. This is
#       expected and is itself a diagnostic of confounding.

# Function to compute variance fractions for one gene
compute_var_fractions <- function(y, batch, condition, patient) {
  # Fit sequential model: batch first, then condition, then patient
  fit <- lm(y ~ batch + condition + patient)
  ss <- anova(fit)$"Sum Sq"  # sequential SS: [batch, condition, patient, Residuals]
  ss_total <- sum(ss)
  if (ss_total == 0) return(c(0, 0, 0, 0))
  ss / ss_total  # returns fractions: batch, condition, patient, residual
}

# Apply across all genes
vp_results <- t(apply(vst_vp, 1, function(y) {
  compute_var_fractions(y, vp_meta$batch, vp_meta$condition, vp_meta$patient)
}))
colnames(vp_results) <- c("batch", "condition", "patient", "residual")

# Build data frame
vp_df <- as.data.frame(vp_results)
vp_df$gene <- rownames(vp_df)

# Summarize: mean and median variance explained per factor
vp_summary <- data.frame(
  factor = c("batch", "condition", "patient"),
  mean_var = round(colMeans(vp_df[, c("batch", "condition", "patient")]) * 100, 2),
  median_var = round(apply(vp_df[, c("batch", "condition", "patient")], 2, median) * 100, 2))

vp_summary

# Save full per-gene table
vp_long <- vp_df[, c("batch", "condition", "patient", "residual", "gene")]
write.csv(vp_long, file.path(tables_dir, "batch_variance_partition.csv"),
          row.names = FALSE)

# Save summary table too
vp_summary_file <- data.frame(
  factor = vp_summary$factor,
  mean_variance_pct = vp_summary$mean_var,
  median_variance_pct = vp_summary$median_var
)
write.csv(vp_summary_file,
          file.path(tables_dir, "batch_variance_partition_summary.csv"),
          row.names = FALSE)

# Plot variance partition (boxplot of per-gene variance fractions)
vp_plot_df <- melt(vp_df[, 1:3])
colnames(vp_plot_df) <- c("factor", "variance_fraction")
vp_plot_df$variance_fraction <- vp_plot_df$variance_fraction * 100

# Order factors by mean variance explained
factor_order <- vp_summary$factor[order(vp_summary$mean_var, decreasing = TRUE)]
vp_plot_df$factor <- factor(vp_plot_df$factor, levels = factor_order)

vp_plot <- ggplot(vp_plot_df, aes(factor, variance_fraction, fill = factor)) +
  geom_boxplot(outlier.size = 0.4, outlier.alpha = 0.3) +
  scale_fill_manual(values = c("batch" = "#FF9400", "condition" = "#FD9BED",
                                "patient" = "#0279EE")) +
  labs(title = "Variance Partition: Batch vs Condition vs Patient",
       x = "Factor",
       y = "Variance explained (%)") +
  theme_bw(base_size = 13) +
  theme(legend.position = "none")

ggsave(file.path(figures_dir, "batch_variance_partition.png"), vp_plot,
       width = 8, height = 6, dpi = 300, bg = "white")

