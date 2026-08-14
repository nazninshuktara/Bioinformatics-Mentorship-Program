# 04. Genome Organization

## Overview

Genome organization refers to how genetic material is packaged, structured, and arranged within a cell. It differs significantly between prokaryotes and eukaryotes, and understanding it is key to interpreting genome assemblies and sequencing data.

---

## 1. Prokaryotic Genome Organization

- Typically a **single circular chromosome**, located in the **nucleoid** (no membrane-bound nucleus)
- Compact genome, gene-dense, few non-coding regions
- May contain **plasmids** – small circular DNA molecules, often carrying antibiotic resistance genes (relevant for infectious disease/AMR work)
- No histones; DNA supercoiled with help of nucleoid-associated proteins

---

## 2. Eukaryotic Genome Organization

- DNA is **linear**, organized into multiple **chromosomes**, housed in a membrane-bound **nucleus**
- DNA is packaged with **histone proteins** into **chromatin**
- Levels of packaging:
  1. DNA double helix
  2. Nucleosomes (DNA wrapped around histone octamers) — "beads on a string"
  3. 30nm chromatin fiber
  4. Looped domains
  5. Condensed chromosome (during cell division)

### Chromatin States

| State | Description |
|-------|-------------|
| **Euchromatin** | Loosely packed, transcriptionally active |
| **Heterochromatin** | Tightly packed, transcriptionally silent/inactive |

---

## 3. Ploidy

- **Haploid (n)** – one set of chromosomes (e.g., gametes)
- **Diploid (2n)** – two sets of chromosomes (e.g., human somatic cells, 46 chromosomes / 23 pairs)
- Polyploidy is common in plants, rare in animals

---

## 4. Genome Size & Complexity

- Genome size does not necessarily correlate with organismal complexity ("C-value paradox")
- Human genome: ~3.1 billion base pairs, ~20,000 protein-coding genes
- Large portion of eukaryotic genomes is **non-coding DNA** (regulatory elements, introns, repetitive elements, transposons)

### Repetitive Elements
- **Transposable elements (TEs)** – ~45% of human genome (e.g., LINEs, SINEs like Alu elements)
- **Tandem repeats** – microsatellites, minisatellites, telomeric repeats
- Relevant for read mapping (multi-mapping reads) and structural variant detection

---

## 5. Organellar Genomes

- **Mitochondrial DNA (mtDNA)** – circular, maternally inherited, separate from nuclear genome
- **Chloroplast DNA (cpDNA)** – in plants, circular, involved in photosynthesis genes

---

## Why This Matters for Bioinformatics / RNA-seq

- Chromatin state affects **gene expression** – relevant when interpreting differential expression alongside epigenomic data.
- Repetitive elements complicate **read alignment** — multi-mapped reads need special handling in pipelines (e.g., STAR's multi-mapper settings).
- Plasmid/genome organization knowledge is directly relevant for **infectious disease genomics** (bacterial plasmid-borne AMR genes).
- Ploidy matters for **variant calling** (heterozygous vs homozygous variant interpretation).

---

## References
- Molecular Biology of the Cell (Alberts et al.)
- Ensembl / UCSC Genome Browser documentation
- NCBI Genome resource