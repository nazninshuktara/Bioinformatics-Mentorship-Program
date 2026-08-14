# 12. Statistics Primer (for RNA-seq / Bioinformatics)

## Overview

Bioinformatics analysis — especially differential expression (DESeq2/EdgeR) — relies heavily on statistical concepts. This primer covers the foundational ideas needed before diving deeper into hypothesis testing within RNA-seq pipelines.

---

## 1. Descriptive Statistics

| Term | Meaning |
|------|---------|
| **Mean** | Average value |
| **Median** | Middle value when sorted |
| **Variance** | Average squared deviation from the mean — measures spread |
| **Standard deviation (SD)** | Square root of variance — spread in original units |
| **Standard error (SE)** | SD of the sampling distribution of the mean; SE = SD / √n |

- In RNA-seq: gene expression counts have both a mean and variance across replicates — this relationship is central to how DESeq2/EdgeR model the data (see "dispersion" below)

---

## 2. Probability Distributions

| Distribution | Relevance |
|---------------|-----------|
| **Normal (Gaussian)** | Many statistical tests assume normality (e.g., t-test) |
| **Poisson** | Models count data where mean = variance (simplistic assumption for RNA-seq counts) |
| **Negative Binomial** | Models count data where variance > mean ("overdispersion") — this is what DESeq2 and EdgeR actually use for RNA-seq counts |

> RNA-seq count data is **overdispersed** (biological variability makes variance greater than the mean), which is why DESeq2/EdgeR use negative binomial models instead of simple Poisson models.

---

## 3. Hypothesis Testing Basics

- **Null hypothesis (H0)** – no difference/effect (e.g., "gene expression is the same between conditions")
- **Alternative hypothesis (H1)** – there is a difference/effect
- **p-value** – probability of observing data this extreme (or more extreme) if H0 were true
  - Small p-value (typically <0.05) → evidence against H0
  - p-value does NOT mean "probability the hypothesis is true"

---

## 4. Multiple Testing Correction

- RNA-seq tests thousands of genes simultaneously → high chance of false positives by chance alone (multiple testing problem)
- Example: testing 20,000 genes at p<0.05 → ~1,000 genes could appear "significant" purely by chance

### Common Corrections
| Method | Description |
|--------|-------------|
| **Bonferroni** | Very conservative; divides significance threshold by number of tests |
| **Benjamini-Hochberg (FDR)** | Controls **False Discovery Rate**; standard in RNA-seq (this is what DESeq2's "padj" column represents) |

- **Adjusted p-value (padj / FDR)** is what should be used to determine significance in DESeq2 results, NOT the raw p-value

---

## 5. Effect Size in RNA-seq: Log2 Fold Change

- **Fold change** – ratio of expression between two conditions (e.g., treated vs control)
- **Log2 fold change (LFC)** – log-transformed fold change; symmetric around 0
  - LFC = 0 → no change
  - LFC = 1 → 2-fold increase
  - LFC = -1 → 2-fold decrease
- DESeq2 output typically includes both **LFC** and **padj** — a gene should generally be considered meaningfully differentially expressed only when both effect size (LFC) AND statistical significance (padj) criteria are met

---

## 6. Key Terms Seen in DESeq2/EdgeR Output

| Term | Meaning |
|------|---------|
| **baseMean** | Average normalized count across all samples |
| **log2FoldChange** | Effect size (see above) |
| **lfcSE** | Standard error of the log2FoldChange estimate |
| **stat** | Test statistic |
| **pvalue** | Raw p-value |
| **padj** | Benjamini-Hochberg adjusted p-value (FDR) — the one to actually use for filtering significant genes |
| **Dispersion** | Estimate of biological variability per gene; central to negative binomial modeling in DESeq2/EdgeR |

---

## Why This Matters for Bioinformatics / RNA-seq

- This entire file is essentially the statistical foundation directly underneath the DESeq2/tximport pipeline already in use — every DESeq2 results table is built on these concepts.
- Understanding overdispersion explains *why* DESeq2 uses negative binomial models rather than simpler distributions.
- Knowing to filter on **padj**, not raw p-value, is one of the most common points of confusion/error when interpreting RNA-seq differential expression results.
- LFC + padj together (not either alone) should guide how "significant genes" are defined and reported.

---

## References
- Love, M.I., Huber, W., Anders, S. (2014). "Moderated estimation of fold change and dispersion for RNA-seq data with DESeq2." *Genome Biology*.
- Benjamini, Y. & Hochberg, Y. (1995). "Controlling the False Discovery Rate." *Journal of the Royal Statistical Society*.
- Robinson, M.D. et al. (2010). "edgeR: a Bioconductor package for differential expression analysis." *Bioinformatics*.