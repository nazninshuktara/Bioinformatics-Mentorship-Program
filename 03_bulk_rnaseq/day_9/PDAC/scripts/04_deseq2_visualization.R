# Script 04: DESeq2 Visualization & QC Plots
# =============================================================================
# WHAT: Generate six standard DESeq2 diagnostic and results plots:
#       (1) Dispersion plot — validates the mean-dispersion model fit
#       (2) PCA plot — reveals sample clustering by condition and patient
#       (3) Sample distance heatmap — pairwise sample similarity
#       (4) MA plot — log2FC vs. expression level (uses shrunk LFC)
#       (5) Volcano plot — log2FC vs. significance with top gene labels
#       (6) Top genes heatmap — expression of top 50 significant genes
#
# WHY:  QC plots (dispersion, PCA, distance) validate model assumptions and
#       reveal sample structure BEFORE trusting the DE results. Results plots
#       (MA, volcano, heatmap) communicate the biological signal. The PCA plot
#       is especially important for the paired-design teaching point: if
#       samples cluster by patient, it confirms that the paired design was
#       necessary.
#
# BIOLOGICAL CONTEXT:
#   PCA and distance heatmap reveal whether tumor and normal samples separate
#   cleanly, and whether patient-to-patient variability is substantial (which
#   justifies the paired design). The volcano plot and heatmap show which
#   genes drive the tumor vs. normal separation — in PDAC, we expect
#   downregulation of acinar cell enzymes (digestive enzymes like CTRB1,
#   CPA1, PNLIP) and upregulation of tumor/stromal genes.
#
# KEY TEACHING POINTS:
#   - Dispersion plot: gene-wise estimates shrink toward the fitted trend
#   - PCA: variance-stabilized data removes mean-variance dependence
#   - Paired design: PCA by patient shows why blocking matters
#   - MA plot: shrunk LFC removes the "trumpet" at low expression
#   - Volcano plot: effect size vs. statistical significance tradeoff
#   - Heatmap: unsupervised clustering reveals sample/gene structure
# =============================================================================

suppressPackageStartupMessages({
  library(DESeq2)
  library(ggplot2)
  library(ggrepel)
  library(pheatmap)
  library(RColorBrewer)
})

# ---- Configuration ----------------------------------------------------------
fig_dir <- "figures"
dir.create(fig_dir, showWarnings = FALSE, recursive = TRUE)

# Plot dimensions and DPI for publication-quality PNG
fig_width  <- 8
fig_height <- 6
fig_dpi    <- 300

# ---- Load data from Script 03 ----------------------------------------------
cat("Loading DESeq2 objects from Script 03...\n")
dds        <- readRDS("data/dds_object.rds")
res        <- readRDS("data/deseq2_res.rds")
res_shrunk <- readRDS("data/deseq2_res_shrunk.rds")
metadata   <- readRDS("data/metadata.rds")
cat("  Loaded dds, res, res_shrunk, metadata\n")

# ---- Step 1: Variance-stabilizing transformation ---------------------------
# WHAT: Apply VST (variance stabilizing transformation) to the count data.
#       VST transforms counts so that variance is approximately constant
#       across the expression range, which is required for PCA, heatmaps,
#       and sample distance calculations.
# WHY:  Raw or normalized counts have variance that increases with mean
#       expression (heteroscedasticity). Without transformation, PCA and
#       distance metrics would be dominated by highly expressed genes.
#       VST removes this mean-variance dependence. We use VST (not rlog)
#       because it is faster and appropriate for this sample size (30).
cat("\nStep 1: Applying variance-stabilizing transformation (VST)...\n")
vsd <- vst(dds, blind = FALSE)
cat("  VST completed:", nrow(vsd), "genes x", ncol(vsd), "samples\n")
# Save VST matrix for WGCNA (Script 07)
saveRDS(assay(vsd), "data/vst_transformed.rds")
cat("  Saved VST matrix to data/vst_transformed.rds (for WGCNA)\n")

# ---- Step 2: Dispersion plot ------------------------------------------------
# WHAT: Plot gene-wise dispersion estimates vs. mean expression, with the
#       fitted dispersion trend and final (shrunk) estimates.
# WHY:  This is the most important QC plot for DESeq2. It shows:
#       - Gene-wise dispersion estimates (black dots) scatter around the
#         fitted trend (red line)
#       - Final estimates (blue dots) are shrunk toward the trend
#       - Outliers (circled) are not shrunk
#       A good fit means the NB model is appropriate for this data.
cat("\nStep 2: Generating dispersion plot...\n")
png(file.path(fig_dir, "deseq2_dispersion.png"), width = fig_width, height = fig_height, units = "in", res = fig_dpi)
plotDispEsts(dds, main = "DESeq2 Dispersion Estimates")
dev.off()
cat("  Saved figures/deseq2_dispersion.png\n")

# ---- Step 3: PCA plot -------------------------------------------------------
# WHAT: Perform PCA on the top 500 most variable genes (VST-transformed) and
#       plot PC1 vs. PC2, colored by condition and labeled by patient.
# WHY:  PCA reveals the dominant axes of variation in the data. If tumor and
#       normal samples separate along PC1, the condition effect is strong.
#       Labeling by patient shows whether patient identity explains additional
#       variance — if it does, the paired design was necessary.
cat("\nStep 3: Generating PCA plot...\n")

# Compute PCA on VST data (top 500 variable genes)
vsd_mat <- assay(vsd)
rv <- rowVars(vsd_mat)
select <- order(rv, decreasing = TRUE)[seq_len(min(500, length(rv)))]
pca_data <- prcomp(t(vsd_mat[select, ]))
pca_var <- round(100 * pca_data$sdev^2 / sum(pca_data$sdev^2), 1)

# Build PCA data frame
pca_df <- data.frame(
  PC1 = pca_data$x[, 1],
  PC2 = pca_data$x[, 2],
  condition = metadata$condition,
  patient   = metadata$patient,
  sample    = metadata$Sample
)

pca_plot <- ggplot(pca_df, aes(x = PC1, y = PC2, color = condition, label = patient)) +
  geom_point(size = 4, alpha = 0.8) +
  geom_text_repel(size = 3, max.overlaps = 20, segment.alpha = 0.3) +
  scale_color_manual(values = c("normal" = "#0279EE", "tumor" = "#FF9400")) +
  labs(
    title = "PCA: PDAC Tumor vs. Normal (VST, top 500 variable genes)",
    x = paste0("PC1 (", pca_var[1], "% variance)"),
    y = paste0("PC2 (", pca_var[2], "% variance)")
  ) +
  theme_minimal(base_size = 13) +
  theme(
    legend.position = "right",
    plot.title = element_text(hjust = 0.5, face = "bold")
  )

ggsave(file.path(fig_dir, "deseq2_pca.png"), pca_plot, width = fig_width, height = fig_height, dpi = fig_dpi)
cat("  PC1:", pca_var[1], "% | PC2:", pca_var[2], "% variance explained\n")

# ---- Step 4: Sample distance heatmap ---------------------------------------
# WHAT: Compute Euclidean distances between samples (on VST data) and display
#       as a heatmap with condition and patient annotations.
# WHY:  This complements PCA by showing ALL pairwise sample relationships.
#       Samples should cluster primarily by condition (tumor vs. normal),
#       with sub-clustering by patient visible if inter-patient variability
#       is substantial.

# Compute sample distances
sample_dists <- dist(t(assay(vsd)))
sample_dist_matrix <- as.matrix(sample_dists)

# Annotation colors
annotation_col <- data.frame(
  condition = metadata$condition,
  patient   = metadata$patient,
  row.names = metadata$sample
)
ann_colors <- list(
  condition = c("normal" = "#0279EE", "tumor" = "#FF9400")
)

annotation_col <- annotation_col[colnames(sample_dist_matrix), , drop = FALSE]

# Colors for heatmap
colors <- colorRampPalette(rev(brewer.pal(9, "Blues")))(255)

ggsave(file.path(fig_dir, "deseq2_sample_distance.png"), width = 9, height = 8, dpi = fig_dpi)

pheatmap(
  sample_dist_matrix,
  clustering_distance_rows = sample_dists,
  clustering_distance_cols = sample_dists,
  annotation_col = annotation_col,
  annotation_colors = ann_colors,
  col = colors,
  main = "Sample-to-Sample Distances (VST)",
  fontsize_row = 7,
  fontsize_col = 7
)
dev.off()


# ---- Step 5: MA plot --------------------------------------------------------
# WHAT: Plot shrunk log2FC vs. baseMean (expression level). Genes with
#       padj < 0.05 are colored red.
# WHY:  The MA plot shows the relationship between expression level and
#       fold change. With apeglm shrinkage, the plot should be symmetric
#       around log2FC = 0 at low expression (no "trumpet" effect). This
#       validates that shrinkage worked correctly.


# Build MA plot data frame
ma_df <- data.frame(
  baseMean = res_shrunk$baseMean,
  log2FoldChange = res_shrunk$log2FoldChange,
  padj = res_shrunk$padj
)
ma_df$significant <- ifelse(!is.na(ma_df$padj) & ma_df$padj < 0.05, "padj < 0.05", "NS")

# Label top 5 genes by padj
ma_df$gene <- rownames(res_shrunk)
top_genes_ma <- ma_df[order(ma_df$padj), ][1:5, ]

ma_plot <- ggplot(ma_df, aes(x = log10(baseMean + 1), y = log2FoldChange, color = significant)) +
  geom_point(alpha = 0.5, size = 1) +
  geom_point(data = top_genes_ma, aes(label = gene), color = "black", size = 2) +
  geom_text_repel(data = top_genes_ma, aes(label = gene), size = 3, max.overlaps = 10) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "grey50") +
  scale_color_manual(values = c("padj < 0.05" = "#FF9400", "NS" = "grey70")) +
  labs(
    title = "MA Plot: Tumor vs. Normal (apeglm shrunk LFC)",
    x = "log10(baseMean + 1)",
    y = "log2 Fold Change (shrunk)"
  ) +
  theme_minimal(base_size = 13) +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

ggsave(file.path(fig_dir, "deseq2_ma_plot.png"), ma_plot, width = fig_width, height = fig_height, dpi = fig_dpi)

# ---- Step 6: Volcano plot ---------------------------------------------------
# WHAT: Plot shrunk log2FC vs. -log10(padj). Significant genes (padj < 0.05,
#       |log2FC| >= 1) are colored. Top 10 genes are labeled.
# WHY:  The volcano plot is the canonical DE visualization: it shows both
#       the magnitude (x-axis) and statistical significance (y-axis) of
#       expression changes. Genes in the upper-left (downregulated) and
#       upper-right (upregulated) corners are the most interesting candidates.

volcano_df <- data.frame(
  gene = rownames(res_shrunk),
  log2FoldChange = res_shrunk$log2FoldChange,
  padj = res_shrunk$padj
)
volcano_df$neglog10padj <- -log10(volcano_df$padj)

# Classify genes
volcano_df$category <- "NS"
volcano_df$category[!is.na(volcano_df$padj) & volcano_df$padj < 0.05 & volcano_df$log2FoldChange >= 1] <- "Up"
volcano_df$category[!is.na(volcano_df$padj) & volcano_df$padj < 0.05 & volcano_df$log2FoldChange <= -1] <- "Down"

# Top 10 genes for labeling (by padj, among significant with |log2FC| >= 1)
sig_for_label <- volcano_df[!is.na(volcano_df$padj) & volcano_df$padj < 0.05 & abs(volcano_df$log2FoldChange) >= 1, ]
top_genes_vol <- sig_for_label[order(sig_for_label$padj), ][1:10, ]

volcano_plot <- ggplot(volcano_df, aes(x = log2FoldChange, y = neglog10padj, color = category)) +
  geom_point(alpha = 0.5, size = 1) +
  geom_point(data = top_genes_vol, color = "black", size = 2) +
  geom_text_repel(data = top_genes_vol, aes(label = gene), size = 3, max.overlaps = 20,
                  segment.alpha = 0.3) +
  geom_vline(xintercept = c(-1, 1), linetype = "dashed", color = "grey50") +
  geom_hline(yintercept = -log10(0.05), linetype = "dashed", color = "grey50") +
  scale_color_manual(values = c("Up" = "#FF9400", "Down" = "#0279EE", "NS" = "grey80")) +
  labs(
    title = "Volcano Plot: PDAC Tumor vs. Normal",
    x = "log2 Fold Change (shrunk)",
    y = "-log10(adjusted p-value)"
  ) +
  theme_minimal(base_size = 13) +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

ggsave(file.path(fig_dir, "deseq2_volcano.png"), volcano_plot, width = fig_width, height = fig_height, dpi = fig_dpi)

# ---- Step 7: Top genes heatmap ----------------------------------------------
# WHAT: Heatmap of the top 50 significant genes (by padj), using VST-transformed
#       data, with z-score scaling per gene and sample annotations.
# WHY:  This heatmap shows whether the top DE genes cleanly separate tumor
#       from normal samples. Z-scoring per gene (subtracting mean, dividing
#       by SD) normalizes expression to a comparable scale, so the heatmap
#       shows relative expression patterns rather than absolute levels.

# Get top 50 significant genes (by padj, with |log2FC| >= 1)
sig_genes_ordered <- res_shrunk[which(res_shrunk$padj < 0.05 & abs(res_shrunk$log2FoldChange) >= 1), ]
sig_genes_ordered <- sig_genes_ordered[order(sig_genes_ordered$padj), ]
top50_genes <- head(rownames(sig_genes_ordered), 50)

# Extract VST values for top genes
top50_vst <- assay(vsd)[top50_genes, ]

# Z-score per gene (row)
top50_z <- t(apply(top50_vst, 1, function(x) (x - mean(x)) / sd(x)))
rownames(top50_z) <- top50_genes

# Annotation
annotation_col <- data.frame(
  condition = metadata$condition,
  row.names = metadata$sample
)
ann_colors <- list(condition = c("normal" = "#0279EE", "tumor" = "#FF9400"))

# Color scale
colors_heat <- colorRampPalette(rev(brewer.pal(11, "RdBu")))(100)

png(file.path(fig_dir, "deseq2_top_genes_heatmap.png"), width = 10, height = 9, units = "in", res = fig_dpi)
pheatmap(
  top50_z,
  annotation_col = annotation_col,
  annotation_colors = ann_colors,
  col = colors_heat,
  scale = "row",
  clustering_method = "complete",
  show_rownames = TRUE,
  show_colnames = FALSE,
  fontsize_row = 7,
  main = "Top 50 DE Genes (z-score, VST)"
)
dev.off()
