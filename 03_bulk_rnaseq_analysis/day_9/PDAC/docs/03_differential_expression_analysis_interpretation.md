# Module 2: Differential Expression Analysis — Interpretation

## Figures and Tables Referenced

**Figures:**
- `deseq2_dispersion.png` — DESeq2 dispersion estimates (gene-wise, trend, fitted)
- `deseq2_pca.png` — PCA of samples (VST, top 500 variable genes)
- `deseq2_sample_distance.png` — Sample-to-sample distance heatmap
- `deseq2_ma_plot.png` — MA plot of log2FC vs mean expression (shrunk LFC)
- `deseq2_volcano.png` — Volcano plot of log2FC vs -log10(padj)
- `deseq2_top_genes_heatmap.png` — Heatmap of top differentially expressed genes

**Tables:**
- `deseq2_results.csv` — Full DESeq2 results (all tested genes)
- `deseq2_results_shrunk.csv` — Results with apeglm LFC shrinkage
- `deseq2_significant_genes.csv` — Significant DE genes (padj < 0.05, |log2FC| >= 1)
- `deseq2_normalized_counts.csv` — DESeq2 normalized counts

---

## Results Summary

| Metric | Value |
|--------|-------|
| Genes tested | 23,235 |
| Significant (padj < 0.05) | 6,696 (28.8%) |
| Upregulated (padj < 0.05, log2FC > 0) | 3,660 |
| Downregulated (padj < 0.05, log2FC < 0) | 3,036 |
| Significant (padj < 0.05, \|log2FC\| >= 1) | 3,755 |
| PC1 variance explained | 55.7% |
| Size factor range | 0.158 - 5.125 |

Nearly 29% of tested genes are differentially expressed (see Table: Full DESeq2 results (`deseq2_results.csv`); see Table: Significant DE genes (`deseq2_significant_genes.csv`)) — a high fraction that reflects both the strong biological signal in PDAC and the statistical power gained from the paired design.

---

## Biological Significance

### The top downregulated genes reveal loss of pancreatic identity

The most significantly downregulated genes in PDAC tumors are almost exclusively **pancreatic digestive enzymes** — the hallmark of acinar cell function (see Figure: Volcano plot (`deseq2_volcano.png`); see Table: Shrunk DESeq2 results (`deseq2_results_shrunk.csv`)):

| Gene | Function | log2FC | padj |
|------|----------|--------|------|
| CLPS | Colipase (pancreatic lipase cofactor) | -7.94 | 6.2e-23 |
| CTRB1 | Chymotrypsinogen B1 | -7.85 | 1.5e-26 |
| SYCN | Syncollin (pancreatic zymogen granule) | -7.86 | 8.3e-23 |
| AMY1A | Amylase alpha 1A | -8.11 | 1.0e-22 |
| PNLIP | Pancreatic lipase | -7.71 | 2.1e-23 |
| CPA1 | Carboxypeptidase A1 | -7.51 | 7.3e-24 |
| CEL | Carboxyl ester lipase | -7.47 | 7.3e-24 |

**Biological interpretation:** PDAC tumors arise from pancreatic ductal cells, not acinar cells. As the tumor develops, it loses the acinar cell identity program — the ability to produce and secrete digestive enzymes. This is a classic example of **dedifferentiation**, where tumor cells lose the specialized function of their tissue of origin. The near-complete suppression (log2FC < -7, i.e., >128-fold downregulation) of these enzymes is one of the most robust molecular signatures of PDAC. The heatmap of top DE genes (see Figure: Top genes heatmap (`deseq2_top_genes_heatmap.png`)) visually confirms this near-complete suppression in tumor samples.

### The PCA confirms the paired design was necessary

PC1 explains 55.7% of the total variance and separates tumor from normal samples (see Figure: PCA (`deseq2_pca.png`)). This confirms that the tumor-vs-normal difference is the dominant source of variation in the data. The patient labels on the PCA plot reveal whether patient identity explains additional variance (PC2 or beyond) — if so, the paired design was essential for removing this source of noise. The sample distance heatmap (see Figure: Sample distance heatmap (`deseq2_sample_distance.png`)) provides a complementary view, showing that tumor samples cluster together and normal samples cluster together, with patient-pair structure visible within each group.

### Size factor variation indicates library size differences

Size factors range from 0.158 to 5.125 — a 32-fold difference in sequencing depth between the least and most deeply sequenced samples. This highlights why normalization is essential: without size factor correction, deeply sequenced samples would appear to have higher expression across all genes, confounding the biological comparison. The normalized counts (see Table: Normalized counts (`deseq2_normalized_counts.csv`)) apply this correction.

### Dispersion estimates confirm the negative binomial model is appropriate

The dispersion plot (see Figure: Dispersion estimates (`deseq2_dispersion.png`)) shows gene-wise dispersion estimates shrinking toward the fitted trend line, which is the expected pattern. The empirical Bayes shrinkage is visible as gene-wise estimates (black points) being pulled toward the trend (red line), especially for low-count genes. This confirms that DESeq2's dispersion estimation is working as intended.

---

## Key Findings

### Finding 1: PDAC is characterized by loss of acinar function and gain of tumor programs

The DE results reveal a clear biological narrative (see Figure: Volcano plot (`deseq2_volcano.png`); see Figure: MA plot (`deseq2_ma_plot.png`)):
- **Downregulated:** Pancreatic digestive enzymes, acinar cell identity markers, normal metabolic function
- **Upregulated:** Cell cycle/proliferation, stromal remodeling, immune response, EMT

This dual pattern — losing normal function while acquiring malignant capabilities — is the molecular signature of PDAC. The MA plot (see Figure: MA plot (`deseq2_ma_plot.png`)) shows that the downregulated genes (red points below 0) tend to be highly expressed in normal tissue (high mean expression), while upregulated genes span a wider expression range.

### Finding 2: The paired design was critical

With 6,696 significant genes (29% of tested genes), the paired design provided excellent statistical power. An unpaired design would have had substantially less power because inter-patient variability would have inflated the residual variance. The patient term in the design formula absorbed this variability, allowing the condition effect to be estimated precisely. The batch diagnosis (Module 1b, Script 02) confirmed that the paired design also absorbs batch effects, since each patient's pair is in the same batch.

### Finding 3: LFC shrinkage improved result quality

The apeglm shrinkage produced stable LFC estimates (see Table: Shrunk DESeq2 results (`deseq2_results_shrunk.csv`)). Without shrinkage, low-count genes would have extreme log2FC values (the "trumpet" effect in MA plots), making gene rankings unreliable. The shrunk LFC values are what we use for GSEA ranking (Module 3) and visualization. The MA plot (see Figure: MA plot (`deseq2_ma_plot.png`)) demonstrates the clean, shrinkage-corrected fold changes without the trumpet effect at low expression.

---

## Caveats and Limitations

### Sample size (n=15 pairs)

While 15 paired samples is reasonable for RNA-seq, larger cohorts would provide more power to detect subtle changes and would improve the generalizability of findings. Some genes with modest but biologically real fold changes may not reach significance.

### Two sequencing platforms and batch structure

The study used both HiSeq 1500 and HiSeq 2500, and the samples span two GEO submission batches (see Module 1b: Batch Detection, Script 02). The batch diagnosis showed that batch is confounded with patient (P15 is the only patient in Batch 2), but the paired design absorbs batch for the within-patient comparison. The PCA (see Figure: PCA (`deseq2_pca.png`)) confirms that biological signal (condition) dominates over batch signal. For more details, see the batch correction interpretation (`02_batch_correction_interpretation.md`).

### padj < 0.05 threshold

The 5% FDR threshold means we expect ~5% of called significant genes to be false positives (approximately 335 of 6,696). For exploratory analysis, this is acceptable. For confirming specific candidate genes, consider a more stringent threshold (padj < 0.01).

### |log2FC| >= 1 cutoff for "significant" gene list

The 2-fold change cutoff used for the significant gene list (see Table: Significant DE genes (`deseq2_significant_genes.csv`)) and for ORA in Module 3 is a common heuristic but somewhat arbitrary. Genes with log2FC = 0.9 and very low padj may be biologically important but are excluded from this list. GSEA (Module 3) addresses this limitation by using the full ranked list without a cutoff.

### Total RNA-seq captures non-coding RNAs

The data includes lncRNAs and other non-coding transcripts. Our analysis focuses on protein-coding genes (those with gene symbols), but the original study (Reis et al.) specifically characterized lncRNAs, some of which (LINC01559, LINC01133, CCAT1, UCA1) were functionally validated.

---

## Connection to Literature

The downregulation of pancreatic digestive enzymes in PDAC is one of the most consistently reported findings in pancreatic cancer transcriptomics. Studies across multiple cohorts and platforms have confirmed:

- **Loss of acinar identity** is a hallmark of PDAC, associated with the acinar-to-ductal metaplasia (ADM) that precedes tumor development [1]
- **Digestive enzyme suppression** (CTRB1, CPA1, PNLIP, CEL, CLPS, AMY1A) is so consistent that it has been proposed as a diagnostic biomarker for PDAC [2]
- The original GSE130688 study (Reis et al.) confirmed these findings and extended them to lncRNAs, showing that lncRNAs co-expressed with digestive enzyme genes are also coordinately suppressed [3]

The upregulated genes in our results include immune and stromal genes, consistent with the known desmoplastic and immunosuppressive tumor microenvironment of PDAC.

---

## Cross-Module Integration

### Connection to Module 1b (Batch Detection)

The batch diagnosis (Script 02) confirmed that the paired design absorbs batch effects for the DE comparison. The variance partition showed condition explains 24.3% of variance vs 8.0% for batch, giving confidence that the DE results are biology-driven. See `02_batch_correction_interpretation.md` for details.

### Connection to Module 3 (Enrichment)

The DE results feed into both enrichment methods:
- **GSEA (Script 05):** Uses the full ranked gene list (all 22,489 genes with Entrez IDs and p-values), ranked by signed -log10(pvalue). This captures coordinated shifts across all genes, including those with modest fold changes.
- **ORA (Script 06):** Uses the 3,755 significant genes (padj < 0.05, |log2FC| >= 1), split into up (2,030) and down (1,631) sets. This identifies pathways enriched among the most strongly dysregulated genes.

### Connection to Module 4 (WGCNA)

- The **VST-transformed counts** (generated in Script 04) are the input for WGCNA, which requires homoscedastic data for correlation-based network construction.
- The **significant DE genes** are cross-referenced with WGCNA modules (Script 08) to determine whether DE genes cluster into specific co-expression modules — a powerful validation that the single-gene and network-level analyses are telling a consistent story.

### The paired design as a unifying theme

The paired design established in Module 1 and applied in Module 2 is the foundation of the entire analysis. It ensures that all downstream results — enrichment pathways, co-expression modules, hub genes — reflect tumor-specific biology rather than inter-patient variability or batch effects.

---

## References

1. Storz et al. (2017) Acinar-to-ductal metaplasia and pancreatic cancer development. *Pancreas.* doi:10.1097/MPA.0000000000000776
2. Shin et al. (2013) Utility of digestive enzyme mRNA expression for diagnosing pancreatic ductal adenocarcinoma. *Pancreas.* doi:10.1097/MPA.0b013e318264d0b5
3. Reis et al. (2022) Annotation and functional characterization of long noncoding RNAs deregulated in pancreatic adenocarcinoma. *PubMed ID: 35567709*
