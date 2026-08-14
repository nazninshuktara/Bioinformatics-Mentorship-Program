# 02. DNA & RNA Structure

## Overview

DNA and RNA are **nucleic acids** — polymers built from repeating monomer units called **nucleotides**. They store and transmit genetic information.

---

## 1. Nucleotide Structure

Each nucleotide has 3 components:

1. **Pentose sugar** – deoxyribose (DNA) or ribose (RNA)
2. **Phosphate group** – links nucleotides together via phosphodiester bonds
3. **Nitrogenous base** – purine or pyrimidine

### Base Types

| Category | Bases | Found in |
|----------|-------|----------|
| Purines (double-ring) | Adenine (A), Guanine (G) | DNA & RNA |
| Pyrimidines (single-ring) | Cytosine (C), Thymine (T) | DNA only |
| Pyrimidines (single-ring) | Cytosine (C), Uracil (U) | RNA only |

- **Uracil (U)** replaces **Thymine (T)** in RNA.

---

## 2. DNA vs RNA — Key Differences

| Feature | DNA | RNA |
|---------|-----|-----|
| Sugar | Deoxyribose (no OH at 2') | Ribose (OH at 2') |
| Strand | Double-stranded (usually) | Single-stranded (usually) |
| Bases | A, T, G, C | A, U, G, C |
| Stability | More stable | Less stable (2'-OH makes it more reactive) |
| Structure | Double helix | Varied (hairpins, loops, folded structures) |
| Function | Long-term genetic storage | Gene expression, catalysis, regulation |

---

## 3. Base Pairing (DNA)

- **A pairs with T** (2 hydrogen bonds)
- **G pairs with C** (3 hydrogen bonds)
- Strands are **antiparallel**: one runs 5'→3', the complementary strand runs 3'→5'
- Complementary base pairing is the basis of:
  - DNA replication
  - Transcription (template strand pairing with RNA)
  - PCR primer design
  - Sequencing read alignment

---

## 4. DNA Double Helix

- Discovered structurally by **Watson & Crick (1953)**, based on Rosalind Franklin's X-ray diffraction data (Photo 51).
- Right-handed double helix
- **Major groove** and **minor groove** — sites where proteins (transcription factors) bind DNA
- ~10.5 base pairs per helical turn

---

## 5. RNA Secondary Structure

Unlike DNA, RNA is usually single-stranded but folds back on itself to form secondary structures:

- **Hairpin loops / stem-loops** – common in tRNA, rRNA, regulatory elements
- **Pseudoknots**
- **Internal loops / bulges**

These structures are functionally important (e.g., tRNA cloverleaf structure, riboswitches, miRNA precursors).

---

## 6. Types of RNA (Structural Overview)

| RNA Type | Structure Note |
|----------|----------------|
| mRNA | Linear, capped (5') and polyadenylated (3') in eukaryotes |
| tRNA | Cloverleaf secondary structure → folds into L-shape |
| rRNA | Complex folded structure, forms ribosome scaffold with proteins |
| miRNA | ~22 nt, derived from hairpin precursor (pri-miRNA → pre-miRNA → mature miRNA) |
| lncRNA | >200 nt, diverse structures, regulatory functions |

---

## Why This Matters for Bioinformatics / RNA-seq

- Base-pairing rules underlie **read alignment**, **primer/probe design**, and **PCR**.
- RNA secondary structure affects **library prep efficiency** and **reverse transcription** (highly structured regions can cause RT dropout).
- Knowing sugar/base differences helps in understanding why RNA is more prone to degradation — relevant for **RNA integrity (RIN score)** checks before sequencing.
- miRNA/lncRNA structural knowledge is foundational before moving into small RNA-seq or regulatory transcriptomics.

---

## References
- Watson, J.D. & Crick, F.H.C. (1953). "Molecular Structure of Nucleic Acids." *Nature*.
- Molecular Biology of the Cell (Alberts et al.)
- NCBI Bookshelf – Nucleic Acid structure