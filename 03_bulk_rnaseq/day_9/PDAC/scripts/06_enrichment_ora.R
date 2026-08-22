# =============================================================================
# Script 06: ORA (Over-Representation Analysis) with clusterProfiler
# =============================================================================
# WHAT: Perform ORA on up- and down-regulated significant gene sets separately,
#       using the hypergeometric test (enricher function) with MSigDB
#       Hallmark + Reactome gene sets. Generate barplots for each direction.
#
# WHY:  ORA is the SECONDARY enrichment method, used to VALIDATE GSEA findings
#       with an independent statistical framework. While GSEA uses the full
#       ranked gene list (no cutoff), ORA uses only the significant genes
#       (padj < 0.05, |log2FC| >= 1) and tests whether pathway members are
#       over-represented among them using the hypergeometric test.
#
#       Running BOTH methods teaches students about:
#       - Method agreement: pathways significant in both GSEA and ORA are
#         the most robust findings
#       - Method disagreement: GSEA can detect coordinated weak shifts that
#         ORA misses (no single gene passes the cutoff); ORA can highlight
#         pathways driven by a few very strong genes that GSEA ranks lower
#       - The importance of the background/universe gene set in ORA
#
#       Separating up- and down-regulated genes reveals direction-specific
#       biology: which pathways are activated vs. suppressed in tumors.
#
# BIOLOGICAL CONTEXT:
#   Upregulated ORA: pathways enriched among genes HIGHER in PDAC tumor
#     (e.g., immune response, EMT, cell cycle, stromal remodeling)
#   Downregulated ORA: pathways enriched among genes LOWER in PDAC tumor
#     (e.g., pancreatic acinar function, digestive enzyme secretion, normal
#     metabolic processes)
#   Comparing with GSEA results validates which pathway-level shifts are
#   driven by strongly DE genes vs. coordinated weak changes.
#
# KEY TEACHING POINTS:
#   - Hypergeometric test: drawing significant genes from the "urn" of all
#     tested genes; tests if pathway members are over-represented
#   - Background/universe: MUST be all tested genes (not all human genes),
#     otherwise p-values are inflated
#   - Why cutoff-based methods can miss coordinated weak signals
#   - GSEA vs. ORA agreement and disagreement
#   - Direction-specific enrichment (up vs. down separately)
# =============================================================================

suppressPackageStartupMessages({
  library(clusterProfiler)
  library(enrichplot)
  library(msigdbr)
  library(ggplot2)
  library(org.Hs.eg.db)
})

# ---- Configuration ----------------------------------------------------------
fig_dir   <- "figures"
table_dir <- "tables"

# ---- Load DESeq2 results from Script 03 ------------------------------------
cat("Loading DESeq2 shrunk results...\n")
res_shrunk <- readRDS("data/deseq2_res_shrunk.rds")
gene_mapping <- readRDS("data/gene_mapping.rds")
cat("  Loaded", nrow(res_shrunk), "genes from DESeq2 results\n")

# ---- Step 1: Filter significant genes into up/down sets --------------------
# WHAT: Split significant genes (padj < 0.05, |log2FC| >= 1) into upregulated
#       and downregulated sets. Convert to Entrez IDs for MSigDB matching.
# WHY:  ORA requires a defined gene list (not a ranking). The padj < 0.05 and
#       |log2FC| >= 1 thresholds are standard: they select genes that are
#       both statistically significant AND have a biologically meaningful
#       fold change. Separating up/down reveals direction-specific pathways.
cat("\nStep 1: Filtering significant genes into up/down sets...\n")

res_df <- as.data.frame(res_shrunk)
res_df$symbol <- rownames(res_df)
res_df$entrez_id <- gene_mapping$entrez_id[match(res_df$symbol, gene_mapping$symbol)]

# Define significance thresholds
padj_cutoff  <- 0.05
lfc_cutoff   <- 1

# Universe = all genes with Entrez ID and a p-value (the background for ORA)
universe <- res_df$entrez_id[!is.na(res_df$entrez_id) & !is.na(res_df$pvalue)]
universe <- unique(as.character(universe))
cat("  Universe (background):", length(universe), "genes\n")

# Upregulated: padj < 0.05, log2FC >= 1
up_genes <- res_df$entrez_id[!is.na(res_df$padj) & res_df$padj < padj_cutoff &
                               res_df$log2FoldChange >= lfc_cutoff & !is.na(res_df$entrez_id)]
up_genes <- unique(as.character(up_genes))
cat("  Upregulated genes:", length(up_genes), "\n")

# Downregulated: padj < 0.05, log2FC <= -1
down_genes <- res_df$entrez_id[!is.na(res_df$padj) & res_df$padj < padj_cutoff &
                                 res_df$log2FoldChange <= -lfc_cutoff & !is.na(res_df$entrez_id)]
down_genes <- unique(as.character(down_genes))
cat("  Downregulated genes:", length(down_genes), "\n")

# ---- Step 2: Retrieve MSigDB gene sets -------------------------------------
# WHAT: Download Hallmark + Reactome gene sets (same as GSEA for consistency)
# WHY:  Using the same gene sets as GSEA enables direct comparison of results.
cat("\nStep 2: Retrieving MSigDB gene sets (Hallmark + Reactome)...\n")

h_sets <- msigdbr(species = "Homo sapiens", collection = "H")
reactome_sets <- msigdbr(species = "Homo sapiens", collection = "C2", subcollection = "CP:REACTOME")

term2gene <- rbind(
  h_sets[, c("gs_name", "ncbi_gene")],
  reactome_sets[, c("gs_name", "ncbi_gene")]
)
colnames(term2gene) <- c("term", "gene")
term2gene$gene <- as.character(term2gene$gene)
term2gene <- unique(term2gene)
cat("  Total gene sets:", length(unique(term2gene$term)), "\n")

# ---- Step 3: Run ORA for upregulated genes ---------------------------------
# WHAT: Use clusterProfiler::enricher to test whether MSigDB pathway members
#       are over-represented among upregulated genes, using the hypergeometric
#       test with the full tested gene set as background.
# WHY:  The hypergeometric test asks: "If I draw N genes at random from the
#       universe, what is the probability of seeing K or more genes from
#       pathway X?" If this probability is low (p < 0.05), the pathway is
#       over-represented. The universe MUST be all tested genes, not all
#       human genes — otherwise p-values are inflated.
cat("\nStep 3: Running ORA for upregulated genes...\n")

ora_up <- enricher(
  gene         = up_genes,
  universe     = universe,
  TERM2GENE    = term2gene,
  pvalueCutoff = 0.05,
  pAdjustMethod = "BH",
  qvalueCutoff = 0.2
)
ora_up_df <- as.data.frame(ora_up)
cat("  Enriched pathways (upregulated, padj < 0.05):", nrow(ora_up_df), "\n")

# ---- Step 4: Run ORA for downregulated genes -------------------------------
cat("\nStep 4: Running ORA for downregulated genes...\n")

ora_down <- enricher(
  gene         = down_genes,
  universe     = universe,
  TERM2GENE    = term2gene,
  pvalueCutoff = 0.05,
  pAdjustMethod = "BH",
  qvalueCutoff = 0.2
)
ora_down_df <- as.data.frame(ora_down)
cat("  Enriched pathways (downregulated, padj < 0.05):", nrow(ora_down_df), "\n")

# ---- Step 5: Export ORA results --------------------------------------------
cat("\nStep 5: Exporting ORA results...\n")

if (nrow(ora_up_df) > 0) {
  write.csv(ora_up_df, file.path(table_dir, "enrichment_ora_up_results.csv"), row.names = FALSE)
  cat("  Saved tables/enrichment_ora_up_results.csv\n")
}
if (nrow(ora_down_df) > 0) {
  write.csv(ora_down_df, file.path(table_dir, "enrichment_ora_down_results.csv"), row.names = FALSE)
  cat("  Saved tables/enrichment_ora_down_results.csv\n")
}
saveRDS(ora_up, file.path(table_dir, "enrichment_ora_up_result.rds"))
saveRDS(ora_down, file.path(table_dir, "enrichment_ora_down_result.rds"))
cat("  Saved RDS objects\n")

# Print top results
if (nrow(ora_up_df) > 0) {
  cat("\n  Top 10 upregulated ORA results:\n")
  print(head(ora_up_df[, c("ID", "p.adjust", "Count")], 10), row.names = FALSE)
}
if (nrow(ora_down_df) > 0) {
  cat("\n  Top 10 downregulated ORA results:\n")
  print(head(ora_down_df[, c("ID", "p.adjust", "Count")], 10), row.names = FALSE)
}

# ---- Step 6: Generate ORA barplots -----------------------------------------
# WHAT: Generate barplots showing the top enriched pathways for up- and
#       down-regulated genes, colored by p-value, sized by gene count.
# WHY:  Barplots provide a compact, intuitive visualization of ORA results.
#       The number of genes in each pathway (Count) and the significance
#       (p-value) are the key metrics to communicate.
cat("\nStep 6: Generating ORA barplots...\n")

# 6a. Upregulated barplot
if (nrow(ora_up_df) > 0) {
  # Prepare data for barplot (top 15 by p.adjust)
  ora_up_plot <- head(ora_up_df[order(ora_up_df$p.adjust), ], 15)
  ora_up_plot$ID <- factor(ora_up_plot$ID, levels = rev(ora_up_plot$ID))

  up_barplot <- ggplot(ora_up_plot, aes(x = ID, y = Count, fill = p.adjust)) +
    geom_col() +
    coord_flip() +
    scale_fill_gradient(low = "#FF9400", high = "#FAF9F3") +
    labs(
      title = "ORA: Upregulated Pathways in PDAC Tumor",
      x = NULL,
      y = "Gene Count",
      fill = "adj. p-value"
    ) +
    theme_minimal(base_size = 11) +
    theme(plot.title = element_text(hjust = 0.5, face = "bold"))

  ggsave(file.path(fig_dir, "enrichment_ora_up_barplot.png"), up_barplot,
         width = 10, height = 7, dpi = 300)
  cat("  Saved figures/enrichment_ora_up_barplot.png\n")
}

# 6b. Downregulated barplot
if (nrow(ora_down_df) > 0) {
  ora_down_plot <- head(ora_down_df[order(ora_down_df$p.adjust), ], 15)
  ora_down_plot$ID <- factor(ora_down_plot$ID, levels = rev(ora_down_plot$ID))

  down_barplot <- ggplot(ora_down_plot, aes(x = ID, y = Count, fill = p.adjust)) +
    geom_col() +
    coord_flip() +
    scale_fill_gradient(low = "#0279EE", high = "#ECE9E2") +
    labs(
      title = "ORA: Downregulated Pathways in PDAC Tumor",
      x = NULL,
      y = "Gene Count",
      fill = "adj. p-value"
    ) +
    theme_minimal(base_size = 11) +
    theme(plot.title = element_text(hjust = 0.5, face = "bold"))

  ggsave(file.path(fig_dir, "enrichment_ora_down_barplot.png"), down_barplot,
         width = 10, height = 7, dpi = 300)
  cat("  Saved figures/enrichment_ora_down_barplot.png\n")
}