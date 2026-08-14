# 01. Central Dogma of Molecular Biology

## Overview

The **Central Dogma** describes the flow of genetic information within a biological system:
```
DNA  --(Transcription)-->  RNA  --(Translation)-->  Protein
```
First proposed by **Francis Crick (1958)**. It explains how genetic instructions stored in DNA are used to build functional proteins that carry out cellular processes.

---
## 1. Replication (DNA → DNA)

- Process by which DNA makes a copy of itself before cell division.
- Ensures genetic continuity across generations of cells.
- Key enzyme: **DNA polymerase**
- Semi-conservative: each new DNA molecule has one old strand + one new strand.

---

## 2. Transcription (DNA → RNA)

- DNA sequence is copied into messenger RNA (mRNA) inside the **nucleus** (in eukaryotes).
- Key enzyme: **RNA polymerase II** (for mRNA)
- Steps:
  1. **Initiation** – RNA polymerase binds to the promoter region of a gene.
  2. **Elongation** – RNA polymerase reads the DNA template strand (3'→5') and synthesizes RNA (5'→3').
  3. **Termination** – RNA polymerase reaches a terminator sequence and releases the RNA transcript.
- Produces **pre-mRNA**, which undergoes further processing.

### RNA Processing (Eukaryotes only)
- **5' capping** – protects RNA, aids ribosome binding
- **3' polyadenylation** – poly-A tail added, stabilizes RNA
- **Splicing** – introns removed, exons joined together (by the **spliceosome**)
  - Alternative splicing allows one gene to produce multiple protein variants

---

## 3. Translation (RNA → Protein)

- mRNA is decoded by **ribosomes** in the cytoplasm to synthesize a protein.
- Key players:
  - **mRNA** – carries the genetic code (codons, triplets of nucleotides)
  - **tRNA** – brings amino acids, matches codon via anticodon
  - **rRNA** – structural/catalytic component of ribosomes
- Steps:
  1. **Initiation** – ribosome assembles at the start codon (AUG)
  2. **Elongation** – tRNAs bring amino acids matching each codon; peptide bonds form
  3. **Termination** – stop codon (UAA, UAG, UGA) reached; polypeptide released

### The Genetic Code
- 64 possible codons → 20 amino acids (code is **degenerate/redundant**)
- 3 stop codons: UAA, UAG, UGA
- Code is (near) **universal** across most organisms

---

## Types of RNA (quick reference)

| RNA type | Function |
|----------|----------|
| mRNA (messenger) | Carries coding info from DNA to ribosome |
| tRNA (transfer) | Brings amino acids during translation |
| rRNA (ribosomal) | Structural/catalytic part of ribosome |
| ncRNA (non-coding) | Regulatory roles (miRNA, lncRNA, siRNA, etc.) |

---

## Exceptions to the Central Dogma

- **Reverse transcription** (RNA → DNA): seen in retroviruses (e.g., HIV) and retrotransposons; enzyme = reverse transcriptase
- **RNA replication** (RNA → RNA): seen in RNA viruses (e.g., SARS-CoV-2), via RNA-dependent RNA polymerase
- Note: information never flows from protein back to nucleic acid (protein → DNA/RNA does not occur)

---

## Why This Matters for Bioinformatics / RNA-seq

- RNA-seq measures the **transcriptome** — the set of RNA transcripts produced via transcription.
- Understanding splicing is essential for interpreting **isoforms**, exon-level counts, and alignment to spliced references (STAR/HISAT2 use splice-aware alignment).
- Codon/reading frame knowledge matters for variant effect prediction (e.g., synonymous vs non-synonymous mutations).

---

## References
- [Crick, F. (1970). "Central Dogma of Molecular Biology." *Nature*.](https://www.nature.com/articles/227561a0)
- Molecular Biology of the Cell (Alberts et al.)