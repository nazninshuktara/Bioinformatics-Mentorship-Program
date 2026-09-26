# 🧬 Day 8 — Bulk RNAseq Data Analysis: From Differential Gene Expression Analysis to Pathways 

> **Week 4, Day 8** · Saturday, July 25, 2026  
> **Notes by:** Naznin Akter<br>
> **Course material & scripts:** Md. Jubayer Hossain (DeepBio Academy)
---

## 🎯 Learning Checklist
- [1] Run the actual DESeq2 DGE test on a fitted `dds` object and interpret model-fit diagnostics
- [2] Extract, shrink, and sanity-check differential expression results
- [3] Visualize DGE results: single-gene plot, heatmap of significant genes, volcano plot
- [4] Run GSEA against KEGG pathways and overlay results on pathway diagrams (Pathview)
- [5] Run GO Over-Representation Analysis (ORA) and understand how it complements GSEA
- [6] Know which R packages come from CRAN vs. Bioconductor, and install each correctly

---

## 📑 The Practical Pipeline (GSE245922)

This is the actual script sequence run on the GSE245922 (control vs. covid19) dataset — from a fitted `dds` object through to pathway-level biology.

```
08_visualizing_dge_results.R    → single-gene plot, heatmap, volcano plot
09_functional_analysis.R        → GSEA (KEGG) + Pathview overlay + GO over-representation (ORA)
```
*(Scripts 01–05, covering tximport → count matrix, are documented in the Day 6 guide. Scripts 06–07, covering normalization/PCA -> differential gene expression analysis and the underlying theory — negative binomial model, DESeq2/edgeR/limma-voom, and how to read all 12 DGE plots, are documented in the Day 7 guide.)*

### Script 08 — Visualization
1. **Single-gene plot** — `plotCounts()` for one biologically meaningful gene (e.g., a top significant gene like `CXCL10`), confirming the direction/magnitude makes sense at a glance
2. **Heatmap of significant genes** — normalized counts (row-scaled/Z-score) for the significant gene list, samples annotated by condition; should show two visually distinct blocks if the DGE result is real
3. **Volcano plot** — log2FC vs. -log10(padj), top-10 most significant genes labeled

> [!WARNING]
> Base R plots (`plotDispEsts()`, `plotMA()`) need `png()` → plot call → `dev.off()`. `ggsave()` only works for `ggplot`-based figures — mixing them up either errors or silently saves a blank/wrong image.

### Script 05 — Functional Analysis (GSEA + GO ORA)
**Part A — GSEA against KEGG:**
1. Map gene SYMBOLs → Entrez IDs (`bitr()`) — KEGG requires Entrez, not symbols
2. Build a **ranked, named fold-change vector** (all tested genes, sorted decreasing) — GSEA is threshold-free and needs the full ranking, not just significant genes
3. `gseKEGG()` with a fixed `set.seed()` (permutation-based test → reproducibility requires a seed)
4. **Pathview** — overlays the fold-change data directly onto the official KEGG pathway diagram for the top hit; writes a PNG to the working directory (not a `ggplot` object)

**Part B — GO Over-Representation Analysis (Biological Process):**
1. Background ("universe") = **all tested genes** (not the whole genome) — using the wrong background biases the enrichment statistics
2. `enrichGO()` — hypergeometric test: are GO BP terms over-represented in the significant list vs. background?
3. Visualizations: `dotplot()` (top terms by significance/gene count), `emapplot()` (clusters related terms), `cnetplot()` (genes linked to top terms, colored by fold change)

> [!NOTE]
> GSEA and GO ORA are **complementary, not redundant** — GSEA uses the full ranked list (catches coordinated but sub-threshold shifts), ORA only uses the significant-gene subset but often returns more specific, interpretable terms. Running both cross-validates the biological conclusion.

> [!WARNING]
> `dotplot(ego, showCategory = 30)` with default plot dimensions crowds the y-axis labels unreadably. Either reduce `showCategory` to ~15, or substantially increase the saved image `height` and shrink `axis.text.y` size.

### Package Source Reminder
| Source | Install with | Examples |
|---|---|---|
| CRAN | `install.packages("...")` | `tidyverse`, `pheatmap`, `ggrepel`, `ashr` |
| Bioconductor | `BiocManager::install("...")` | `DESeq2`, `tximport`, `clusterProfiler`, `org.Hs.eg.db`, `pathview`, `enrichplot` |

---

## ✅ Recap — What This Pipeline Establishes
1. `DESeq()` does three things in one call: dispersion estimation, model fitting, and hypothesis testing — always check the dispersion plot before trusting downstream results.
2. Results should always be extracted with an **explicit contrast**, and fold changes should be **shrunk** (`lfcShrink`) before ranking or plotting.
3. Visualization (single-gene plot, heatmap, volcano) is a sanity check as much as a communication tool — the DGE result should be visually obvious before moving to pathway analysis.
4. GSEA and GO ORA test different things (ranked list vs. significant subset) and are best run **together**, not as substitutes for each other.
5. Getting the package source wrong (CRAN vs. Bioconductor) is the most common installation error in this pipeline — `BiocManager::install()` for anything bioinformatics-specific.

---

## 🔍 Bulk RNA-Seq Project Exploration
- [salmon-rnaseq](https://github.com/nazninshuktara/Bioinformatics-Mentorship-Program/tree/main/03_bulk_rnaseq/day_6/salmon-rnaseq)