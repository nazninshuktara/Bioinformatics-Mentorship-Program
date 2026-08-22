# Script 05: GSEA (Gene Set Enrichment Analysis) with clusterProfiler
# =============================================================================
# WHAT: Perform GSEA on the ranked DESeq2 results to identify biological
#       pathways that are coordinately up- or down-regulated in PDAC tumors.
#       Uses MSigDB Hallmark + Reactome gene sets via msigdbr.
#
# WHY:  GSEA is the PRIMARY enrichment method because it uses the FULL ranked
#       gene list (no arbitrary cutoff), detecting coordinated but modest
#       expression changes across pathway members. This is more sensitive
#       than ORA for detecting pathway-level shifts, especially when
#       individual genes have small fold changes but the pathway as a whole
#       shifts significantly.
#
#       Hallmark + Reactome gene sets are used because:
#       - Hallmark: 50 curated, non-redundant pathways representing
#         well-defined biological states (e.g., EMT, inflammatory response)
#       - Reactome: curated, peer-reviewed pathway database
#       - Both are CC-BY 4.0 licensed (commercially safe; KEGG excluded
#         due to commercial license restrictions)
#
# BIOLOGICAL CONTEXT:
#   In PDAC, we expect GSEA to reveal:
#   - UPREGULATED: KRAS signaling, EMT, cell cycle/proliferation, stromal
#     activation, immune response (tumor microenvironment)
#   - DOWNREGULATED: pancreatic acinar cell function (digestive enzymes),
#     normal pancreas metabolic pathways
#   These pathway-level shifts capture the biological programs driving PDAC,
#   complementing the single-gene DE view.
#
# KEY TEACHING POINTS:
#   - GSEA algorithm: running enrichment score, leading edge genes
#   - Why ranking metric matters (signed statistic vs. log2FC alone)
#   - NES (normalized enrichment score): corrects for gene set size
#   - Permutation-based p-values (gene set permutations)
#   - FDR correction (BH method across all tested gene sets)
#   - Leading edge genes: the genes that drive the enrichment signal
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
res_shrunk <- readRDS("data/deseq2_res_shrunk.rds")
gene_mapping <- readRDS("data/gene_mapping.rds")

# ---- Step 1: Prepare ranked gene list --------------------------------------
# WHAT: Create a named, sorted numeric vector ranking all genes. The ranking
#       metric is the signed -log10(p-value): sign(log2FC) * -log10(pvalue).
#       This combines statistical significance (p-value) with direction
#       (sign of fold change), producing a ranking where:
#         - Most significant upregulated genes are at the top (positive)
#         - Most significant downregulated genes are at the bottom (negative)
# WHY:  The ranking metric is the most important GSEA parameter. Using
#       log2FC alone ignores significance (noisy low-count genes get extreme
#       fold changes). Using p-value alone ignores direction. The signed
#       -log10(pvalue) combines both, and is one of the recommended metrics
#       in the clusterProfiler documentation.
#       We use Entrez IDs because MSigDB gene sets (via msigdbr) can be
#       retrieved with Entrez IDs directly, avoiding ID mapping issues.

# The DESeq2 results have gene symbols as rownames (from Script 01).
# For GSEA with MSigDB, we need Entrez IDs. Map symbols back to Entrez.
res_df <- as.data.frame(res_shrunk)
res_df$symbol <- rownames(res_df)

# Map symbols to Entrez IDs using gene_mapping (from Script 01)
# gene_mapping has: entrez_id, symbol, genename
res_df$entrez_id <- gene_mapping$entrez_id[match(res_df$symbol, gene_mapping$symbol)]

# Remove genes without Entrez ID mapping or without p-values
res_df <- res_df[!is.na(res_df$entrez_id) & !is.na(res_df$pvalue), ]

# Create ranking metric: sign(log2FC) * -log10(pvalue)
# WHY signed -log10(pvalue): combines significance with direction
res_df$rank_metric <- sign(res_df$log2FoldChange) * (-log10(res_df$pvalue))

# Create named vector (Entrez IDs as names), sorted descending
ranked_genes <- res_df$rank_metric
names(ranked_genes) <- res_df$entrez_id
ranked_genes <- sort(ranked_genes, decreasing = TRUE)

# Save ranked gene list
saveRDS(ranked_genes, file.path(table_dir, "enrichment_ranked_genes.rds"))

# ---- Step 2: Retrieve MSigDB gene sets -------------------------------------
# WHAT: Download Hallmark (H) and Reactome (C2:REACTOME) gene sets from
#       MSigDB via the msigdbr package. Use Entrez IDs for gene matching.
# WHY:  Hallmark provides 50 non-redundant, well-defined biological states.
#       Reactome provides curated, peer-reviewed pathways. Together they
#       cover core biological processes without the redundancy of GO (which
#       has thousands of overlapping terms). Both are CC-BY 4.0 licensed.
# Hallmark gene sets
h_sets <- msigdbr(species = "Homo sapiens", collection = "H")
cat("  Hallmark gene sets:", length(unique(h_sets$gs_name)), "pathways\n")

# Reactome gene sets (subcategory C2:CP:REACTOME)
reactome_sets <- msigdbr(species = "Homo sapiens", collection = "C2", subcollection = "CP:REACTOME")
cat("  Reactome gene sets:", length(unique(reactome_sets$gs_name)), "pathways\n")

# Combine into term2gene format (gs_name, ncbi_gene)
term2gene <- rbind(
  h_sets[, c("gs_name", "ncbi_gene")],
  reactome_sets[, c("gs_name", "ncbi_gene")]
)
colnames(term2gene) <- c("term", "gene")
term2gene$gene <- as.character(term2gene$gene)

# Remove duplicate rows
term2gene <- unique(term2gene)

# ---- Step 3: Run GSEA -------------------------------------------------------
# WHAT: Run GSEA using clusterProfiler::GSEA with:
#         - nPerm = 1000 (permutation-based p-values)
#         - pvalueCutoff = 0.05 (FDR threshold)
#         - minGSSize = 10, maxGSSize = 500 (gene set size filters)
# WHY:  GSEA computes a running enrichment score by walking down the ranked
#       list: when a gene is in the set, the score increases; when not, it
#       decreases. The maximum deviation from zero is the enrichment score
#       (ES). The ES is normalized for gene set size (NES) and assessed for
#       significance via permutation (shuffling gene labels in the set).
#       1000 permutations is the minimum recommended; more permutations
#       give more stable p-values but take longer.
set.seed(42)  # for reproducibility
gsea_result <- GSEA(
  geneList      = ranked_genes,
  TERM2GENE     = term2gene,
  nPerm         = 1000,
  minGSSize     = 10,
  maxGSSize     = 500,
  pvalueCutoff  = 0.05,
  pAdjustMethod = "BH",
  seed          = TRUE
)
cat("  Significant gene sets (padj < 0.05):", nrow(as.data.frame(gsea_result)), "\n")

# ---- Step 4: Export GSEA results -------------------------------------------
# WHAT: Save the full GSEA results table (all tested gene sets) and the
#       significant results.
gsea_df <- as.data.frame(gsea_result)

# Add direction labels
gsea_df$direction <- ifelse(gsea_df$NES > 0, "Activated (up in tumor)", "Suppressed (down in tumor)")

# Sort by padj
gsea_df <- gsea_df[order(gsea_df$p.adjust), ]

write.csv(gsea_df, file.path(table_dir, "enrichment_gsea_results.csv"), row.names = FALSE)

# Save RDS for downstream use
saveRDS(gsea_result, file.path(table_dir, "enrichment_gsea_result.rds"))

# Print top results
top_gsea <- head(gsea_df[, c("ID", "NES", "pvalue", "p.adjust", "direction")], 10)
print(top_gsea, row.names = FALSE)

# ---- Step 5: Generate GSEA visualizations ----------------------------------
# WHAT: Generate two key GSEA plots:
#       (1) Dotplot: shows NES for top pathways, colored by p-value, sized
#           by gene set size. Faceted by direction (activated/suppressed).
#       (2) Running enrichment score plots: for the top 4 pathways, shows
#           the running ES, the ranked list position, and the leading edge.
# WHY:  The dotplot provides a compact overview of enriched pathways. The
#       running score plot is the canonical GSEA visualization — it shows
#       HOW the enrichment score accumulates as you walk down the ranked
#       list, and where the leading edge genes are located.

# 5a. Dotplot — top 20 pathways by padj
if (nrow(gsea_df) > 0) {
  # Prepare for dotplot: split by direction
  gsea_for_plot <- gsea_result
  # dotplot shows NES; we want both activated and suppressed
  dotplot_p <- dotplot(gsea_for_plot, showCategory = 20, split = ".sign") +
    scale_color_gradient(low = "#FF9400", high = "#0279EE") +
    labs(title = "GSEA: Top Pathways (Hallmark + Reactome)") +
    theme_minimal(base_size = 12) +
    theme(plot.title = element_text(hjust = 0.5, face = "bold"))

  ggsave(file.path(fig_dir, "enrichment_gsea_dotplot.png"), dotplot_p,
         width = 8, height = 16, dpi = 300)


  # 5b. Running score plots for top 4 pathways
  top_pathways <- head(gsea_df$ID, 4)
  if (length(top_pathways) > 0) {
    # Generate each running-score plot individually and save as a combined figure
    # gseaplot2 returns a patchwork/grob object; save each separately then combine
    png(file.path(fig_dir, "enrichment_gsea_running_score.png"),
        width = 14, height = 12, units = "in", res = 300)
    
    par(mfrow = c(2, 2))
    for (pid in top_pathways) {
      # Use base GSEA plotting via gseaplot2 for a single pathway
      p <- enrichplot::gseaplot2(gsea_result, geneSetID = pid,
                                 title = pid, pvalue_table = FALSE)
      print(p)
    }
    dev.off()
    cat("  Saved figures/enrichment_gsea_running_score.png (top 4 pathways)\n")
  }
} else {
  cat("  WARNING: No significant GSEA results to plot\n")
}
