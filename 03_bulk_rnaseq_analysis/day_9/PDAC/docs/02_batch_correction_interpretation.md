# Batch Effect Diagnosis: Interpretation

## Figures and Tables Referenced

**Figures:**
- `batch_pca.png` — Three-panel PCA colored by batch, condition, and patient
- `batch_rle_plot.png` — RLE (Relative Log Expression) boxplot by batch
- `batch_variance_partition.png` — Variance partition boxplot (batch vs condition vs patient)

**Tables:**
- `batch_variance_partition.csv` — Per-gene variance fractions for each factor
- `batch_variance_partition_summary.csv` — Mean and median variance explained per factor

---

## Results Summary

### Batch structure

GSE130688 contains two batches, identified by GSM accession number ranges:

- **Batch 1** (GSM37xxxxx): 28 samples from patients P01-P14
- **Batch 2** (GSM44xxxxx): 2 samples from patient P15 only

Batch is **perfectly confounded with patient** — each patient appears in exactly one batch, and P15 is the sole patient in Batch 2 (see the confounding cross-tabulation printed by Script 02).

### PCA results

The PCA (see Figure: PCA by batch/condition/patient (`batch_pca.png`)) shows:

- **PC1 explains 49.1% of variance** and separates tumor from normal samples — the biological signal (condition) is the dominant axis of variation. This is the desired outcome: biology drives the first principal component, not batch.
- **PC2 explains 11.7% of variance** and partially separates patients, reflecting inter-individual variation.
- The two Batch 2 samples (P15 tumor and normal) do not form a distinct outlying cluster — they fall within the range of the Batch 1 samples on both PC1 and PC2. This indicates that the batch effect, if present, is not large enough to dominate the global expression structure.

The three-panel layout lets students directly compare which factor drives separation: condition (panel 2) clearly separates along PC1, while batch (panel 1) does not produce a distinct cluster.

### RLE results

The RLE plot (see Figure: RLE plot by batch (`batch_rle_plot.png`)) shows:

- All sample RLE medians fall within a narrow range (-0.057 to 0.086), close to the ideal of 0.
- Batch 1 RLE medians range from -0.057 to 0.086.
- Batch 2 RLE medians range from -0.043 to 0.

The RLE distributions are well-centered with similar spreads across both batches, indicating no major library composition or size biases between batches. This is consistent with the PCA finding: batch effects are minimal at the library level.

### Variance partition results

The variance partition (see Figure: Variance partition (`batch_variance_partition.png`); see Table: Variance partition summary (`batch_variance_partition_summary.csv`)) quantifies the percentage of expression variance explained by each factor across the top 2,000 most variable genes:

| Factor | Mean variance explained | Median variance explained |
|--------|------------------------|--------------------------|
| **patient** | 34.62% | 30.39% |
| **condition** | 24.32% | 23.45% |
| **batch** | 8.00% | 4.54% |

**Interpretation:**
- **Patient** explains the most variance (34.6%) — this is expected. Inter-individual genetic and environmental variation creates substantial baseline expression differences between patients. The paired design controls for this by comparing within-patient.
- **Condition** (tumor vs normal) explains 24.3% — this is the biological signal of interest, and it is strong. In a well-powered study, the biological variable should explain a substantial fraction of variance.
- **Batch** explains only 8.0% (median 4.5%) — substantially less than both patient and condition. This confirms that batch effects, while present, are not the dominant source of variation.

**Important caveat on confounding:** Because batch is confounded with patient, the sequential ANOVA attributes shared batch+patient variance to whichever factor is entered first (batch, in our case). This means the 8% attributed to batch may include some variance that is truly patient-driven, and the 34.6% attributed to patient may undercount the batch contribution. The confounding makes precise decomposition impossible — but the key takeaway holds: the biological signal (condition, 24.3%) is robust and clearly exceeds the batch signal.

---

## Biological Significance

### Why this matters for the PDAC analysis

The variance partition confirms that the **tumor-vs-normal biological signal is the second strongest source of variation** in the data, after inter-patient variation (which the paired design controls). Batch effects are present but minor (8% mean). This gives us confidence that the differential expression results (Module 2/Script 03), enrichment analysis (Module 3/Scripts 05-06), and co-expression network (Module 4/Scripts 07-08) are driven primarily by biology, not technical artifacts.

### The paired design as batch control

The most important biological insight from this module is that **the experimental design itself is the batch correction**. Because each patient's tumor and adjacent normal tissue were processed in the same batch, the paired DESeq2 design (`~ patient + condition`) computes the tumor-vs-normal log fold change within each patient — and since both samples share the same batch, any batch effect cancels out in the within-patient difference.

This is a general principle: **blocking on a confounded variable absorbs its effect.** The paired design is a special case of a randomized block design, where patient is the block. When the blocking variable (patient) is confounded with the nuisance variable (batch), the block design controls both simultaneously.

---

## Key Findings

1. **Batch is confounded with patient** (P15 only in Batch 2) — confirmed by cross-tabulation.
2. **Biological signal dominates**: condition explains 24.3% of variance vs 8.0% for batch (see Table: Variance partition summary (`batch_variance_partition_summary.csv`)).
3. **PCA confirms biology drives PC1** (49.1% variance) — tumor and normal separate clearly (see Figure: PCA by batch/condition/patient (`batch_pca.png`)).
4. **RLE shows no major library bias** — all medians near 0 (see Figure: RLE plot by batch (`batch_rle_plot.png`)).
5. **No batch correction needed** for the DE comparison — the paired design absorbs batch.
6. **WGCNA caveat**: P15's two samples may show batch-influenced positions in the co-expression network (Module 4/Script 07). This is noted but not corrected, as ComBat would be unstable with n=2 in Batch 2.

---

## Caveats

1. **Confounding prevents precise variance decomposition.** The 8% batch estimate may include patient-shared variance, and the 34.6% patient estimate may undercount batch. The sequential ANOVA order (batch first) is the most conservative for detecting batch effects.
2. **Only 2 samples in Batch 2.** Any batch-specific estimate (for ComBat or similar) would be based on 2 data points — far too few for stable estimation. This is another reason correction is inadvisable here.
3. **Batch detection is limited by confounding.** If batch and patient were not confounded (e.g., each patient split across batches), we could cleanly separate batch from patient effects. The confounding means we rely on the design logic (paired) rather than empirical correction.
4. **WGCNA is more sensitive to batch than DESeq2.** WGCNA uses all samples simultaneously in correlation-based network construction, so P15's batch-specific expression patterns could influence module assignments. The DE comparison is protected by the paired design; the network analysis is not. This caveat is noted in the WGCNA interpretation (Module 4).
5. **GSM-based batch inference is indirect.** We infer batch from GSM accession number ranges, not from explicit batch metadata in GEO. While large GSM gaps reliably indicate separate submissions, the exact technical differences between batches (different instruments? different dates?) are not documented.

---

## Literature Context

Batch effects are recognized as a critical challenge in high-throughput genomics. Leek et al. (2010) estimated that batch effects affect more than 50% of publicly available high-throughput genomics datasets and can completely obscure biological signal if not addressed [1]. The ComBat method (Johnson et al. 2007) remains the most widely used batch correction tool, but it requires adequate sample sizes per batch and non-confounded designs [2]. Surrogate variable analysis (SVA) and RUV (Risso et al. 2014) offer alternatives that estimate hidden batch factors from the data itself [3].

The key lesson from this module — that experimental design (blocking/pairing) can substitute for computational correction — is emphasized in the experimental design literature. A well-randomized or well-blocked design is always preferable to post-hoc correction, because correction can introduce artifacts and relies on assumptions that may not hold.

---

## Cross-Module Integration

### How batch awareness flows into downstream modules

- **Module 2 (DESeq2, Script 03)**: The paired design `~ patient + condition` is retained as-is. No batch term is added (would be collinear). The batch diagnosis confirms this design is sufficient — condition explains 3x more variance than batch.
- **Module 3 (Enrichment, Scripts 05-06)**: GSEA and ORA use the DESeq2 results, which are already batch-controlled via the paired design. No additional batch handling needed.
- **Module 4 (WGCNA, Scripts 07-08)**: The co-expression network uses VST-transformed data from all 30 samples. P15's samples (Batch 2) participate in the network without batch correction. This is a caveat: P15's module eigengene values and gene-module assignments may be influenced by batch. The WGCNA interpretation (Module 4) notes this. With only 2 of 30 samples affected, the impact on module discovery is expected to be minimal, but individual-level conclusions about P15 should be interpreted cautiously.

---

## References

[1] Leek JT, Scharpf RB, Bravo HC, et al. Tackling the widespread and critical impact of batch effects in high-throughput data. *Nat Rev Genet.* 2010;11(10):733-739. doi:10.1038/nrg2825

[2] Johnson WE, Li C, Rabinovic A. Adjusting batch effects in microarray expression data using empirical Bayes methods. *Biostatistics.* 2007;8(1):118-127.

[3] Risso D, Ngai J, Speed TP, Dudoit S. Normalization of RNA-seq data using factor analysis of control genes or samples. *Nat Biotechnol.* 2014;32(9):896-902.
