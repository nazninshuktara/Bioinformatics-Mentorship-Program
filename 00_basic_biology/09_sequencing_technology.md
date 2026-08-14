# 09. Sequencing Technology Basics (Illumina / NGS)

## Overview

Next-Generation Sequencing (NGS) refers to high-throughput sequencing technologies that sequence millions of DNA/RNA fragments in parallel. **Illumina** sequencing-by-synthesis (SBS) is the most widely used platform and is the basis for most bulk and single-cell RNA-seq data.

---

## 1. General NGS Workflow
```
Sample → Library Prep → Cluster Generation → Sequencing → Base Calling → FASTQ files
```
### For RNA-seq specifically:
```
RNA extraction → rRNA depletion / poly-A selection →
Reverse transcription (RNA→cDNA) → Fragmentation →
Adapter ligation → PCR amplification → Sequencing
```
---

## 2. Illumina Sequencing-by-Synthesis (SBS) — How It Works

1. **Library preparation** – DNA/cDNA fragmented, adapters ligated to both ends
2. **Cluster generation (bridge amplification)** – fragments attach to a flow cell, bend over, and amplify into clonal clusters (each cluster = many copies of one original fragment)
3. **Sequencing** – fluorescently labeled nucleotides are added one cycle at a time; each nucleotide incorporation emits a color, captured by imaging
4. **Base calling** – software converts fluorescent signal into a nucleotide sequence + quality score per cycle

- Each cluster on the flow cell effectively acts as a mini reaction generating one read

---

## 3. Read Types

| Type | Description |
|------|-------------|
| **Single-end (SE)** | Sequencing from one end of the fragment only |
| **Paired-end (PE)** | Sequencing from both ends of the fragment — gives more information (better mapping, detects insertions/deletions, fusion transcripts) |

- Paired-end is standard for most modern RNA-seq experiments

---

## 4. Read Length

- Common Illumina read lengths: 50, 75, 100, 150 bp (varies by platform/kit)
- Longer reads → better mapping accuracy, especially across splice junctions and repetitive regions
- Trade-off: longer reads = more expensive, fewer reads per run (throughput trade-off)

---

## 5. Sequencing Depth & Coverage

| Term | Meaning |
|------|---------|
| **Depth/Coverage** | Average number of times a given base is sequenced |
| **Library size** | Total number of reads generated for a sample |

- For RNA-seq: depth is usually described as "reads per sample" (e.g., 20-30 million reads/sample for standard bulk RNA-seq differential expression)
- Higher depth needed for: detecting lowly expressed genes, isoform-level resolution, single-cell RNA-seq (though per-cell depth is much lower than bulk)

---

## 6. Key Illumina Platforms (context, not exhaustive)

- **MiSeq** – smaller scale, faster turnaround, good for targeted sequencing
- **NextSeq** – mid-throughput
- **NovaSeq** – high-throughput, standard for large RNA-seq/WGS studies

---

## 7. Other Sequencing Technologies (brief context)

| Technology | Type | Notes |
|------------|------|-------|
| **Illumina** | Short-read | High accuracy, widely used, basis of most bulk/single-cell RNA-seq |
| **Oxford Nanopore** | Long-read | Real-time, portable, useful for structural variants, full-length transcripts |
| **PacBio (SMRT)** | Long-read | High accuracy long reads, useful for isoform sequencing (Iso-Seq) |

- Long-read technologies are increasingly relevant for **full-length isoform detection** and **pathogen genome assembly** (useful given the program's infectious disease focus)

---

## Why This Matters for Bioinformatics / RNA-seq

- Understanding paired-end vs single-end determines how FASTQ files are structured (R1/R2 files) and how aligners (STAR/HISAT2) are run.
- Read length and depth decisions directly affect experimental design — a key consideration before FastQC/alignment even begins.
- Knowing how clusters/base calling work helps interpret **quality scores** and common FastQC flags (e.g., per-base quality drop-off toward read end is a known SBS chemistry artifact).
- Awareness of long-read platforms is useful context for future work in pathogen genome assembly or full-length isoform studies.

---

## References
- Illumina Sequencing Technology documentation (illumina.com)
- Goodwin, S. et al. (2016). "Coming of age: ten years of next-generation sequencing technologies." *Nature Reviews Genetics*.
- Oxford Nanopore Technologies documentation