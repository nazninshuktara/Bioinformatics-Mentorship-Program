# 10. Sequencing QC Basics

## Overview

Before any alignment or downstream analysis, raw sequencing reads must be quality-checked. Poor-quality reads can introduce false variants, misalignment, and biased expression estimates. This file covers the core QC concepts used to interpret tools like **FastQC** and **MultiQC**.

---

## 1. Phred Quality Score

- Encodes the probability that a given base call is incorrect
- Formula: **Q = -10 × log10(P)**, where P = probability of error

| Phred Score (Q) | Error Probability | Base Call Accuracy |
|------------------|--------------------|----------------------|
| Q10 | 1 in 10 | 90% |
| Q20 | 1 in 100 | 99% |
| Q30 | 1 in 1,000 | 99.9% |
| Q40 | 1 in 10,000 | 99.99% |

- **Q30 is the widely used benchmark** — a base with Q30 or higher is considered high-confidence
- Quality scores are ASCII-encoded in the 4th line of each FASTQ read (Phred+33 encoding is standard for modern Illumina data)

---

## 2. Key FastQC Metrics

| Metric | What It Shows | Common Issue Flagged |
|--------|----------------|------------------------|
| **Per base sequence quality** | Quality score distribution at each read position | Quality often drops toward the 3' end (normal SBS chemistry artifact) |
| **Per sequence quality scores** | Distribution of average quality across all reads | Bimodal distribution may indicate a subset of poor reads |
| **Per base sequence content** | %A/T/G/C at each position | Bias at read start can indicate adapter contamination or non-random priming |
| **Per sequence GC content** | GC% distribution across reads | Deviation from expected can indicate contamination |
| **Sequence duplication levels** | % of duplicate reads | High duplication can indicate low-complexity library or over-amplification (PCR duplicates) |
| **Overrepresented sequences** | Sequences appearing more than expected | Often adapter sequences or contamination |
| **Adapter content** | Presence of sequencing adapters in reads | Needs adapter trimming before alignment |

---

## 3. Coverage vs Depth (recap + RNA-seq context)

- **Depth (for RNA-seq)** – usually expressed as total reads per sample, not per-base coverage like DNA-seq
- Typical bulk RNA-seq depth: **20-30 million reads/sample** for standard differential expression
- Higher depth needed for: low-expression gene detection, isoform-level analysis, allele-specific expression

---

## 4. Common QC Issues & Fixes

| Issue | Likely Cause | Fix |
|-------|---------------|-----|
| Low per-base quality at 3' end | Normal SBS signal decay | Trim low-quality bases (Trimmomatic/Cutadapt) |
| Adapter contamination | Short insert fragments | Adapter trimming |
| High duplication | PCR over-amplification or low input material | Flag/note (don't always remove for RNA-seq — high expression genes naturally show duplication) |
| GC content skew | Contamination or library bias | Investigate overrepresented sequences, check organism source |
| Low overall quality | Sequencing run/flow cell issue | Consider re-sequencing if severe |

> **Note for RNA-seq specifically:** unlike DNA-seq, high duplication rates are often *expected and biologically valid* (highly expressed genes will naturally produce many identical reads) — so PCR duplicate removal is generally NOT recommended for standard bulk RNA-seq differential expression.

---

## 5. MultiQC

- Aggregates FastQC (and other tool) reports across many samples into a single interactive HTML report
- Essential when working with multiple samples (e.g., GEO datasets with 6-30+ samples) — spot outlier samples quickly before proceeding to alignment

---

## Why This Matters for Bioinformatics / RNA-seq

- QC is the **first checkpoint** in every pipeline — catching a bad sample here saves hours of downstream troubleshooting.
- Understanding *why* 3' quality drop-off is normal (vs a red flag) prevents unnecessary over-trimming, which can reduce mapping rate.
- MultiQC reports are typically the first thing checked when starting analysis on a new GEO dataset — directly relevant to the RNA-seq pipeline work already underway.

---

## References
- FastQC documentation (Babraham Bioinformatics)
- MultiQC documentation (multiqc.info)
- Ewels, P. et al. (2016). "MultiQC: summarize analysis results." *Bioinformatics*.