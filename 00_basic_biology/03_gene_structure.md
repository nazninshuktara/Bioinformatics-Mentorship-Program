# 03. Gene Structure

## Overview

A **gene** is a segment of DNA that contains the information needed to produce a functional product — typically a protein, but also functional RNAs (tRNA, rRNA, miRNA, etc.). Gene structure differs between **prokaryotes** and **eukaryotes**, and understanding it is essential for interpreting annotation files (GTF/GFF) and RNA-seq data.

---

## 1. General Structure of a Eukaryotic Gene
```
5' ---[Promoter]---[5'UTR]---[Exon1]-[Intron1]-[Exon2]-[Intron2]-[Exon3]---[3'UTR]---[Terminator]--- 3'
_____________ Transcribed region _____________/
```
### Key Components

| Element | Description |
|---------|-------------|
| **Promoter** | Region upstream of TSS where RNA polymerase & transcription factors bind |
| **TSS (Transcription Start Site)** | Point where transcription begins |
| **5' UTR** | Untranslated region before start codon; involved in translation regulation |
| **Exons** | Coding + retained sequences after splicing |
| **Introns** | Non-coding sequences removed during splicing |
| **3' UTR** | Untranslated region after stop codon; contains regulatory elements (e.g., miRNA binding sites) |
| **Terminator** | Signals end of transcription; polyadenylation signal (AAUAAA) in eukaryotes |

---

## 2. Regulatory Elements

- **Promoter** – core region for RNA Pol II binding (often contains TATA box)
- **Enhancers** – can be far from gene (upstream/downstream/intronic); increase transcription; work even at long distances via DNA looping
- **Silencers** – repress transcription
- **Insulators** – block enhancer-promoter interaction, define regulatory domains

---

## 3. Exon-Intron Structure & Splicing

- Introns begin with **GT** and end with **AG** (GT-AG rule) — recognized by spliceosome
- Exons are joined together to form mature mRNA
- **Alternative splicing** allows a single gene to produce multiple mRNA isoforms:
  - Exon skipping
  - Alternative 5'/3' splice sites
  - Intron retention
  - Mutually exclusive exons

---

## 4. Prokaryotic vs Eukaryotic Gene Structure

| Feature | Prokaryotic | Eukaryotic |
|---------|-------------|------------|
| Introns | Absent (mostly) | Present |
| Operons | Common (polycistronic mRNA) | Absent (monocistronic mRNA) |
| Promoter | Simple (-10, -35 boxes) | Complex (TATA box, multiple TFs) |
| mRNA processing | Minimal | Capping, splicing, polyadenylation |
| Gene density | High, compact genome | Lower, more non-coding DNA |

### Operons (Prokaryotes)
- A cluster of genes transcribed together under one promoter → single polycistronic mRNA
- Example: *lac* operon in *E. coli*

---

## 5. Coordinates & Annotation (Bioinformatics Link)

Gene structure is represented computationally in annotation files:

- **GTF/GFF** – describe gene, transcript, exon, CDS coordinates on the reference genome
- Each feature has: chromosome, start, end, strand (+/-), feature type
- Tools like **STAR/HISAT2** use this annotation for splice-aware alignment
- **featureCounts / htseq-count** use exon/gene coordinates to count reads per gene

Example GTF line (conceptual):
```
chr1 HAVANA exon 11869 12227 . + . gene_id "ENSG00000223972"; transcript_id "ENST00000456328";
```
---

## Why This Matters for Bioinformatics / RNA-seq

- Understanding exon/intron boundaries is essential for **splice-aware alignment** (STAR/HISAT2) vs simple aligners.
- UTR regions matter for **3' bias** seen in poly-A selected RNA-seq library prep.
- Alternative splicing knowledge is foundational before moving into **isoform-level quantification** (Salmon, tximport) and **differential exon usage** analysis.
- Annotation file structure (GTF/GFF) directly maps to this gene structure — critical for correct read counting in DESeq2/EdgeR pipelines.

---

## References
- Molecular Biology of the Cell (Alberts et al.)
- Ensembl / GENCODE annotation documentation
- Alberts et al., "Essential Cell Biology"
