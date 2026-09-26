# 🧬 Day 9 — Bulk RNAseq Data Analysis: Batch Effects and Complex Experimental Designs 

> **Week 5, Day 9** · Friday, July 31, 2026  
> **Notes by:** Naznin Akter<br>
> **Course material & scripts:** Md. Jubayer Hossain (DeepBio Academy)
---

## 🎯 Learning Checklist
- [1] **Batch Effect Detection:** Understand why batch effects are the #1 source of spurious signal in multi-batch RNA-seq, diagnose them using PCA, RLE plots, and variance partition, and recognize when experimental design (paired/blocking) can substitute for computational correction.
- [2] **Differential Expression (DESeq2):** Explain why RNA-seq counts require specialized statistical models, apply the negative binomial framework, and understand when to use a paired vs. unpaired experimental design.
- [3] **Functional Enrichment (clusterProfiler):** Distinguish GSEA from ORA, explain when each is appropriate, and interpret pathway-level results in biological context.
- [4] **Co-expression Networks (WGCNA):** Understand how weighted networks differ from unweighted ones, explain scale-free topology, and identify biologically relevant modules and hub genes.
- [5] **Cross-module integration:** Connect single-gene results (DE), pathway-level results (enrichment), and network-level results (WGCNA) into a coherent biological narrative.
- [6] Understand when `removeBatchEffect()` and `ComBat_seq()` are appropriate, and why neither replaces modeling batch in DESeq2 directly
- [7] Check your own dataset's metadata for real batch variation before applying any of this

---

## 📑 Part 1 — What a Batch Effect Actually Is

A **batch effect** is systematic, non-biological variation introduced by *when* or *how* a sample was handled — a different sequencing run, a different reagent lot, a different day, a different technician, a different instrument. It has nothing to do with the biology you're studying, but it can look exactly like biology in your data if you're not careful.

> [!NOTE]
> Bulk RNA-seq is *especially* sensitive to batch effects compared to other omics layers, because the biological signal itself is already an **average across millions of cells** — a comparatively weak, smoothed-out signal. A technical artifact of similar magnitude can rival or swamp the real biological difference you're trying to detect.

### Batch Effect vs. Confounding — the Critical Distinction
- **Modelable batch effect**: samples from each biological group are spread across multiple batches (e.g., 2 control + 2 treated samples in Batch 1, 2 control + 2 treated in Batch 2). Batch and condition vary *independently* — a statistical model can separate the two effects.
- **Confounded batch effect**: every sample of one biological group happens to fall in one batch, and every sample of another group falls in a different batch (e.g., all controls sequenced on Day 1, all treated on Day 2). Here, batch and biology are perfectly correlated — **no statistical method, however sophisticated, can separate them after the fact.** This has to be prevented at the experimental design stage by randomizing which samples land in which batch.

> [!WARNING]
> If you discover full confounding after the data is already collected, there is no computational fix. The honest options are: report the confound as a limitation, or collect additional samples that break the confounding.

### Detecting a Batch Effect: PCA as a Diagnostic

Before doing anything about a suspected batch effect, **see it first**. The standard approach: run PCA on the top ~500 most variable genes (using an `rlog`/`vst`-transformed matrix), then color the same PCA plot by different metadata variables.

```r
pca_from_matrix <- function(mat, meta, color, title) {
  vars  <- apply(mat, 1, var)
  top   <- names(sort(vars, decreasing = TRUE))[1:500]
  pca   <- prcomp(t(mat[top, ]))
  pv    <- round(100 * pca$sdev^2 / sum(pca$sdev^2), 1)
  df    <- cbind(as.data.frame(pca$x[, 1:2]), meta)
  ggplot(df, aes(PC1, PC2, color = .data[[color]])) +
    geom_point(size = 3) +
    labs(title = title,
         x = paste0("PC1 (", pv[1], "%)"),
         y = paste0("PC2 (", pv[2], "%)")) +
    theme_bw()
}
```
**How to read the two colorings:**
- **Color by suspected batch variable** (e.g., donor, run date, instrument) — if samples cluster tightly by this variable regardless of biological condition, that's your batch effect showing up as a major axis of variation.
- **Color by the biological variable of interest** — if this plot shows weak or no separation while the batch-colored plot shows strong separation, your treatment effect may be *partially hidden* behind the technical variation.

> [!NOTE]
> A batch effect big enough to dominate PC1 doesn't mean your experiment failed — it means the batch **must** be included in the statistical model, not ignored.

### The Correct Fix: Model the Batch, Don't Delete It

The standard, recommended approach for DESeq2 is to **add the batch as a covariate in the design formula** — never to "correct" or delete it from the raw counts before testing.

```r
design(dds) <- ~ batch + condition
dds <- DESeq(dds)
```

This tells DESeq2: *estimate and remove the batch's average effect first, then test for the condition effect on top of that.* The raw counts themselves are never modified — DESeq2 works with the model, not with pre-adjusted data.

**Demonstrating the benefit — compare naive vs. blocked models:**
```r
dds_naive   <- dds; design(dds_naive)   <- ~ condition
dds_blocked <- dds; design(dds_blocked) <- ~ batch + condition
dds_naive   <- DESeq(dds_naive)
dds_blocked <- DESeq(dds_blocked)

n_naive   <- sum(results(dds_naive,   contrast = ct, alpha = 0.05)$padj < 0.05, na.rm = TRUE)
n_blocked <- sum(results(dds_blocked, contrast = ct, alpha = 0.05)$padj < 0.05, na.rm = TRUE)
```
Blocking the batch typically **recovers more true differentially expressed genes** — by removing batch-driven noise from the residual variance, genuine condition effects become statistically clearer (lower p-values for the same effect size).

### Batch Removal for Visualization Only (`removeBatchEffect`)

Sometimes you want a PCA or heatmap that visually shows the treatment effect **without** the batch cluttering the picture — for a report or presentation. `limma::removeBatchEffect()` subtracts the estimated batch effect from an already-transformed (`rlog`/`vst`) matrix, purely for plotting.

```r
mm <- model.matrix(~ condition, data = meta)
rld_nobatch <- limma::removeBatchEffect(rld_mat, batch = rld$batch, design = mm)
```

> [!WARNING]
> **Never feed `removeBatchEffect()`-adjusted values back into DESeq2 for testing.** DESeq2 must always test on raw counts with batch included in the design formula — using batch-subtracted values for statistical testing artificially inflates confidence and invalidates the test. This function exists for **visualization only**.

### `ComBat_seq`: Correcting Raw Counts (Rare, Specific Use Case)

`ComBat_seq` (from the `sva` package) returns **batch-corrected count data** you could feed into a downstream tool.

```r
adjusted <- ComBat_seq(counts = raw_counts, batch = meta$batch, group = meta$condition)
```

**When this is actually appropriate:** only when your downstream analysis tool **cannot** include batch as a covariate in its own model (e.g., some machine learning pipelines, or tools that only accept a single pre-cleaned matrix). If you're using DESeq2, **prefer Part 3's approach (`~ batch + condition`)** — DESeq2 can model batch natively, so pre-correcting the counts is unnecessary and loses some of the statistical rigor of joint modeling.

### Before Applying Any of This: Check Your Own Metadata

None of the above matters if there's no real batch variation in your dataset. Before adding a batch covariate or running any correction, check the metadata for **actual variation** in candidate batch variables:

```r
table(run_table$Instrument)
table(run_table$`SRA Study`)
table(run_table$create_date)
table(run_table$`Center Name`)
```

**How to interpret:**
| Result | Meaning |
|---|---|
| A column shows only **one value** across all samples | Not a usable batch variable — there's no variation to model |
| A column shows genuine grouping (e.g., half the samples from one date, half from another) | A real candidate for `~ batch + condition` |
| Minor timestamp differences within the same day/run | Not a meaningful batch — normal operational variation, not a technical confound worth modeling |

> [!NOTE]
> For the GSE245922 dataset specifically: Instrument, SRA Study, and Center Name were all identical across every sample, and `create_date` varied only by minutes within a single day. **Conclusion: no batch correction was needed** — the design formula `~ condition` alone was correct and complete. This is a good habit to repeat for every new dataset: check before you correct.

---

## Dataset: GSE130688
In this lecture, we use this dataset

| Property | Value |
|------------------------------------|------------------------------------|
| **GEO Accession** | GSE130688 |
| **Publication** | Reis et al., PMID 35567709 |
| **Disease** | Pancreatic ductal adenocarcinoma (PDAC) |
| **Design** | 15 patients, patient-matched tumor + adjacent normal (30 samples) |
| **Platform** | Illumina HiSeq 1500/2500, strand-oriented total RNA-seq |
| **Data type** | Raw integer gene counts, Entrez gene IDs |
| **Genes** | 39,376 (23,235 after filtering) |

### Why This Dataset?

This dataset was chosen because it satisfies the requirements of all three analysis modules while providing a rich biological narrative:

- **Paired design** (tumor + normal from the same patient) teaches the critical concept of blocking in DESeq2 — one of the most important and commonly misunderstood topics in RNA-seq analysis.
- **30 samples** meet the minimum requirement for WGCNA (\>=15 samples), enabling co-expression network analysis.
- **The original study itself used WGCNA and functional enrichment**, meaning the methods we teach are biologically validated for this data.
- **PDAC** is a well-characterized cancer with known biology (KRAS mutations, desmoplastic stroma, immune infiltration, loss of acinar function), making interpretation concrete and grounded in literature.

### Biological Context

Pancreatic ductal adenocarcinoma (PDAC) is one of the deadliest cancers, with a 5-year survival rate below 12%. It is characterized by:

- **KRAS mutations** (\>90% of cases) driving constitutive proliferative signaling
- **Desmoplastic stroma** — dense fibrotic tissue surrounding the tumor, composed of activated fibroblasts and extracellular matrix
- **Immune suppression** — the tumor microenvironment is dominated by immunosuppressive cells (regulatory T cells, M2 macrophages)
- **Loss of normal pancreatic function** — tumor tissue loses the acinar cell identity that defines normal pancreas (digestive enzyme production)

The paired tumor-vs-normal design allows us to isolate tumor-specific expression changes from the inter-patient variability that would confound an unpaired comparison.

------------------------------------------------------------------------

## Workflow

```         
Raw Counts (GSE130688)
    │
    ▼
┌─────────────────────────────────┐
│  Module 1: Data Preparation     │  Script 01
│  - Load & validate counts       │
│  - Derive patient IDs           │
│  - Map Entrez → symbols         │
│  - Pre-filter low-count genes   │
└──────────────┬──────────────────┘
               │
               ▼
┌─────────────────────────────────┐
│  Module 1b: Batch Detection     │  Script 02
│  - PCA by batch/condition       │
│  - RLE plot                     │
│  - Variance partition           │
│  - Confounding diagnosis        │
└──────────────┬──────────────────┘
               │
               ▼
┌─────────────────────────────────┐
│  Module 2: DESeq2 DE Analysis   │  Scripts 03-04
│  - Paired design (~patient+cond)│
│  - NB model + Wald test         │
│  - LFC shrinkage (apeglm)       │
│  - QC + results visualization   │
└──────────────┬──────────────────┘
               │
       ┌───────┴────────┐
       ▼                ▼
┌──────────────┐  ┌──────────────────────┐
│ Module 3:    │  │ Module 4: WGCNA      │  Scripts 07-08
│ Enrichment   │  │ - Network construction│
│ (GSEA + ORA) │  │ - Module-trait corr   │
│ Scripts 05-06│  │ - Hub genes           │
└──────────────┘  └──────────────────────┘
```

### Data Flow Between Modules

| From | To | What is passed |
|------------------------|------------------------|------------------------|
| Script 01 | Scripts 02-08 | Filtered count matrix, enriched metadata, gene ID mapping |
| Script 02 | Scripts 03-08 | Metadata with batch column (batch diagnosis informs design) |
| Script 03 | Scripts 04-06 | DESeq2 results (res, res_shrunk), normalized counts |
| Script 04 | Scripts 07-08 | VST-transformed counts (for WGCNA) |
| Script 03 | Script 08 | Significant DE genes (for cross-referencing with modules) |

------------------------------------------------------------------------

## Software Requirements

| Package         | Version | Purpose                                 |
|-----------------|---------|-----------------------------------------|
| R               | 4.4.3   | Statistical computing environment       |
| DESeq2          | 1.46.0  | Differential expression analysis        |
| apeglm          | 1.28.0  | LFC shrinkage                           |
| clusterProfiler | 4.14.0  | Functional enrichment (GSEA + ORA)      |
| enrichplot      | 1.26.1  | Enrichment visualization                |
| msigdbr         | 26.1.0  | MSigDB gene set database access         |
| org.Hs.eg.db    | 3.20.0  | Human gene annotation (Entrez ↔ Symbol) |
| WGCNA           | 1.74    | Co-expression network analysis          |
| ComplexHeatmap  | 2.22.0  | Heatmap visualization                   |
| ggplot2         | 4.0.3   | General visualization                   |
| pheatmap        | 1.0.13  | Heatmap visualization                   |

------------------------------------------------------------------------

## How to Run the Scripts

Scripts must be run **in order** because each depends on outputs from previous scripts:

``` bash
# From the project root directory (/mnt/results/)
Rscript scripts/01_load_prepare_data.R
Rscript scripts/02_batch_correction.R
Rscript scripts/03_deseq2_differential_expression.R
Rscript scripts/04_deseq2_visualization.R
Rscript scripts/05_enrichment_gsea.R
Rscript scripts/06_enrichment_ora.R
Rscript scripts/07_wgcna_network_construction.R
Rscript scripts/08_wgcna_module_trait_hub_genes.R
```

### Folder Structure

```         
├── data/           # Input data + processed RDS objects
├── scripts/        # Numbered R scripts (01-08)
├── figures/        # Method-prefixed PNG figures
├── tables/         # Derived data tables (CSV)
└── docs/           # Documentation
```

------------------------------------------------------------------------

## Documentation Structure

Each module has two documentation files:

1.  **Methods document** (`<module>.md`): What the method does, why it's used, step-by-step walkthrough, key parameters, and biological context.

2.  **Interpretation document** (`<module>_interpretation.md`): What the results mean, biological significance, key findings, caveats, and cross-module connections.

| Module | Methods Doc | Interpretation Doc |
|------------------------|------------------------|------------------------|
| Data Preparation | `01_data_preparation.md` | `01_data_preparation_interpretation.md` |
| Batch Effect Detection | `02_batch_correction.md` | `02_batch_correction_interpretation.md` |
| Differential Expression | `03_differential_expression_analysis.md` | `03_differential_expression_analysis_interpretation.md` |
| Functional Enrichment | `05_functional_enrichment_analysis.md` | `05_functional_enrichment_analysis_interpretation.md` |
| Co-expression Networks | `07_coexpression_network_analysis.md` | `07_coexpression_network_analysis_interpretation.md` |

------------------------------------------------------------------------

## Key Concepts at a Glance

| Method | Question Answered | Input | Key Output |
|------------------|------------------|------------------|------------------|
| Batch Detection | Are technical batch effects present, and do they threaten the analysis? | Filtered counts + metadata | PCA, RLE, variance partition diagnosis |
| DESeq2 | Which genes differ between tumor and normal? | Raw counts + metadata | Ranked gene list with log2FC and padj |
| GSEA | Which pathways are coordinately shifted? | Ranked gene list | Pathways with NES and FDR |
| ORA | Which pathways are over-represented among DE genes? | Significant gene list | Pathways with enrichment p-value |
| WGCNA | Which gene modules co-vary, and which relate to tumor? | Normalized expression matrix | Modules, hub genes, module-trait correlations |
---

## 🔍 Bulk RNA-Seq Project Exploration
- [PDAC](https://github.com/nazninshuktara/Bioinformatics-Mentorship-Program/tree/main/03_bulk_rnaseq/day_9/PDAC)




