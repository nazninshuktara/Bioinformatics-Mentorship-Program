# 08. Core Bioinformatics File Formats

## Overview

Every NGS pipeline moves data through a predictable chain of file formats — from raw sequence reads to alignments to variants. Understanding each format's structure is essential before touching any pipeline tool (FastQC, STAR, DESeq2, etc.).
```
FASTQ (raw reads) → SAM/BAM (aligned reads) → VCF (variants) / Counts (expression)
→ BED (genomic regions/features)
```
---

## 1. FASTA (.fasta, .fa)

Stores **sequence only** (no quality scores) — used for reference genomes, transcript sequences.
> chr1
> ACTGATCGATCGTAGCTAGCTAGCTAGCATCG...

- Header line starts with `>`
- Sequence can span multiple lines

---

## 2. FASTQ (.fastq, .fq)

Stores **raw sequencing reads** with quality scores. 4 lines per read:
```
@READ_ID
ACTGATCGATCGTAGCTAGC
+
IIIIIIIIIIIIIIIIIIII
```
| Line | Content |
|------|---------|
| 1 | Read identifier (starts with `@`) |
| 2 | Nucleotide sequence |
| 3 | `+` (optionally repeats read ID) |
| 4 | Quality string (Phred scores, ASCII-encoded, same length as sequence) |

- Output of Illumina sequencers; input to FastQC, Trimmomatic/Cutadapt, and aligners

---

## 3. SAM / BAM (.sam / .bam)

Stores **aligned reads** — where each read maps on the reference genome.

- **SAM (Sequence Alignment/Map)** – human-readable, tab-delimited text
- **BAM** – binary compressed version of SAM (same info, smaller, indexed, faster to process)
- **CRAM** – even more compressed alternative

### Key SAM Columns
| Field | Meaning |
|-------|---------|
| QNAME | Read name |
| FLAG | Bitwise flag (mapped/unmapped, paired, strand, etc.) |
| RNAME | Reference sequence (chromosome) |
| POS | Leftmost mapping position (1-based) |
| MAPQ | Mapping quality |
| CIGAR | Alignment description (matches, insertions, deletions, splice gaps) |
| SEQ | Read sequence |
| QUAL | Read quality |

- Output of STAR/HISAT2; input to featureCounts, IGV visualization, variant callers
- Must be **sorted** and **indexed** (`.bai`) for most downstream tools

---

## 4. VCF (Variant Call Format) (.vcf)

Stores **genetic variants** (SNPs, indels) relative to a reference genome.
```
#CHROM POS ID REF ALT QUAL FILTER INFO
chr1 14653 . C T 50 PASS DP=30;AF=0.5
```
| Field | Meaning |
|-------|---------|
| CHROM | Chromosome |
| POS | Position |
| REF / ALT | Reference and alternate allele |
| QUAL | Variant call quality |
| FILTER | Pass/fail filter status |
| INFO | Additional annotations (depth, allele frequency, etc.) |

- Output of variant callers (GATK, bcftools); input to annotation tools (VEP, SnpEff)

---

## 5. BED (Browser Extensible Data) (.bed)

Stores **genomic regions/intervals** — simple, 0-based, tab-delimited.
```
chr1 11868 14409 DDX11L1 . +
```
| Column | Meaning |
|--------|---------|
| chrom | Chromosome |
| chromStart | Start (0-based) |
| chromEnd | End |
| name (optional) | Feature name |
| score (optional) | Score |
| strand (optional) | + or - |

- Used for defining regions of interest, peak calling results (ChIP-seq/ATAC-seq), custom feature sets

---

## 6. GTF/GFF — see file 07 (Reference Genomes & Annotation)

---

## Quick Reference Table

| Format | Contains | 0-based or 1-based | Typical Tool Output |
|--------|----------|---------------------|----------------------|
| FASTA | Sequence only | — | Reference genomes |
| FASTQ | Raw reads + quality | — | Sequencer output |
| SAM/BAM | Aligned reads | 1-based (SAM) | STAR/HISAT2 |
| VCF | Variants | 1-based | GATK/bcftools |
| BED | Genomic intervals | 0-based | Peak callers, custom regions |
| GTF/GFF | Gene annotation | 1-based | Ensembl/GENCODE |

> **Important gotcha:** BED is 0-based (half-open), while SAM/VCF/GTF are 1-based. Off-by-one errors are a very common source of bugs when converting between formats.

---

## Why This Matters for Bioinformatics / RNA-seq

- This is literally the backbone of the entire RNA-seq pipeline: FASTQ → (QC) → BAM/quantification → counts table → DESeq2 input.
- Understanding SAM flags and CIGAR strings helps troubleshoot alignment issues (e.g., unexpectedly low mapping rate, multi-mapping reads).
- Coordinate system awareness (0-based vs 1-based) prevents subtle but serious errors when intersecting BED regions with GTF-based gene models.

---

## References
- SAM/BAM format specification (samtools.github.io/hts-specs)
- VCF format specification (samtools.github.io/hts-specs)
- UCSC BED format documentation
- Illumina FASTQ format documentation