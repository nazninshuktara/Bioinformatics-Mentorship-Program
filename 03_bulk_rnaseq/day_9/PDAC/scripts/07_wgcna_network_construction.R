# =============================================================================
# Script 07: WGCNA Network Construction
# =============================================================================
# WHAT: Build a weighted gene co-expression network from the VST-transformed
#       PDAC expression data. Steps:
#       (1) Load VST data and select top 5,000 most variable genes
#       (2) Check sample quality (goodSamplesGenes)
#       (3) Choose soft thresholding power (pickSoftThreshold)
#       (4) Construct network and detect modules (blockwiseModules)
#       (5) Generate soft-power diagnostic plot and gene dendrogram
#
# WHY:  WGCNA (Weighted Gene Co-expression Network Analysis) groups genes
#       into modules based on their co-expression patterns across samples.
#       Unlike single-gene DE analysis, WGCNA identifies COORDINATED
#       regulatory programs — groups of genes that behave together. This
#       reveals biological modules (e.g., stromal, immune, proliferation)
#       that may not be apparent from individual DE genes.
#
#       Key concepts:
#       - SOFT thresholding: instead of binary (connected/not connected),
#         WGCNA uses a continuous similarity (correlation raised to a power).
#         The power soft-thresholds the correlation, suppressing weak/noisy
#         correlations while preserving strong ones.
#       - Scale-free topology: biological networks approximate a scale-free
#         degree distribution (few hubs, many peripheral nodes). The soft
#         power is chosen to make the network approximate this topology.
#       - SIGNED network: preserves the sign of correlations, so genes that
#         are anti-correlated are NOT in the same module. This is appropriate
#         when we care about direction of change (tumor vs. normal).
#
#       Why VST (not raw counts): WGCNA uses Pearson correlations, which
#       assume homoscedastic data. Raw counts have variance increasing with
#       mean, which would bias correlations toward highly expressed genes.
#       VST removes this mean-variance dependence.
#
# BIOLOGICAL CONTEXT:
#   In PDAC, co-expression modules may represent:
#   - Stromal/desmoplastic program (fibroblast activation, ECM remodeling)
#   - Immune infiltration program (T cells, macrophages, immune checkpoints)
#   - Proliferation/cell cycle program (tumor cell division)
#   - Acinar cell identity program (normal pancreas function, lost in tumor)
#   These modules capture biological programs at the pathway level, even
#   when individual genes have modest fold changes.
#
# KEY TEACHING POINTS:
#   - Scale-free network topology and why it matters
#   - Soft vs. hard thresholding
#   - Why VST (not raw counts) for WGCNA
#   - blockwise module detection (hierarchical clustering + dynamic tree cut)
#   - Module merging (mergeCutHeight controls how similar modules must be
#     to be merged)
#   - Signed vs. unsigned networks
# =============================================================================

suppressPackageStartupMessages({
  library(WGCNA)
  library(ggplot2)
})

# Enable WGCNA threads for faster computation
allowWGCNAThreads()

# ---- Configuration ----------------------------------------------------------
fig_dir   <- "figures"
table_dir <- "tables"
data_dir  <- "data"

# WGCNA parameters
n_genes_select <- 5000   # top variable genes for network
min_module_size <- 30    # minimum genes per module
merge_cut_height <- 0.25 # merge threshold for similar modules
network_type <- "signed" # signed network preserves correlation direction

# ---- Step 1: Load VST data and select top variable genes -------------------
# WHAT: Load the VST-transformed matrix from Script 04 and select the top
#       5,000 most variable genes.
# WHY:  WGCNA on all ~23,000 genes would be computationally expensive and
#       memory-intensive. More importantly, low-variance genes contribute
#       little information to co-expression patterns. Selecting the top
#       5,000 most variable genes focuses the analysis on genes that
#       actually vary across samples — these are the genes that define
#       biological modules. 5,000 is the standard WGCNA recommendation.
cat("Step 1: Loading VST data and selecting top variable genes...\n")
vst_mat <- readRDS(file.path(data_dir, "vst_transformed.rds"))
cat("  VST matrix:", nrow(vst_mat), "genes x", ncol(vst_mat), "samples\n")

# WGCNA expects samples as rows, genes as columns (transposed)
datExpr0 <- t(vst_mat)

# Select top 5,000 most variable genes
gene_var <- apply(datExpr0, 2, var)
top_genes <- names(sort(gene_var, decreasing = TRUE))[1:min(n_genes_select, ncol(datExpr0))]
datExpr <- datExpr0[, top_genes]
cat("  Selected top", ncol(datExpr), "most variable genes\n")
cat("  Data dimensions for WGCNA:", nrow(datExpr), "samples x", ncol(datExpr), "genes\n")

# ---- Step 2: Sample quality check ------------------------------------------
# WHAT: Run goodSamplesGenes to identify outlier samples and genes with
#       too many missing values.
# WHY:  WGCNA is sensitive to outliers — a single extreme sample can distort
#       the correlation structure. This check flags samples or genes that
#       should be removed before network construction.
cat("\nStep 2: Checking sample and gene quality (goodSamplesGenes)...\n")
gsg <- goodSamplesGenes(datExpr, verbose = 0)
if (!gsg$allOK) {
  cat("  WARNING: Removing flagged samples/genes\n")
  if (sum(!gsg$goodGenes) > 0) datExpr <- datExpr[, gsg$goodGenes]
  if (sum(!gsg$goodSamples) > 0) datExpr <- datExpr[gsg$goodSamples, ]
} else {
  cat("  All samples and genes passed quality check\n")
}
cat("  Final dimensions:", nrow(datExpr), "samples x", ncol(datExpr), "genes\n")

# ---- Step 3: Soft thresholding power selection ------------------------------
# WHAT: Use pickSoftThreshold to find the soft power that best approximates
#       scale-free topology (target R^2 >= 0.8). The function tests powers
#       1-20 and reports the scale-free topology fit index (R^2) for each.
# WHY:  The soft power is the MOST IMPORTANT WGCNA parameter. It determines
#       how aggressively weak correlations are suppressed:
#         - Too low: network is too dense (everything connected to everything)
#         - Too high: network is too sparse (only very strong correlations)
#       The goal is to find the lowest power that achieves R^2 >= 0.8 for
#       the scale-free topology fit. This ensures the network has the
#       hub-and-spoke structure characteristic of biological networks.
cat("\nStep 3: Selecting soft thresholding power...\n")

powers <- c(1:20)
sft <- pickSoftThreshold(datExpr, powerVector = powers, networkType = network_type,
                         verbose = 0, blockSize = 5000)

# Choose power: lowest power with R^2 >= 0.8 (or use recommended)
sft_summary <- sft$fitIndices
r2_values <- -sign(sft_summary$slope) * sft_summary$SFT.R.sq
power_selected <- sft$powerEstimate

# If automatic selection fails, pick manually
if (is.na(power_selected) || power_selected > 20) {
  # Find first power with R^2 >= 0.8
  candidates <- which(r2_values >= 0.8)
  if (length(candidates) > 0) {
    power_selected <- powers[candidates[1]]
  } else {
    # Fallback: use power 12 (common for signed networks)
    power_selected <- 12
  }
}

cat("  Scale-free R^2 values by power:\n")
for (i in seq_along(powers)) {
  cat("    Power", sprintf("%2d", powers[i]), ": R^2 =", round(r2_values[i], 3), "\n")
}
cat("  Selected soft power:", power_selected, "(R^2 =", round(r2_values[power_selected], 3), ")\n")

# ---- Step 4: Soft power diagnostic plot ------------------------------------
# WHAT: Generate the standard two-panel soft power diagnostic plot:
#       (Left) Scale-free topology fit index (R^2) vs. power
#       (Right) Mean connectivity vs. power
# WHY:  This plot visualizes the power selection tradeoff. As power increases,
#       R^2 increases (better scale-free fit) but connectivity decreases
#       (sparser network). The selected power balances these two criteria.
cat("\nStep 4: Generating soft power diagnostic plot...\n")

# Build data for plotting
sft_df <- data.frame(
  Power = powers,
  R2 = r2_values,
  MeanConnectivity = sft_summary$mean.k.
)

# Two-panel plot
p1 <- ggplot(sft_df, aes(x = Power, y = R2)) +
  geom_line(color = "#0279EE", linewidth = 0.8) +
  geom_point(size = 2) +
  geom_hline(yintercept = 0.8, linetype = "dashed", color = "#FF9400") +
  geom_vline(xintercept = power_selected, linetype = "dashed", color = "grey50") +
  annotate("text", x = power_selected + 1, y = 0.82, label = paste("Power =", power_selected), size = 3) +
  labs(title = "Scale-Free Topology Fit", x = "Soft Power", y = "Scale-Free R^2") +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

p2 <- ggplot(sft_df, aes(x = Power, y = MeanConnectivity)) +
  geom_line(color = "#FF9400", linewidth = 0.8) +
  geom_point(size = 2) +
  geom_vline(xintercept = power_selected, linetype = "dashed", color = "grey50") +
  labs(title = "Mean Connectivity", x = "Soft Power", y = "Mean Connectivity") +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

# Combine using patchwork or gridExtra
library(patchwork)
sft_plot <- p1 + p2 + plot_annotation(title = "WGCNA Soft Power Selection",
                                       theme = theme(plot.title = element_text(hjust = 0.5, face = "bold")))
ggsave(file.path(fig_dir, "wgcna_soft_power.png"), sft_plot, width = 12, height = 5, dpi = 300)
cat("  Saved figures/wgcna_soft_power.png\n")

# ---- Step 5: Network construction and module detection ---------------------
# WHAT: Build the co-expression network using blockwiseModules, which:
#       (a) Computes the correlation matrix (all gene pairs)
#       (b) Raises correlations to the soft power -> adjacency matrix
#       (c) Computes Topological Overlap Matrix (TOM) — a refined similarity
#           that accounts for shared neighbors (two genes are similar if they
#           connect to the same other genes)
#       (d) Hierarchical clustering on the TOM dissimilarity
#       (e) Dynamic tree cutting to define modules
#       (f) Merges modules whose eigengenes are correlated (mergeCutHeight)
# WHY:  The TOM is the key innovation of WGCNA. Raw correlations only measure
#       direct similarity between two genes. TOM also considers indirect
#       relationships — if gene A and gene B both connect to gene C, they are
#       "topologically similar" even if their direct correlation is modest.
#       This captures the modular structure of biological networks.
#
#       Parameters:
#       - minModuleSize = 30: modules must have at least 30 genes (avoids
#         tiny, unstable modules)
#       - mergeCutHeight = 0.25: modules with eigengene correlation > 0.75
#         (dissimilarity < 0.25) are merged (avoids over-splitting)
#       - networkType = "signed": anti-correlated genes go to different
#         modules (appropriate for tumor vs. normal where direction matters)
cat("\nStep 5: Constructing co-expression network (blockwiseModules)...\n")
cat("  Parameters: power =", power_selected, "| minModuleSize =", min_module_size,
    "| mergeCutHeight =", merge_cut_height, "| type =", network_type, "\n")

net <- blockwiseModules(
  datExpr,
  power             = power_selected,
  networkType       = network_type,
  TOMType           = network_type,
  minModuleSize     = min_module_size,
  mergeCutHeight    = merge_cut_height,
  numericLabels     = TRUE,
  saveTOMs          = TRUE,
  saveTOMFileBase   = file.path(data_dir, "wgcna_TOM"),
  verbose           = 0,
  maxBlockSize      = 5000
)

# Convert numeric labels to colors
moduleColors <- labels2colors(net$colors)
n_modules <- length(unique(moduleColors)) - ifelse("grey" %in% moduleColors, 1, 0)
n_grey <- sum(moduleColors == "grey")

cat("  Network construction completed\n")
cat("  Modules detected (excluding grey):", n_modules, "\n")
cat("  Genes in grey module (unassigned):", n_grey, "\n")
cat("  Module sizes:\n")
print(table(moduleColors))

# ---- Step 6: Gene dendrogram with module colors ----------------------------
# WHAT: Plot the hierarchical clustering dendrogram with module colors
#       assigned by dynamic tree cutting shown beneath.
# WHY:  This plot shows the clustering structure that defines modules. Each
#       branch is a cluster of co-expressed genes; the color bar shows which
#       module each gene was assigned to. Grey = unassigned genes.
cat("\nStep 6: Generating gene dendrogram with module colors...\n")

# Convert to a dendrogram for plotting
geneTree <- net$dendrograms[[1]]

png(file.path(fig_dir, "wgcna_dendrogram.png"), width = 12, height = 7, units = "in", res = 300)
plotDendroAndColors(
  geneTree,
  moduleColors[net$blockGenes[[1]]],
  "Module",
  dendroLabels = FALSE,
  hang = 0.03,
  addGuide = TRUE,
  guideHang = 0.05,
  main = "Gene Dendrogram and Module Colors"
)
dev.off()
cat("  Saved figures/wgcna_dendrogram.png\n")

# ---- Step 7: Export results -------------------------------------------------
# WHAT: Save gene-module assignments, the network object, and the expression
#       matrix for downstream use (Script 08).
cat("\nStep 7: Exporting results...\n")

# Gene-module assignments
gene_modules <- data.frame(
  gene = colnames(datExpr),
  module = moduleColors,
  stringsAsFactors = FALSE
)
write.csv(gene_modules, file.path(table_dir, "wgcna_gene_modules.csv"), row.names = FALSE)
cat("  Saved tables/wgcna_gene_modules.csv\n")

# Save RDS objects for Script 08
saveRDS(net, file.path(data_dir, "wgcna_network.rds"))
saveRDS(datExpr, file.path(data_dir, "wgcna_datExpr.rds"))
saveRDS(moduleColors, file.path(data_dir, "wgcna_module_colors.rds"))
saveRDS(power_selected, file.path(data_dir, "wgcna_power.rds"))
cat("  Saved RDS: wgcna_network.rds, wgcna_datExpr.rds, wgcna_module_colors.rds, wgcna_power.rds\n")
