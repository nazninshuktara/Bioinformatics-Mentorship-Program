# 11. Pathogen Genomics Basics

## Overview

Given the program's focus on **infectious disease research**, understanding how pathogen genomes differ from human genomes — and how they're studied — is foundational before moving into pathogen-specific bioinformatics workflows (outbreak genomics, AMR detection, variant surveillance).

---

## 1. Bacterial Genomes

- Typically a **single circular chromosome**, ~1-10 Mb (much smaller than human's ~3.1 Gb)
- Gene-dense, minimal non-coding DNA, no introns (mostly)
- Often carry **plasmids** – small, circular, extrachromosomal DNA
  - Plasmids frequently carry **antibiotic resistance genes (AMR)** and virulence factors
  - Can be transferred between bacteria (horizontal gene transfer) — important for AMR spread
- Reproduce by binary fission; genome replicates as a whole

---

## 2. Viral Genomes

- Highly variable: can be DNA or RNA, single-stranded (ss) or double-stranded (ds)

| Genome Type | Examples |
|-------------|----------|
| dsDNA | Herpesvirus, Adenovirus |
| ssDNA | Parvovirus |
| dsRNA | Rotavirus |
| ssRNA (+) (positive-sense) | SARS-CoV-2, Dengue |
| ssRNA (-) (negative-sense) | Influenza, Ebola |
| Retrovirus (ssRNA, reverse-transcribed) | HIV |

- Much smaller genomes than bacteria (few kb to ~200 kb)
- RNA viruses mutate faster (no proofreading in RNA-dependent RNA polymerase) — relevant for tracking viral evolution/variants
- No independent metabolism — obligate intracellular parasites, rely on host cell machinery

---

## 3. Bacterial vs Viral Genome — Quick Comparison

| Feature | Bacteria | Virus |
|---------|----------|-------|
| Genome type | DNA (circular chromosome) | DNA or RNA |
| Size | ~1-10 Mb | ~1kb - 200kb |
| Independent replication | Yes | No (needs host cell) |
| Plasmids | Common | Absent |
| Mutation rate | Lower | Higher (esp. RNA viruses) |

---

## 4. Antimicrobial Resistance (AMR) — Genomic Basis

- Resistance can arise via:
  - **Chromosomal mutations** (e.g., target site modification)
  - **Acquisition of resistance genes** via plasmids, transposons, or integrons (horizontal gene transfer)
- Common AMR gene databases used in bioinformatics: **CARD**, **ResFinder**, **NCBI AMRFinderPlus**
- AMR detection workflow (conceptual): WGS reads → assembly or direct read mapping → compare against AMR gene database → report resistance genes/mutations present

---

## 5. Outbreak & Variant Surveillance (context)

- **Variant calling** in pathogens tracks mutations relevant to:
  - Transmissibility
  - Immune escape (e.g., SARS-CoV-2 spike protein variants)
  - Drug resistance
- **Phylogenetics** – building trees from pathogen genome sequences to trace transmission chains and outbreak origins
- Relevant tools (context, not required yet): Nextstrain, Pangolin (SARS-CoV-2 lineage), snippy (bacterial variant calling)

---

## 6. Host-Pathogen Interaction (brief)

- Innate immune response – first-line, non-specific (e.g., interferons, inflammation)
- Adaptive immune response – specific, involves antibodies (B cells) and T cells, provides memory
- Relevant for RNA-seq: host transcriptomic response to infection is itself a common RNA-seq study design (e.g., comparing infected vs uninfected host tissue expression)

---

## Why This Matters for Bioinformatics / RNA-seq

- Small, dense pathogen genomes mean different pipeline considerations than human RNA-seq (e.g., less concern about intron-spanning alignment for bacteria).
- Understanding plasmid-based AMR gene transfer is essential groundwork for future AMR genomics modules in the program.
- Host-pathogen RNA-seq studies (host response to infection) directly connect back to the bulk RNA-seq skills already being built — same DESeq2/tximport pipeline, different biological question (infected vs control host samples).

---

## References
- Molecular Biology of the Cell (Alberts et al.)
- CARD (Comprehensive Antibiotic Resistance Database) documentation
- Nextstrain documentation (nextstrain.org)
- CDC / WHO AMR surveillance resources