# RNA-seq Analysis in R (Part 4): Visualizing Differential Expression Results

# 1. Install and load packages
pak::pkg_install(c("tidyverse", "tximport", "DESeq2", "EnsDb.Hsapiens.v86", "pheatmap", "RColorBrewer", "apeglm", "ggrepel"))

library(tidyverse)
library(tximport)
library(DESeq2)
library(EnsDb.Hsapiens.v86)
library(pheatmap)
library(RColorBrewer)
library(apeglm)
library(ggrepel)

# 2. Load the fitted DESeqDataSet and significant genes 
dds <- read_rds("outputs/tables/GSE245922_dds_deseq.rds")
sig <- read_rds("outputs/tables/GSE245922_sig_covid19_vs_control.rds")

# Results table for our main contrast (covid19 vs control)
res_tb <- results(dds, contrast = c("condition", "covid19", "control"), alpha = 0.05) |>
  as.data.frame() |> 
  rownames_to_column("gene") |> 
  as_tibble()

# Normalized counts as a tibble with a "gene" column (rows are already symbols)
normalized_counts <- counts(dds, normalized = TRUE) |>
  as.data.frame() |> 
  rownames_to_column("gene") |> 
  as_tibble()

# 3. Single-gene expression plot — replace with a gene you actually care about
gene_of_interest <- "CXCL10"   # example: interferon-stimulated gene, adjust as needed

d <- plotCounts(dds, gene = gene_of_interest, intgroup = "condition", returnData = TRUE)

p_gene <- ggplot(d, aes(x = condition, y = count, color = condition)) +
  geom_point(position = position_jitter(w = 0.1, h = 0)) +
  geom_text_repel(aes(label = rownames(d)), size = 3) +
  ggtitle(gene_of_interest) + theme_bw() +
  theme(plot.title = element_text(hjust = 0.5))
ggsave("outputs/figures/GSE245922_gene_CXCL10.png", p_gene, width = 7, height = 5, dpi = 300)


# 4. Heatmap of significant genes
# Metadata to annotate columns
meta <- as.data.frame(colData(dds)[, "condition", drop = FALSE])

# Normalized expression matrix for the significant genes, those samples only
sig_mat <- normalized_counts |>
  dplyr::filter(gene %in% sig$gene) |>
  column_to_rownames("gene") |> 
  as.matrix()

pheatmap(sig_mat, color = brewer.pal(6, "YlOrRd"), cluster_rows = TRUE,
         show_rownames = FALSE, annotation = meta, border_color = NA,
         scale = "row", fontsize = 10,
         filename = "outputs/figures/GSE245922_significant_genes_heatmap.png")

# 5. Volcano plot with top-10 labels
# Flag genes that pass BOTH padj < 0.05 and |log2FC| >= log2(1.5)
res_tb <- res_tb |> 
  dplyr::mutate(threshold = padj < 0.05 & abs(log2FoldChange) >= log2(1.5))

# Label the 10 most significant genes (smallest padj)
top10 <- res_tb |> 
  dplyr::arrange(padj) |> 
  dplyr::slice(1:10) |> 
  dplyr::pull(gene)

res_tb <- res_tb |> 
  dplyr::mutate(genelabel = if_else(gene %in% top10, gene, ""))

p_volcano <- ggplot(res_tb, aes(x = log2FoldChange, y = -log10(padj))) +
  geom_point(aes(colour = threshold), alpha = 0.6) +
  scale_colour_manual(values = c("grey70", "firebrick"), na.value = "grey70") +
  geom_text_repel(aes(label = genelabel), size = 3, max.overlaps = Inf) +
  ggtitle("COVID-19 vs Control") + xlab("log2 fold change") + ylab("-log10 padj") +
  theme_bw() + theme(legend.position = "none", plot.title = element_text(size = rel(1.4), hjust = 0.5))
ggsave("outputs/figures/GSE245922_volcano_covid19_vs_control.png", p_volcano,
       width = 7, height = 6, dpi = 300)
