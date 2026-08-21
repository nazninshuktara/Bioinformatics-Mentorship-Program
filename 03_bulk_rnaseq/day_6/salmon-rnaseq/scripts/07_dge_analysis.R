# RNA-seq Analysis in R (Part 3): DESeq2 Differential Expression Testing

# 1. Install and load packages
pak::pkg_install(c("tidyverse", "tximport", "DESeq2", "EnsDb.Hsapiens.v86", "pheatmap", "RColorBrewer", "apeglm"))

library(tidyverse)
library(tximport)
library(DESeq2)
library(EnsDb.Hsapiens.v86)
library(pheatmap)
library(RColorBrewer)
library(apeglm)


# 2. Load the dds object from Part 2 (already has size factors estimated)
dds <- read_rds("outputs/tables/GSE245922_dds.rds")

# 3. Run the actual DGE test
# This estimates dispersion (Negative Binomial model) AND fits the model
# AND tests every gene — this is the step that produces p-values.
dds <- DESeq(dds)

# Model-fit diagnostics — confirm the fit is trustworthy before trusting results
# Size factors (median of ratios) — usually near 1
sizeFactors(dds)

# Total RAW counts per sample - larger depth tends to give a larger size factor.
colSums(counts(dds))

# Total NORMALIZED counts per sample - evened out, but not identical, because
# DESeq2 also corrects for RNA composition (not just depth).
colSums(counts(dds, normalized = TRUE))

# Dispersion plot - the key model-fit diagnostic. Expect:
#   - dispersion DECREASING as mean expression increases,
#   - black dots (gene estimates) scattered around the red fitted curve,
#   - blue dots = shrunken estimates pulled toward the curve.
png("outputs/figures/GSE245922_dispersion_estimates.png",
    width = 7, height = 5, units = "in", res = 300)

plotDispEsts(dds)

dev.off()

# also show it in an interactive session
plotDispEsts(dds)

# Save the fitted object for reuse
write_rds(dds, "outputs/tables/GSE245922_dds_deseq.rds")

# See which contrast(s) are available given your design (~ condition)
resultsNames(dds)

# 4. Extract results — covid19 vs control
res <- results(dds, contrast = c("condition", "covid19", "control"))
summary(res)

# 5. Shrink log2FC for more reliable ranking/plotting
res_shrunk <- lfcShrink(dds, coef = "condition_covid19_vs_control", type = "apeglm")

# 6. Tidy into a data frame with gene symbols as a column
res_df <- as.data.frame(res_shrunk)
res_df$gene <- rownames(res_df)
rownames(res_df) <- NULL
res_df <- dplyr::relocate(res_df, gene)

# 7. Sort by adjusted p-value (most significant first)
res_df <- res_df[order(res_df$padj), ]
head(res_df)

# 8. Quick sanity numbers
sum(res_df$padj < 0.05, na.rm = TRUE)          # how many significant genes
sum(res_df$padj < 0.05 & abs(res_df$log2FoldChange) >= 1, na.rm = TRUE)  # significant + meaningful FC

# 9. Extract significant genes (padj < 0.05), split by direction
sig <- res_df |> dplyr::filter(padj < 0.05) |> arrange(padj)
sig_up   <- sig |> dplyr::filter(log2FoldChange > 0)
sig_down <- sig |> dplyr::filter(log2FoldChange < 0)

message("Significant: ", nrow(sig), " | up: ", nrow(sig_up), " | down: ", nrow(sig_down))

# 9. Save results
write.csv(res_df, "outputs/tables/GSE245922_deseq2_results.csv", row.names = FALSE)
write_rds(res_df, "outputs/tables/GSE245922_deseq2_results.rds")

write.csv(sig, "outputs/tables/GSE245922_significant_covid19_vs_control.csv", row.names = FALSE)
write_rds(sig, "outputs/tables/GSE245922_sig_covid19_vs_control.rds")
