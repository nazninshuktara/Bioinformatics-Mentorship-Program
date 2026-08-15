# Differential Expression Analysis in R: Salmon -> tximport -> DESeq2 -> Visualization
# Author: Md. Jubayer Hossain
# Affiliation: DeepBio Limited | CHIRAL Bangladesh
# Date: October 2025
# Description:
# Imports transcript-level quantifications from Salmon and summarizes to gene-level counts for DESeq2. 


#Step1:Environment Setup and Library Loading:

# Install Bioconductor Packages 
pak::pkg_install(c("tidyverse", "tximport", "DESeq2"))
# Install package
pak::pkg_install(c("EnhancedVolcano", "pheatmap", "PoiClaClu", "tidyplots"))

#BiocManager install
install.packages("BiocManager")
BiocManager::install("EnsDb.Hsapiens.v86")

# Load libraries
library(tidyverse)
library(tximport)
library(DESeq2)
library(EnsDb.Hsapiens.v86)
library(RColorBrewer)
library(EnhancedVolcano)
library(pheatmap)
library(PoiClaClu)
library(tidyplots)


#Step2.Data Processing & Import: Get the quant files and metadata

# Collect the sample quant files
samples <- list.dirs('D:/COVID19/GSE255647/output/salmon_out', recursive = FALSE, full.names = FALSE)
samples

# check quant files 
quant_files <- file.path('D:/COVID19/GSE255647/output/salmon_out', samples, 'quant.sf')
quant_files

# Ensure each file actually exists
# all should be TRUE
file.exists(quant_files)  

# Set up metadata frame
# Metadata for DESeq2: https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE255647
# GSE255647: SARS-CoV-1 and SARS-CoV-2 infection in Calu-3/2B4 cells
# Conditions: Mock (control), SARS-CoV-1, SARS-CoV-2
# Time points: 12 hpi, 24 hpi, 48 hpi
# Replicates: 3 per condition per time point (total 27 samples)
col_data <- data.frame(
  row.names = samples,
  condition = factor(rep(c("SARS1", "SARS2", "Mock"), each = 9), 
                     levels = c("Mock", "SARS1", "SARS2")),
  timepoint = factor(rep(rep(c("12hpi", "24hpi", "48hpi"), each = 3), 3),
                     levels = c("12hpi", "24hpi", "48hpi")))

# Set reference level — Mock is the control group
col_data$condition <- factor(col_data$condition, 
                             levels = c("Mock", "SARS1", "SARS2"))

# Verify metadata
print(col_data)
print(table(col_data$condition, col_data$timepoint))


#Step3. Transcript to Gene Mapping

# Get the mapping from transcript IDs to gene symbols 
# What are the columns in the database?
columns(EnsDb.Hsapiens.v86)
keys(EnsDb.Hsapiens.v86)

# Get the TXID and SYMBOL columns for all entries in database
tx2gene <- AnnotationDbi::select(EnsDb.Hsapiens.v86, 
                                 keys = keys(EnsDb.Hsapiens.v86),
                                 columns = c('TXID', 'SYMBOL'))
# check tx2gene 
head(tx2gene)

# Remove the gene ID column
tx2gene <- dplyr::select(tx2gene, -GENEID)
head(tx2gene)


#Step4: Gene-level Summarization

# Compile the tximport counts object and make DESeq dataset
# Get tximport counts object
txi <- tximport(files = quant_files, 
                type = 'salmon',
                tx2gene = tx2gene,
                ignoreTxVersion = TRUE)

# class of txi 
class(txi)

# explore raw counts 
raw_counts <- txi$counts

# Save raw counts as CSV
write.csv(raw_counts, "D:/COVID19/GSE255647/output/tables/raw_counts.csv", row.names = FALSE)
# Save raw counts as RDS
write_rds(raw_counts, "D:/COVID19/GSE255647/output/tables/raw_counts.rds")

# explore normalize counts 
tpm_counts <- txi$abundance

# Save raw counts as CSV
write.csv(tpm_counts, "D:/COVID19/GSE255647/output/tables/tpm_counts.csv", row.names = FALSE)
# Save raw counts as RDS
write_rds(tpm_counts, "D:/COVID19/GSE255647/output/tables/tpm_counts.rds")


#Step 5: Create DESeq2 object from tximport result
# Make DESeq dataset
dds <- DESeqDataSetFromTximport(txi = txi, 
                            colData = col_data, 
                             design = ~condition)
# Run DESeq2
dds <- DESeq(dds)

# Get default results
resdf <- as.data.frame(results(dds))

# Save raw counts as CSV
write.csv(resdf, "D:/COVID19/GSE255647/output/tables/res_dds.csv", row.names = FALSE)

# Save raw counts as RDS
saveRDS(resdf, "D:/COVID19/GSE255647/output/tables/res_dds.rds")


#Step 6. Quality Control
# Regularized log transformation for PCA
rlog_dds <- rlog(dds)

# PCA data
pca_data <- plotPCA(rlog_dds,
                    intgroup   = "condition",
                    returnData = TRUE)
percentVar <- round(100 * attr(pca_data, "percentVar"), 1)

# Save PCA data
write.csv(pca_data, "D:/COVID19/GSE255647/output/tables/pca_data.csv", row.names = FALSE)
saveRDS(pca_data, "D:/COVID19/GSE255647/output/tables/pca_data.rds")

# PCA Plot
pca_data |>
  tidyplot(x = PC1, y = PC2, color = group) |>
  add_data_points(size = 1.8, white_border = TRUE) |>
  add_ellipse(level = 0.68, linewidth = 0.6) |>
  adjust_x_axis_title(paste0("PC1 (", percentVar[1], "%)")) |>
  adjust_y_axis_title(paste0("PC2 (", percentVar[2], "%)")) |>
  adjust_colors(colors_discrete_apple) |>
  adjust_title("PCA: Infection")

ggsave("D:/COVID19/GSE255647/output/figures/PCA_Plot.jpg",
       width = 7, height = 5.5, dpi = 300)
ggsave("D:/COVID19/GSE255647/output/figures/PCA_Plot.pdf",
       width = 7, height = 5.5)


# MA plot 
# Get DESeq2 results for SARS1 vs Mock
res1 <- results(dds, contrast = c("condition", "SARS1", "Mock"))

# MA Plot — SARS1 vs Mock 
png("D:/COVID19/GSE255647/output/figures/MAplot_SARS1_vs_Mock.png",
    width = 7, height = 5, units = "in", res = 300)
plotMA(res1,
       main  = "SARS-CoV-1 vs Mock",
       alpha = 0.05,
       ylim  = c(-5, 5))
dev.off()

# Prepare dataframe
df1 <- as.data.frame(res1) |>
  rownames_to_column("gene") |>
  dplyr::filter(!is.na(padj)) |>
  dplyr::mutate(
    neg_log10_padj = -log10(padj),
    direction      = if_else(log2FoldChange > 0, "up", "down", NA),
    candidate      = abs(log2FoldChange) >= 1 & padj < 0.05)

saveRDS(df1, "D:/COVID19/GSE255647/output/tables/DESeq2_results_SARS1_vs_Mock.rds")


# Top genes for labeling
top_genes1 <- df1 |>
  dplyr::filter(candidate, !is.na(direction)) |>
  dplyr::group_by(direction) |>
  dplyr::slice_min(padj, n = 3) |>
  dplyr::ungroup()

# Get DESeq2 results for SARS2 vs Mock
# Get results
res2 <- results(dds, contrast = c("condition", "SARS2", "Mock"))

# MA Plot — SARS2
png("D:/COVID19/GSE255647/output/figures/MAplot_SARS2_vs_Mock.png",
    width = 7, height = 5, units = "in", res = 300)
plotMA(res2,
       main  = "SARS-CoV-2 vs Mock",
       alpha = 0.05,
       ylim  = c(-5, 5))
dev.off()

# Prepare dataframe
df2 <- as.data.frame(res2) |>
  rownames_to_column("gene") |>
  dplyr::filter(!is.na(padj)) |>
  dplyr::mutate(
    neg_log10_padj = -log10(padj),
    direction      = if_else(log2FoldChange > 0, "up", "down", NA),
    candidate      = abs(log2FoldChange) >= 1 & padj < 0.05)

saveRDS(df2, "D:/COVID19/GSE255647/output/tables/DESeq2_results_SARS2_vs_Mock.rds")

# Top genes for labeling
top_genes2 <- df2 |>
  dplyr::filter(candidate, !is.na(direction)) |>
  dplyr::group_by(direction) |>
  dplyr::slice_min(padj, n = 3) |>
  dplyr::ungroup()


#Downstream Visualization
# Volcano Plot — SARS1 vs Mock 
df1 |>
  tidyplot(x = log2FoldChange, y = neg_log10_padj) |>
  add_data_points(data = filter_rows(!candidate),
                  color = "lightgrey", rasterize = TRUE) |>
  add_data_points(data = filter_rows(candidate, direction == "up"),
                  color = "#FF7777", alpha = 0.5) |>
  add_data_points(data = filter_rows(candidate, direction == "down"),
                  color = "#7DA8E6", alpha = 0.5) |>
  add_reference_lines(x = c(-1, 1), y = -log10(0.05)) |>
  add_data_labels_repel(data = min_rows(padj, 6, by = direction),
                        label = gene,
                        color = "#000000",
                        min.segment.length = 0,
                        background = TRUE) |>
  adjust_x_axis_title("$Log[2]~fold~change$") |>
  adjust_y_axis_title("$-Log[10]~italic(P)~adjusted$") |>
  adjust_title("SARS-CoV-1 vs Mock")

ggsave("D:/COVID19/GSE255647/output/figures/Volcano_Plot_SARS1_vs_Mock.pdf",
       width = 7, height = 6)


# EnhancedVolcano — SARS1
EnhancedVolcano(
  df1,
  lab             = df1$gene,
  x               = "log2FoldChange",
  y               = "padj",
  pCutoff         = 0.001,
  FCcutoff        = 2,
  pointSize       = 1.5,
  labSize         = 3.0,
  xlim            = c(-5, 5),
  ylim            = c(0, -log10(10e-10)),
  border          = "full",
  borderWidth     = 1.5,
  borderColour    = "black",
  gridlines.major = FALSE,
  title           = "SARS-CoV-1 vs Mock")

ggsave("D:/COVID19/GSE255647/output/figures/EnhancedVolcano_SARS1_vs_Mock.pdf",
       width = 8, height = 8)

# Volcano Plot — SARS2
df2 |>
  tidyplot(x = log2FoldChange, y = neg_log10_padj) |>
  add_data_points(data = filter_rows(!candidate),
                  color = "lightgrey", rasterize = TRUE) |>
  add_data_points(data = filter_rows(candidate, direction == "up"),
                  color = "#FF7777", alpha = 0.5) |>
  add_data_points(data = filter_rows(candidate, direction == "down"),
                  color = "#7DA8E6", alpha = 0.5) |>
  add_reference_lines(x = c(-1, 1), y = -log10(0.05)) |>
  add_data_labels_repel(data = min_rows(padj, 6, by = direction),
                        label = gene,
                        color = "#000000",
                        min.segment.length = 0,
                        background = TRUE) |>
  adjust_x_axis_title("$Log[2]~fold~change$") |>
  adjust_y_axis_title("$-Log[10]~italic(P)~adjusted$") |>
  adjust_title("SARS-CoV-2 vs Mock")

ggsave("D:/COVID19/GSE255647/output/figures/Volcano_Plot_SARS2_vs_Mock.pdf",
       width = 7, height = 6)

# EnhancedVolcano — SARS2
EnhancedVolcano(
  df2,
  lab             = df2$gene,
  x               = "log2FoldChange",
  y               = "padj",
  pCutoff         = 0.001,
  FCcutoff        = 2,
  pointSize       = 1.5,
  labSize         = 3.0,
  xlim            = c(-5, 5),
  ylim            = c(0, -log10(10e-10)),
  border          = "full",
  borderWidth     = 1.5,
  borderColour    = "black",
  gridlines.major = FALSE,
  title           = "SARS-CoV-2 vs Mock")

ggsave("D:/COVID19/GSE255647/output/figures/EnhancedVolcano_SARS2_vs_Mock.pdf",
       width = 8, height = 8)


