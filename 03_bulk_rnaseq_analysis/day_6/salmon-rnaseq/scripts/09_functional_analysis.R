# RNA-seq Analysis in R (Part 5): Functional Analysis
# part 1 : GSEA + KEGG pathway visualization

#1. Install & load packages
BiocManager::install(c("clusterProfiler", "org.Hs.eg.db", "pathview", "DOSE", "enrichplot", "ggnewscale"))

library(tidyverse)
library(clusterProfiler)
library(org.Hs.eg.db)
library(pathview)
library(DOSE)
library(enrichplot)
library(ggnewscale)

# 2. Build the ranked fold-change vector (Entrez-named)
res <- read.csv("outputs/tables/GSE245922_deseq2_results.csv")

# Map our gene SYMBOLs to Entrez IDs (KEGG needs Entrez)
map <- bitr(res$gene, fromType = "SYMBOL", toType = "ENTREZID", OrgDb = org.Hs.eg.db)

res_entrez <- res  |> 
  dplyr::inner_join(map, by = c("gene" = "SYMBOL")) |> 
  dplyr::filter(!is.na(ENTREZID), !is.na(log2FoldChange)) |> 
  dplyr::distinct(ENTREZID, .keep_all = TRUE)   # drop duplicate Entrez IDs

# Named vector of fold changes, sorted decreasing (required by GSEA)
foldchanges <- res_entrez$log2FoldChange
names(foldchanges) <- res_entrez$ENTREZID
foldchanges <- sort(foldchanges, decreasing = TRUE)
head(foldchanges)

# 3. Run GSEA against KEGG pathways
set.seed(123456)   # permutations are random; seed makes results reproducible
gseaKEGG <- gseKEGG(geneList     = foldchanges,
                    organism     = "hsa",
                    minGSSize    = 20,
                    pvalueCutoff = 0.05,
                    verbose      = FALSE)

gseaKEGG_results <- gseaKEGG@result
head(gseaKEGG_results)
write.csv(gseaKEGG_results, "outputs/tables//GSE245922_gsea_kegg_covid19_vs_control.csv",
          row.names = FALSE)

# 4. Enrichment plot + Pathview for the top pathway
if (nrow(gseaKEGG_results) > 0) {
  top_pathway <- gseaKEGG_results$ID[1]
  
  p_gsea <- gseaplot(gseaKEGG, geneSetID = top_pathway)
  ggsave(paste0("outputs/figures/GSE245922_gsea_", top_pathway, ".png"),
         p_gsea, width = 8, height = 6, dpi = 300)
  
  # Pathview: overlay our fold changes on the KEGG pathway diagram
  # Pathview writes PNG files into the WORKING DIRECTORY (not the plot window).
  # limit sets the max/min fold-change for the colour scale.
  pathview(gene.data = foldchanges, 
           pathway.id = top_pathway,
           species = "hsa", 
           limit = list(gene = 2, cpd = 1))
  message("Pathview image written to working dir: ", top_pathway, ".pathview.png")
} else {
  message("No KEGG pathways passed the GSEA cutoff.")
}


# Part 2 : GO Over-Representation Analysis (ORA)

# 5. Load results and build gene lists (reuse res_entrez pipeline's source data)
res_tested <- res |> dplyr::filter(!is.na(padj))

# Background ("universe") = all tested genes
all_genes <- res_tested |> 
  pull(gene) |> 
  unique()

# Significant genes (padj < 0.05)
sig <- res_tested |> dplyr::filter(padj < 0.05)

sig_genes <- sig |> 
  pull(gene) |> 
  unique()

# 6. GO over-representation analysis (Biological Process)
# Hypergeometric test: are any GO BP terms over-represented in sig vs background?
ego <- enrichGO(gene          = sig_genes,
                universe      = all_genes,
                keyType       = "SYMBOL",       # our genes are symbols
                OrgDb         = org.Hs.eg.db,
                ont           = "BP",           # Biological Process
                pAdjustMethod = "BH",
                qvalueCutoff  = 0.05,
                readable      = TRUE)

cluster_summary <- as.data.frame(ego)
head(cluster_summary)

write.csv(cluster_summary, "outputs/tables/GSE245922_GO_ORA_covid19_vs_control.csv", row.names = FALSE)
save(ego, file = "outputs/tables/GSE245922_ego.rda")       # save object for reloading

# 7. Visualizations
# Dotplot: top 30 terms (dot size = gene count, colour = adjusted p-value)
p_dot <- dotplot(ego, showCategory = 20) +
  ggtitle("GO BP enrichment (COVID-19 vs Control)")
ggsave("outputs/figures/GSE245922_GO_ORA_dotplot.png", p_dot, width = 8, height = 12, dpi = 300)

# Enrichment map: clusters similar GO terms together
ego_sim <- enrichplot::pairwise_termsim(ego)
p_emap <- emapplot(ego_sim, showCategory = 20)
ggsave("outputs/figures/GSE245922_GO_ORA_emapplot.png", p_emap, width = 10, height = 10, dpi = 300)

# Category netplot: genes linked to the top 5 terms, coloured by fold change
foldchanges_go <- sig$log2FoldChange
names(foldchanges_go) <- sig$gene

# cap extremes so colours aren't washed out
foldchanges_go <- pmin(pmax(foldchanges_go, -2), 2)

p_cnet <- cnetplot(ego, showCategory = 5, foldChange = foldchanges_go)
ggsave("outputs/figures/GSE245922_GO_ORA_cnetplot.png", p_cnet, width = 10, height = 10, dpi = 300)




