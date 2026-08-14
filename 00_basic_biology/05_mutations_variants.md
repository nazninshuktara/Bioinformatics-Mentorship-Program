# 05. Mutations & Genetic Variants

## Overview

A **mutation** is a change in the DNA sequence. Mutations are the raw material of genetic variation and are central to understanding disease, evolution, and variant calling in bioinformatics.

---

## 1. Types of Mutations by Scale

| Type | Description | Example |
|------|-------------|---------|
| **Point mutation (SNP/SNV)** | Single nucleotide change | A→G |
| **Insertion** | Extra nucleotide(s) added | — |
| **Deletion** | Nucleotide(s) removed | — |
| **Indel** | Insertion or deletion (small, <50 bp) | — |
| **Copy Number Variant (CNV)** | Large duplication/deletion of DNA segments | — |
| **Structural Variant (SV)** | Large-scale rearrangements: inversions, translocations, duplications | — |

---

## 2. Point Mutations — Functional Classification

| Type | Effect |
|------|--------|
| **Silent (synonymous)** | Codon changes but codes for same amino acid — no protein change |
| **Missense (non-synonymous)** | Codon changes to a different amino acid |
| **Nonsense** | Codon changes to a premature stop codon — truncated protein |
| **Frameshift** | Insertion/deletion not divisible by 3 — shifts reading frame, usually severe |
| **In-frame indel** | Insertion/deletion divisible by 3 — adds/removes amino acid(s), reading frame preserved |

---

## 3. Mutation by Location

| Location | Consequence |
|----------|-------------|
| Coding region (exon) | May alter protein sequence |
| Intron | Usually no direct protein effect, but can disrupt splice sites |
| Splice site | Can cause exon skipping/intron retention |
| Promoter/regulatory region | Can alter gene expression levels |
| UTR | Can affect mRNA stability, translation efficiency |

---

## 4. Germline vs Somatic Mutations

- **Germline mutations** – present in reproductive cells, heritable, present in all cells of offspring
- **Somatic mutations** – occur in non-reproductive cells, not heritable, relevant in cancer genomics

---

## 5. SNP vs SNV vs Variant (terminology clarification)

- **SNP (Single Nucleotide Polymorphism)** – common variant in population (>1% allele frequency, by classical definition)
- **SNV (Single Nucleotide Variant)** – general term for any single-base change, regardless of frequency
- **Variant** – umbrella term used in VCF files, includes SNVs, indels, etc.

---

## 6. Zygosity

| Term | Meaning |
|------|---------|
| **Homozygous** | Same allele on both chromosome copies |
| **Heterozygous** | Different alleles on each chromosome copy |

---

## Why This Matters for Bioinformatics / RNA-seq

- Variant classification underlies **variant calling pipelines** (GATK, bcftools) and **VCF file interpretation**.
- Understanding synonymous vs non-synonymous mutations is essential for **variant effect prediction** (VEP, SnpEff, ANNOVAR).
- In RNA-seq specifically, splice-site mutations can be detected as altered exon usage or novel junctions.
- Somatic vs germline distinction is directly relevant if the mentorship program later covers cancer transcriptomics or AMR variant detection in pathogens.

---

## References
- Molecular Biology of the Cell (Alberts et al.)
- GATK Best Practices documentation
- Ensembl Variant Effect Predictor (VEP) documentation