# 06. Genomics Terminology: Genome, Transcriptome, Exome, Proteome

## Overview

These terms describe different "omes" — complete sets of biological molecules at different levels of gene expression. Clarity here prevents confusion when reading papers or choosing the right sequencing approach (WGS vs RNA-seq vs exome sequencing).

---

## 1. Genome

- The **complete set of DNA** in an organism, including coding and non-coding regions
- Fixed (mostly) — same across nearly all cells of an organism
- Studied via **Whole Genome Sequencing (WGS)**

---

## 2. Transcriptome

- The **complete set of RNA transcripts** produced by the genome, in a specific cell/tissue/condition, at a specific time
- Dynamic — changes based on cell type, developmental stage, environmental conditions, disease state
- Includes mRNA, rRNA, tRNA, and non-coding RNAs (miRNA, lncRNA, etc.)
- Studied via **RNA-seq** (bulk or single-cell)

---

## 3. Exome

- The subset of the genome consisting of **all exons** (protein-coding regions)
- ~1-2% of the human genome, but contains the majority of known disease-causing variants
- Studied via **Whole Exome Sequencing (WES)** — more cost-effective than WGS for coding variant discovery

---

## 4. Proteome

- The **complete set of proteins** expressed by a cell/tissue/organism at a given time
- Most dynamic and functionally complex layer — includes post-translational modifications, protein folding, interactions
- Studied via **mass spectrometry-based proteomics**

---

## 5. Comparison Table

| Omics Layer | Molecule | Stability | Sequencing Method | Relative Size (human) |
|-------------|----------|-----------|-------------------|------------------------|
| Genome | DNA | Static | WGS | ~3.1 Gb |
| Exome | DNA (coding) | Static | WES | ~1-2% of genome |
| Transcriptome | RNA | Dynamic | RNA-seq | Varies by cell/condition |
| Proteome | Protein | Highly dynamic | Mass spectrometry | ~20,000+ proteins (with isoforms/PTMs, much larger complexity) |

---

## 6. Central Dogma Connection
```
Genome (DNA) → Transcriptome (RNA) → Proteome (Protein)
[static] [dynamic] [most dynamic]
```
- Genome = the blueprint (mostly fixed)
- Transcriptome = which parts of the blueprint are being "read" right now
- Proteome = the functional machinery actually built from that reading

---

## Why This Matters for Bioinformatics / RNA-seq

- RNA-seq specifically measures the **transcriptome** — this is why expression can differ between tissues/conditions even though the genome is identical.
- Understanding this hierarchy clarifies why differential expression (DESeq2/EdgeR) reflects **transcriptional regulation**, not genetic changes.
- Choosing between WGS, WES, and RNA-seq depends on the biological question — variant discovery vs expression profiling.

---

## References
- Molecular Biology of the Cell (Alberts et al.)
- Ensembl / GENCODE documentation
- NHGRI Genomic terminology glossary