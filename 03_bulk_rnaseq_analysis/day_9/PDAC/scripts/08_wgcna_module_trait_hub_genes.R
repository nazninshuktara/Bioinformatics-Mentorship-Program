# =============================================================================
# Script 08: WGCNA Module-Trait Correlation & Hub Genes
# =============================================================================
# WHAT: Link co-expression modules to the biological condition (tumor vs.
#       normal) and identify hub genes within significant modules. Steps:
#       (1) Calculate module eigengenes (first PC of each module)
#       (2) Correlate eigengenes with the trait (condition: tumor=1, normal=0)
#       (3) Identify significant module-trait relationships (|r| > 0.5, p < 0.05)
#       (4) Calculate intramodular connectivity (kWithin) and module
#           membership (MM) for each gene
#       (5) Identify top hub genes per significant module
#       (6) Generate module-trait heatmap, eigengene heatmap, hub gene barplot
#       (7) Optional: enrichment of significant modules
#
# WHY:  Network construction (Script 07) identifies modules, but doesn't tell
#       us which modules are BIOLOGICALLY RELEVANT. Module-trait correlation
#       answers: "Which co-expression modules are associated with tumor status?"
#       This is the key step that connects unsupervised network analysis to
#       the biological question.
#
#       Hub genes are the most highly connected genes within a module. They
#       are candidate key regulators — if a module is associated with tumor
#       status, its hub genes are the most likely drivers and the best
#       candidates for experimental validation (knockdown, overexpression).
#
# BIOLOGICAL CONTEXT:
#   Modules significantly correlated with tumor status represent PDAC-specific
#   biological programs. For example:
#   - A module positively correlated with tumor = genes co-activated in PDAC
#     (could be stromal, immune, or proliferation program)
#   - A module negatively correlated with tumor = genes co-suppressed in PDAC
#     (could be acinar cell identity program)
#   Hub genes in these modules are candidate biomarkers or therapeutic targets.
#   Comparing module genes with DE results (Script 03) reveals whether DE
#   genes cluster into specific modules — a powerful cross-validation.
#
# KEY TEACHING POINTS:
#   - Module eigengene: the first principal component of a module; a summary
#     of the module's expression profile across samples
#   - Module-trait correlation: Pearson correlation between eigengene and
#     external trait; identifies biologically relevant modules
#   - Intramodular connectivity (kWithin): how well a gene connects to other
#     genes in the same module
#   - Module membership (MM): correlation between a gene's expression and
#     the module eigengene; measures how strongly a gene "belongs" to a module
#   - Hub gene concept: high kWithin + high MM = key module member
#   - Integrating WGCNA with DE results: do DE genes cluster in specific modules?
# =============================================================================

suppressPackageStartupMessages({
  library(WGCNA)
  library(ggplot2)
  library(ComplexHeatmap)
  library(circlize)
  library(pheatmap)
})

# ---- Load data from Script 07 ----------------------------------------------
cat("Loading WGCNA objects from Script 07...\n")
datExpr       <- readRDS("data/wgcna_datExpr.rds")
moduleColors  <- readRDS("data/wgcna_module_colors.rds")
net           <- readRDS("data/wgcna_network.rds")
power_selected <- readRDS("data/wgcna_power.rds")
metadata      <- readRDS("data/metadata.rds")
cat("  Loaded:", nrow(datExpr), "samples x", ncol(datExpr), "genes\n")
cat("  Modules:", length(unique(moduleColors)), "colors\n")

# ---- Step 1: Define the trait (condition) ----------------------------------
# WHAT: Create a numeric trait matrix: condition coded as tumor=1, normal=0.
# WHY:  Module-trait correlation requires numeric traits. Binary coding
#       (0/1) for condition allows straightforward interpretation:
#         - Positive correlation = module eigengene higher in tumor
#         - Negative correlation = module eigengene higher in normal
cat("\nStep 1: Defining trait (condition: tumor=1, normal=0)...\n")
trait <- data.frame(
  condition = ifelse(metadata$condition == "tumor", 1, 0)
)
rownames(trait) <- metadata$Sample
# Ensure rownames match datExpr
rownames(datExpr) <- metadata$Sample
cat("  Trait distribution: normal =", sum(trait$condition == 0),
    "| tumor =", sum(trait$condition == 1), "\n")

# ---- Step 2: Calculate module eigengenes -----------------------------------
# WHAT: Compute the module eigengene (ME) for each module — the first
#       principal component of the expression data within that module.
# WHY:  The eigengene is a compact summary of the module's expression profile.
#       Instead of tracking hundreds of genes individually, we track one
#       number (the eigengene) per module per sample. This reduces
#       dimensionality and enables module-level analysis.
cat("\nStep 2: Calculating module eigengenes...\n")
MEs <- moduleEigengenes(datExpr, moduleColors)
MEs_ordered <- orderMEs(MEs$eigengenes)
cat("  Eigengenes calculated for", ncol(MEs_ordered), "modules\n")

# ---- Step 3: Module-trait correlation --------------------------------------
# WHAT: Correlate each module eigengene with the trait (condition) using
#       Pearson correlation. Compute p-values and identify significant
#       module-trait relationships.
# WHY:  This is the KEY analysis linking co-expression modules to the
#       biological condition. A significant positive correlation means the
#       module is activated in tumors; a significant negative correlation
#       means it's suppressed.
cat("\nStep 3: Computing module-trait correlations...\n")

moduleTraitCor <- cor(MEs_ordered, trait, use = "p")
moduleTraitPvalue <- corPvalueStudent(moduleTraitCor, nrow(datExpr))

# Combine into a results table
module_names <- gsub("^ME", "", colnames(MEs_ordered))
module_trait_results <- data.frame(
  module = module_names,
  cor_condition = moduleTraitCor[, 1],
  pvalue = moduleTraitPvalue[, 1]
)
module_trait_results$padj <- p.adjust(module_trait_results$pvalue, method = "BH")
module_trait_results$significant <- module_trait_results$padj < 0.05 & abs(module_trait_results$cor_condition) > 0.5

# Sort by absolute correlation
module_trait_results <- module_trait_results[order(-abs(module_trait_results$cor_condition)), ]

cat("  Module-trait correlations:\n")
print(module_trait_results[, c("module", "cor_condition", "pvalue", "padj", "significant")],
      row.names = FALSE)

# Identify significant modules
sig_modules <- module_trait_results$module[module_trait_results$significant]
cat("\n  Significant modules (|r| > 0.5, padj < 0.05):", length(sig_modules), "\n")
if (length(sig_modules) > 0) cat("  ", paste(sig_modules, collapse = ", "), "\n")

# ---- Step 4: Module-trait heatmap ------------------------------------------
# WHAT: Heatmap showing the correlation between each module eigengene and
#       the trait, colored by correlation strength and annotated with
#       p-values.
# WHY:  This is the canonical WGCNA visualization for module-trait
#       relationships. It provides a compact overview of which modules
#       are associated with the condition.
cat("\nStep 4: Generating module-trait heatmap...\n")

# Prepare text labels (correlation and p-value)
textMatrix <- paste(
  signif(moduleTraitCor[, 1], 2),
  "\n(",
  signif(moduleTraitPvalue[, 1], 1),
  ")",
  sep = ""
)
dim(textMatrix) <- dim(moduleTraitCor)

# Use ComplexHeatmap for a publication-quality figure
# Color scale: blue (negative) to white (0) to red (positive)
col_fun <- colorRamp2(c(-1, 0, 1), c("#0279EE", "white", "#FF9400"))

# Row order matches MEs_ordered (already ordered by clustering)
row_anno <- rowAnnotation(
  Module = module_names,
  col = list(Module = setNames(
    WGCNA::labels2colors(as.numeric(gsub("[A-Za-z]", "", module_names))),
    # Simpler: use the module names directly as colors
    module_names
  ))
)

# Build the heatmap
# Use base R for the canonical WGCNA module-trait plot
png("figures/wgcna_module_trait_heatmap.png", width = 7, height = 9, units = "in", res = 300)
par(mar = c(4, 8, 3, 3))
labeledHeatmap(
  Matrix = moduleTraitCor,
  xLabels = "Condition (tumor vs normal)",
  yLabels = module_names,
  ySymbols = module_names,
  colorLabels = TRUE,
  colors = blueWhiteRed(50),
  textMatrix = textMatrix,
  setStdMargins = FALSE,
  cex.text = 0.8,
  cex.lab = 1.0,
  main = "Module-Trait Relationships"
)
dev.off()
cat("  Saved figures/wgcna_module_trait_heatmap.png\n")

# ---- Step 5: Calculate intramodular connectivity and module membership ----
# WHAT: For each gene, compute:
#       (a) kWithin (intramodular connectivity): sum of adjacencies to other
#           genes in the same module. High kWithin = hub gene.
#       (b) MM (module membership): correlation between the gene's expression
#           and the module eigengene. High |MM| = strong module membership.
# WHY:  Hub genes are identified by combining kWithin and MM. A gene with
#       high kWithin AND high |MM| is a central member of its module — a
#       candidate key regulator. These are the genes to prioritize for
#       experimental validation.
cat("\nStep 5: Calculating intramodular connectivity and module membership...\n")

# Intramodular connectivity (using the soft power adjacency)
adjacency <- adjacency(datExpr, power = power_selected, type = "signed")
kWithin <- intramodularConnectivity(adjacency, moduleColors)

# Module membership (correlation with eigengene)
# For each gene, compute MM for each module
geneModuleMembership <- as.data.frame(cor(datExpr, MEs_ordered, use = "p"))
MMPvalue <- as.data.frame(corPvalueStudent(as.matrix(geneModuleMembership), nrow(datExpr)))

# Build gene-level results table
gene_results <- data.frame(
  gene = colnames(datExpr),
  module = moduleColors,
  kWithin = kWithin$kWithin,
  stringsAsFactors = FALSE
)


# Add MM for the gene's own module
gene_results$MM <- sapply(seq_len(nrow(gene_results)), function(i) {
  me_col <- paste0("ME", gene_results$module[i])
  if (me_col %in% colnames(geneModuleMembership)) {
    geneModuleMembership[i, me_col]
  } else {
    NA
  }
})

# Combined hub score: kWithin * |MM|
gene_results$hub_score <- gene_results$kWithin * abs(gene_results$MM)

cat("  Connectivity and membership calculated for", nrow(gene_results), "genes\n")

# ---- Step 6: Identify hub genes per significant module ---------------------
# WHAT: For each significant module, identify the top 10 hub genes by
#       hub_score (kWithin * |MM|).
# WHY:  Hub genes are the most connected and central genes in a module.
#       They are candidate key regulators of the module's biological program
#       and the best targets for experimental validation.
cat("\nStep 6: Identifying hub genes in significant modules...\n")

hub_genes_list <- list()
if (length(sig_modules) > 0) {
  for (mod in sig_modules) {
    mod_genes <- gene_results[gene_results$module == mod, ]
    mod_genes <- mod_genes[order(-mod_genes$hub_score), ]
    top_hubs <- head(mod_genes, 10)
    hub_genes_list[[mod]] <- top_hubs
    cat("  Module", mod, ":", nrow(mod_genes), "genes | Top hub:",
        top_hubs$gene[1], "(hub_score =", round(top_hubs$hub_score[1], 2), ")\n")
  }

  # Combine all hub genes into one table
  hub_genes_df <- do.call(rbind, hub_genes_list)
  hub_genes_df$rank <- ave(hub_genes_df$hub_score, hub_genes_df$module, FUN = seq_along)
  write.csv(hub_genes_df, "tables/wgcna_hub_genes.csv", row.names = FALSE)
  cat("  Saved tables/wgcna_hub_genes.csv\n")
} else {
  cat("  No significant modules found. Using top 3 modules by |cor| instead.\n")
  top3_mods <- head(module_trait_results$module, 3)
  for (mod in top3_mods) {
    mod_genes <- gene_results[gene_results$module == mod, ]
    mod_genes <- mod_genes[order(-mod_genes$hub_score), ]
    hub_genes_list[[mod]] <- head(mod_genes, 10)
  }
  hub_genes_df <- do.call(rbind, hub_genes_list)
  hub_genes_df$rank <- ave(hub_genes_df$hub_score, hub_genes_df$module, FUN = seq_along)
  write.csv(hub_genes_df, "tables/wgcna_hub_genes.csv", row.names = FALSE)
  sig_modules <- top3_mods
  cat("  Saved tables/wgcna_hub_genes.csv (top 3 modules by |cor|)\n")
}

# ---- Step 7: Export eigengenes and module-trait results --------------------
cat("\nStep 7: Exporting eigengenes and module-trait results...\n")

# Eigengenes per sample
eigengenes_df <- data.frame(
  Sample = rownames(MEs_ordered),
  MEs_ordered,
  check.names = FALSE
)
write.csv(eigengenes_df, "tables/wgcna_eigengenes.csv", row.names = FALSE)
cat("  Saved tables/wgcna_eigengenes.csv\n")

# Module-trait correlations
write.csv(module_trait_results, "tables/wgcna_module_trait_cor.csv", row.names = FALSE)
cat("  Saved tables/wgcna_module_trait_cor.csv\n")

# Save RDS
saveRDS(gene_results, "data/wgcna_gene_results.rds")
saveRDS(MEs_ordered, "data/wgcna_eigengenes.rds")
saveRDS(module_trait_results, "data/wgcna_module_trait.rds")
cat("  Saved RDS objects\n")

# ---- Step 8: Hub genes barplot ---------------------------------------------
# WHAT: Barplot showing the top hub genes (by hub_score) for the most
#       significant module(s).
# WHY:  Visualizes which genes are the central hubs of the biologically
#       relevant modules — these are the candidate key regulators.
cat("\nStep 8: Generating hub genes barplot...\n")

# Use the top significant module (or top by |cor|)
top_mod <- sig_modules[1]
top_mod_hubs <- hub_genes_list[[top_mod]]
top_mod_hubs$gene <- factor(top_mod_hubs$gene, levels = rev(top_mod_hubs$gene))

hub_barplot <- ggplot(top_mod_hubs, aes(x = gene, y = hub_score, fill = module)) +
  geom_col() +
  coord_flip() +
  scale_fill_manual(values = setNames(top_mod, top_mod)) +
  labs(
    title = paste("Top 10 Hub Genes:", top_mod, "Module"),
    subtitle = paste("Module-trait r =", round(module_trait_results$cor_condition[module_trait_results$module == top_mod], 3)),
    x = NULL,
    y = "Hub Score (kWithin x |MM|)"
  ) +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"),
        plot.subtitle = element_text(hjust = 0.5))

ggsave("figures/wgcna_hub_genes_barplot.png", hub_barplot, width = 8, height = 6, dpi = 300)
cat("  Saved figures/wgcna_hub_genes_barplot.png (module:", top_mod, ")\n")

# ---- Step 9: Eigengene heatmap ----------------------------------------------
# WHAT: Heatmap of module eigengenes across samples, with condition annotation.
# WHY:  Shows how each module's eigengene varies across tumor vs. normal
#       samples. Modules correlated with condition should show clear
#       separation between tumor and normal.
cat("\nStep 9: Generating eigengene heatmap...\n")

# Prepare eigengene matrix for heatmap
me_mat <- t(MEs_ordered)
colnames(me_mat) <- metadata$Sample

# Annotation
annotation_col <- data.frame(
  condition = metadata$condition,
  row.names = metadata$Sample
)
ann_colors <- list(condition = c("normal" = "#0279EE", "tumor" = "#FF9400"))

# Color scale
colors_heat <- colorRampPalette(rev(c("#FF9400", "white", "#0279EE")))(100)

png("figures/wgcna_eigengene_heatmap.png", width = 10, height = 7, units = "in", res = 300)
pheatmap(
  me_mat,
  annotation_col = annotation_col,
  annotation_colors = ann_colors,
  col = colors_heat,
  cluster_cols = TRUE,
  cluster_rows = TRUE,
  show_colnames = FALSE,
  fontsize_row = 8,
  main = "Module Eigengenes Across Samples"
)
dev.off()
cat("  Saved figures/wgcna_eigengene_heatmap.png\n")

# ---- Step 10: Cross-reference with DE results ------------------------------
# WHAT: Check how many DE genes (from Script 03) fall into each module.
# WHY:  This cross-validation reveals whether DE genes cluster into specific
#       modules. If a module is both (a) correlated with tumor status AND
#       (b) enriched for DE genes, it represents a robust PDAC program.
cat("\nStep 10: Cross-referencing modules with DE results...\n")

res_shrunk <- readRDS("data/deseq2_res_shrunk.rds")
sig_de <- res_shrunk[which(res_shrunk$padj < 0.05 & abs(res_shrunk$log2FoldChange) >= 1), ]
sig_de_genes <- rownames(sig_de)

# Count DE genes per module
module_de_overlap <- data.frame(
  module = unique(moduleColors),
  total_genes = as.numeric(table(moduleColors)[unique(moduleColors)]),
  de_genes = sapply(unique(moduleColors), function(m) {
    sum(colnames(datExpr)[moduleColors == m] %in% sig_de_genes)
  })
)
module_de_overlap$de_fraction <- module_de_overlap$de_genes / module_de_overlap$total_genes
module_de_overlap <- module_de_overlap[order(-module_de_overlap$de_fraction), ]

cat("  DE gene overlap by module (top 5 by fraction):\n")
print(head(module_de_overlap, 5), row.names = FALSE)

write.csv(module_de_overlap, "tables/wgcna_module_de_overlap.csv", row.names = FALSE)
cat("  Saved tables/wgcna_module_de_overlap.csv\n")

