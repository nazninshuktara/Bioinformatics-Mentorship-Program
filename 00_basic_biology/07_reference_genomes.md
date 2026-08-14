# 07. Reference Genomes & Annotation

## Overview

A **reference genome** is a representative DNA sequence assembled from one or more individuals of a species, used as a standard coordinate system for aligning sequencing reads, calling variants, and annotating genes. Annotation files describe what functional elements exist at each genomic coordinate.

---

## 1. What Is a Reference Genome?

- Not a single individual's exact genome — a **consensus/representative assembly**
- Provides a coordinate system: chromosome + position (e.g., chr1:11,869)
- Continuously improved through new assembly versions

---

## 2. Human Reference Genome Versions

| Version | Also known as | Notes |
|---------|---------------|-------|
| **GRCh37** | hg19 | Older, still used in some legacy datasets/clinical pipelines |
| **GRCh38** | hg38 | Current standard, improved assembly, fixed many gaps/errors |
| **T2T-CHM13** | Telomere-to-Telomere | Newest, gapless complete assembly (2022), includes previously unresolved repetitive regions |

> Important: coordinates are **not interchangeable** between versions — always confirm which genome build your data/reference uses before analysis (liftover tools exist for conversion).

---

## 3. Genome Annotation

Annotation adds biological meaning to raw genome coordinates — where genes, exons, introns, regulatory elements are located.

### Major Annotation Sources
- **Ensembl** – comprehensive, automated + manual annotation
- **GENCODE** – widely used for human/mouse, high-quality curated annotation
- **RefSeq (NCBI)** – curated reference sequences, often used in clinical contexts
- **UCSC Genome Browser** – visualization + annotation hub

---

## 4. Annotation File Formats

### GTF (Gene Transfer Format)
```
chr1 HAVANA gene 11869 14409 . + . gene_id "ENSG00000223972"; gene_name "DDX11L1";
chr1 HAVANA exon 11869 12227 . + . gene_id "ENSG00000223972"; transcript_id "ENST00000456328";
```
### GFF3 (General Feature Format v3)
- Similar to GTF but with different attribute syntax (key=value; semicolon-separated)
- Hierarchical (Parent/ID relationships explicit)

### Key Columns (both formats)
| Column | Meaning |
|--------|---------|
| seqname | Chromosome/scaffold |
| source | Annotation source (e.g., HAVANA, Ensembl) |
| feature | gene, transcript, exon, CDS, UTR, etc. |
| start / end | 1-based coordinates |
| score | Confidence score (often ".") |
| strand | + or - |
| frame | Reading frame for CDS |
| attribute | Gene ID, transcript ID, gene name, etc. |

---

## 5. Genome Browsers

- **UCSC Genome Browser**, **Ensembl Genome Browser**, **IGV (Integrative Genomics Viewer)**
- Used to visually inspect: gene models, read alignments (BAM), variants (VCF), coverage tracks (BigWig)
- IGV is especially useful for manually inspecting RNA-seq alignments (e.g., confirming splice junctions, checking coverage at a gene of interest)

---

## Why This Matters for Bioinformatics / RNA-seq

- Alignment tools (STAR/HISAT2) require both a **reference genome (FASTA)** and **annotation (GTF)** as input.
- Mismatched genome builds between reference and annotation (or between samples) is a common and serious pipeline error — always version-match.
- featureCounts/Salmon/tximport rely directly on GTF gene/transcript models to assign reads and summarize counts to gene level.
- IGV inspection of GTF-defined exon structures helps troubleshoot unexpected DESeq2 results (e.g., checking if a "differentially expressed" gene has isoform-level complexity).

---

## References
- Ensembl documentation (ensembl.org)
- GENCODE project documentation
- UCSC Genome Browser documentation
- GTF/GFF3 format specifications (Sanger Institute / Ensembl)
