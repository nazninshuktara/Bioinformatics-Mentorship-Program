# Module 1: Data Preparation — Interpretation

## Results Summary

The data preparation step processed the GSE130688 dataset from raw form to analysis-ready state:

| Metric | Value |
|--------|-------|
| Input genes | 39,376 |
| Genes after filtering | 23,235 (59% retained) |
| Genes filtered out | 16,141 (low-count) |
| Entrez-to-symbol mapping rate | 95.7% (37,692 / 39,376) |
| Samples | 30 (15 tumor + 15 normal) |
| Patients | 15 (paired design) |

---

## Biological Significance

### What the filtering tells us

Over 40% of genes (16,141) were filtered out because they had fewer than 10 counts in at least 2 samples. This is expected and normal for RNA-seq data — many genes are either not expressed in pancreatic tissue or expressed at levels too low to be informative. These include:

- **Tissue-specific genes** from other organs (e.g., brain-specific genes not expressed in pancreas)
- **Pseudogenes** and non-functional loci
- **Lowly expressed regulatory genes** below the detection threshold

The 23,235 retained genes represent the expressed transcriptome of pancreatic tissue — the genes with enough signal to potentially detect differential expression.

### What the ID mapping rate tells us

95.7% of Entrez IDs successfully mapped to gene symbols. The 4.3% unmapped IDs are likely:

- **Retired Entrez IDs** that have been removed from NCBI's database
- **Non-coding RNA genes** that may not have standard symbols
- **Historical loci** from older genome builds

This mapping rate is typical for human RNA-seq data and does not indicate a data quality problem.

---

## Key Findings

### The paired design is confirmed

The metadata structure confirms that GSE130688 is a true paired design:

```
Patient P01: GSM3747758 (normal) + GSM3747759 (tumor)
Patient P02: GSM3747760 (normal) + GSM3747761 (tumor)
...
Patient P15: GSM4490231 (normal) + GSM4490232 (tumor)
```

This means each tumor sample has a matched normal control from the same patient. This is critical for the DESeq2 analysis (Module 2), where we will use the design formula `~ patient + condition` to block on patient-specific effects.

### Why this matters biologically

Without the paired design, comparing 15 tumors to 15 normals from different patients would conflate two sources of variation:
1. **Tumor vs. normal** (the biological signal we want)
2. **Patient-to-patient variability** (noise that obscures the signal)

With the paired design, each patient serves as their own control, and the analysis asks: "Within each patient, what changes between normal and tumor tissue?" This isolates the tumor-specific signal.

---

## Caveats and Limitations

### Two sequencing platforms

GSE130688 was sequenced on two platforms: Illumina HiSeq 1500 and HiSeq 2500. This could introduce a **batch effect** — systematic technical differences between platforms. In this analysis, we rely on the paired design to absorb most of this variability (if both samples from a patient were sequenced on the same platform). If PCA (Module 2) reveals platform-driven clustering, the design could be extended to `~ patient + platform + condition`.

### Total RNA-seq, not polyA-selected

The data was generated with strand-oriented total RNA-seq, which captures both coding and non-coding RNAs (including lncRNAs). This is why the original study focused on lncRNA characterization. Our analysis focuses on protein-coding genes, but the count matrix includes all transcript types.

### Filtering heuristic

The ">= 10 counts in >= 2 samples" filter is a common heuristic, not a universal standard. Alternative approaches include:
- **CPM-based filtering** (e.g., keep genes with CPM > 1 in at least N samples)
- **DESeq2's independent filtering** (automatically applied during results extraction)

Our explicit pre-filtering is complementary to DESeq2's independent filtering and makes the filtering decision transparent.

---

## Connection to Literature

The original GSE130688 study (Reis et al., PMID 35567709) used this same dataset to characterize long non-coding RNAs (lncRNAs) in PDAC. They identified 9,032 GENCODE lncRNAs and 523 novel lncRNAs, and used gene co-expression network analysis to associate deregulated lncRNAs with biological processes including cell adhesion, protein glycosylation, and DNA repair. Our analysis focuses on protein-coding genes but uses the same co-expression and enrichment methods, making it directly comparable to the original study's approach.

---

## Cross-Module Integration

The outputs of this module feed into all downstream analyses:

| Output | Used By | Purpose |
|--------|---------|---------|
| Filtered counts | Module 1b (Batch Detection), Module 2 (DESeq2) | Input for batch diagnosis and differential expression |
| Enriched metadata | Module 1b (Batch Detection), Module 2 (DESeq2) | Batch derivation, design formula (patient + condition) |
| Gene ID mapping | Modules 2-4 | Symbol labels for visualization and interpretation |
| VST-transformed counts | Module 4 (WGCNA) | Input for co-expression network (generated in Module 2) |

The paired design established here is the single most important decision in the entire workflow — it determines the statistical model for DESeq2 and the interpretation of all downstream results. The next step (Module 1b: Batch Detection, Script 02) checks whether technical batch effects threaten this design before proceeding to differential expression.
