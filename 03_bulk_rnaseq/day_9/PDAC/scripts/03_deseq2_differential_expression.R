# Script 03: DESeq2 Differential Expression Analysis
# =============================================================================
# WHAT: Run the full DESeq2 pipeline on the prepared PDAC count data:
#       (1) construct a DESeqDataSet with a PAIRED design (~ patient + condition),
#       (2) estimate size factors, dispersions, and fit the NB GLM,
#       (3) test for differential expression (Wald test),
#       (4) apply log-fold-change shrinkage (apeglm),
#       (5) export results tables (full, shrunk, normalized, significant).
#
# WHY:  DESeq2 models RNA-seq counts with a negative binomial distribution,
#       accounting for the mean-variance relationship inherent to count data.
#       The PAIRED design (~ patient + condition) is the central teaching
#       point: by blocking on patient, we remove inter-patient baseline
#       variability from the residual, dramatically improving power to detect
#       tumor-specific changes. LFC shrinkage (apeglm) produces stable
#       effect-size estimates for ranking and visualization.
#
# BIOLOGICAL CONTEXT:
#   This analysis identifies genes whose expression changes specifically in
#   PDAC tumor tissue relative to matched normal pancreatic tissue from the
#   SAME patient. The paired design isolates tumor-specific changes from
#   patient-to-patient genetic and microenvironmental variability. The
#   resulting gene list is the foundation for understanding PDAC biology
#   and for all downstream analyses (enrichment, WGCNA).
#
# KEY TEACHING POINTS:
#   - Why paired design matters (vs. unpaired ~ condition)
#   - Size factor normalization (median-of-ratios)
#   - Negative binomial model and dispersion estimation
#   - Wald test for significance
#   - LFC shrinkage (apeglm) for stable effect sizes
#   - padj (BH-adjusted) vs. raw pvalue
#   - Independent filtering (removes low-count genes from testing)
# =============================================================================

suppressPackageStartupMessages({
  library(DESeq2)
  library(apeglm)
})

# ---- Load processed data from Script 01 ------------------------------------
counts   <- readRDS("data/counts_filtered.rds")
metadata <- readRDS("data/metadata.rds")

# ---- Step 1: Construct DESeqDataSet ----------------------------------------
# WHAT: Create a DESeqDataSet object from the count matrix and metadata.
#       The design formula ~ patient + condition specifies:
#         - patient: blocking factor (controls for patient-specific baseline)
#         - condition: the variable of interest (tumor vs. normal)
# WHY:  The design formula is the most important decision in DESeq2. Here we
#       use a PAIRED design because each patient contributed both tumor and
#       normal tissue. Without the patient term, inter-patient variability
#       would inflate the residual variance, reducing power. With it, the
#       model effectively compares each tumor to its matched normal.
dds <- DESeqDataSetFromMatrix(
  countData = counts,
  colData   = metadata,
  design    = ~ patient + condition
)

# Ensure condition reference level is "normal" (positive LFC = up in tumor)
dds$condition <- relevel(dds$condition, ref = "normal")

# ---- Step 2: Run DESeq2 pipeline -------------------------------------------
# WHAT: The DESeq() function runs three core steps in sequence:
#       (a) estimateSizeFactors(): median-of-ratios normalization
#           - computes a size factor for each sample that corrects for
#             library size (sequencing depth) differences
#       (b) estimateDispersions(): fits the mean-dispersion relationship
#           - estimates how variance scales with mean expression
#           - shrinks gene-wise dispersion estimates toward the fitted trend
#       (c) nbinomWaldTest(): fits the NB GLM and computes Wald statistics
#           - tests H0: log2FC = 0 for the condition coefficient
# WHY:  These three steps embody the core DESeq2 statistical model. The
#       negative binomial distribution captures overdispersion (variance >
#       mean) that is characteristic of RNA-seq count data. Dispersion
#       shrinkage borrows information across genes, improving estimates
#       for genes with few counts.
dds <- DESeq(dds)

# Report size factors (normalization)
sf <- sizeFactors(dds)
cat("    Range:", round(min(sf), 3), "-", round(max(sf), 3), "\n")
cat("    Median:", round(median(sf), 3), "\n")

# ---- Step 3: Extract results ------------------------------------------------
# WHAT: Extract the results table for the condition contrast (tumor vs normal).
#       The contrast argument explicitly defines the comparison direction:
#         condition tumor vs. normal -> positive log2FC = higher in tumor
# WHY:  Explicit contrast specification avoids ambiguity about which level is
#       the numerator vs. denominator. The results table contains:
#         - baseMean: average expression across all samples
#         - log2FoldChange: tumor vs. normal (on log2 scale)
#         - lfcSE: standard error of the log2FC
#         - stat: Wald statistic (log2FC / lfcSE)
#         - pvalue: raw p-value from Wald test
#         - padj: BH-adjusted p-value (after independent filtering)
res <- results(dds, contrast = c("condition", "tumor", "normal"), alpha = 0.05)
res

# Summary of results
cat("    Total genes tested:", sum(!is.na(res$pvalue)), "\n")
cat("    Upregulated (padj < 0.05, log2FC > 0):",
    sum(res$padj < 0.05 & res$log2FoldChange > 0, na.rm = TRUE), "\n")
cat("    Downregulated (padj < 0.05, log2FC < 0):",
    sum(res$padj < 0.05 & res$log2FoldChange < 0, na.rm = TRUE), "\n")
cat("    Total significant (padj < 0.05):",
    sum(res$padj < 0.05, na.rm = TRUE), "\n")

# ---- Step 4: Log-fold-change shrinkage -------------------------------------
# WHAT: Apply LFC shrinkage using the apeglm method. This shrinks noisy
#       log2FC estimates (especially for low-count genes) toward zero,
#       producing more stable effect-size estimates for ranking and
#       visualization.
# WHY:  Without shrinkage, low-count genes can have wildly large log2FC
#       values (e.g., 1 count vs. 10 counts = log2FC ~3.3, but this is
#       noise, not signal). apeglm shrinkage preserves large true effects
#       while pulling noisy estimates toward zero. This is essential for:
#       - MA plots (avoids "trumpet" shape at low expression)
#       - Volcano plots (reduces false extremes)
#       - Gene ranking for GSEA
# NOTE: Use SHRUNK LFC for visualization/ranking; use UNSHRUNK for the
#       statistical test (p-values). The p-values are NOT affected by shrinkage.
# NOTE: apeglm requires the 'coef' argument (not 'contrast'). We get the coef
#       name from resultsNames(dds) — it is "condition_tumor_vs_normal".
cat("  Available coefficients:", paste(resultsNames(dds), collapse = ", "), "\n")
coef_name <- "condition_tumor_vs_normal"
res_shrunk <- lfcShrink(dds, coef = coef_name, res = res, type = "apeglm")
res_shrunk

# ---- Step 5: Export results -------------------------------------------------
# WHAT: Save the full results table, shrunk results, normalized counts, and
#       a filtered table of significant genes.
# WHY:  These tables are the primary deliverables of the DE analysis. They
#       feed into downstream enrichment (Scripts 04-05) and WGCNA (Scripts
#       06-07), and are the key results for the lecture.
# 5a. Full results (unshrunk) - for statistical reference
res_df <- as.data.frame(res)
res_df$gene_id <- rownames(res_df)
res_df <- res_df[, c("gene_id", "baseMean", "log2FoldChange", "lfcSE", "stat", "pvalue", "padj")]
write.csv(res_df, "tables/deseq2_results.csv", row.names = FALSE)

# 5b. Shrunk results - for visualization and ranking
res_shrunk_df <- as.data.frame(res_shrunk)
res_shrunk_df$gene_id <- rownames(res_shrunk_df)

# Reorder columns
cols_present <- intersect(c("gene_id", "baseMean", "log2FoldChange", "lfcSE", "stat", "pvalue", "padj"),
                          colnames(res_shrunk_df))
res_shrunk_df <- res_shrunk_df[, cols_present]
write.csv(res_shrunk_df, "tables/deseq2_results_shrunk.csv", row.names = FALSE)

# 5c. Normalized counts (size-factor normalized, not transformed)
norm_counts <- counts(dds, normalized = TRUE)
write.csv(norm_counts, "tables/deseq2_normalized_counts.csv")

# 5d. Significant genes (padj < 0.05, |log2FC| >= 1)
sig_genes <- res_shrunk_df[which(res_shrunk_df$padj < 0.05 & abs(res_shrunk_df$log2FoldChange) >= 1), ]
sig_genes <- sig_genes[order(sig_genes$padj), ]
write.csv(sig_genes, "tables/deseq2_significant_genes.csv", row.names = FALSE)

# 5e. Save RDS objects for downstream scripts
saveRDS(dds, "data/dds_object.rds")
saveRDS(res, "data/deseq2_res.rds")
saveRDS(res_shrunk, "data/deseq2_res_shrunk.rds")
