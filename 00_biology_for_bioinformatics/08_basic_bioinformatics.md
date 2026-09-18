# Basic Bioinformatics

## 1. Overview & Scope

Bioinformatics is the application of computational methods to analyze, interpret, and manage biological data.

### Main Areas
- Sequence analysis
- Genomics
- Transcriptomics
- Proteomics
- Structural bioinformatics
- Phylogenetics
- Metagenomics
- Computational biology

---

## 2. What is Bioinformatics?

Bioinformatics combines:

- Biology
- Computer science
- Statistics
- Mathematics
- Data science

### Main Goal

Convert biological data into meaningful biological information.

### Example

```text
Biological Question
        ↓
Data Collection
        ↓
Quality Control
        ↓
Data Processing
        ↓
Analysis
        ↓
Biological Interpretation
```
## 3. Biological Data Types

### DNA Data

- DNA sequences
- Genomic sequences
- Variant data

### RNA Data

- mRNA
- miRNA
- lncRNA
- RNA-seq data
- RNA expression data

### Protein Data

- Protein sequences
- Protein structures
- Protein functions

### Other Biological Data

- Epigenomic data
- Metagenomic data
- Single-cell data
- Clinical metadata

---

## 4. Bioinformatics Workflow

A typical bioinformatics project follows:

```text
Research Question
        ↓
Data Collection
        ↓
Data Organization
        ↓
Quality Control
        ↓
Data Processing
        ↓
Statistical Analysis
        ↓
Biological Interpretation
        ↓
Visualization
        ↓
Reporting
```
## 5. Sequence Databases

### NCBI

**National Center for Biotechnology Information.**

Important resources include:

- GenBank
- RefSeq
- GEO
- SRA
- PubMed

### Ensembl

Used for:

- Genome annotation
- Gene information
- Transcript information
- Variant information

### UniProt

Used for:

- Protein sequences
- Protein functions
- Protein annotation

### Other Resources

- ENA
- DDBJ
- UCSC Genome Browser

---

## 6. Sequence Search

### BLAST

**BLAST (Basic Local Alignment Search Tool)** is used to identify similar biological sequences.

### Important Concepts

- Query sequence
- Subject sequence
- Sequence similarity
- Sequence identity
- Alignment
- E-value
- Bit score
- Homology

### Common BLAST Types

| BLAST Type | Purpose |
|---|---|
| BLASTn | Nucleotide vs nucleotide |
| BLASTp | Protein vs protein |
| BLASTx | Translated nucleotide vs protein |
| tBLASTn | Protein vs translated nucleotide |

---

## 7. Common Biological File Formats

Every NGS pipeline moves data through a predictable chain of file formats — from raw sequence reads to alignments to variants. Understanding each format's structure is essential before touching any pipeline tool (FastQC, STAR, DESeq2, etc.).
```
FASTQ (raw reads) → SAM/BAM (aligned reads) → VCF (variants) / Counts (expression)
→ BED (genomic regions/features)
```
### FASTA (.fasta, .fa)

- Used for nucleotide or protein sequences.
- Stores **sequence only** (no quality scores) — used for reference genomes, transcript sequences.

```text
>Sequence_ID
ATGCGTACGATCGATCG
```
- Header line starts with `>`
- Sequence can span multiple lines

### FASTQ (.fastq, .fq)

## 2. FASTQ (.fastq, .fq)

- Used for sequencing reads.
- Stores **raw sequencing reads** with quality scores. 4 lines per read:

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


### SAM / BAM (.sam / .bam)

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


### VCF (Variant Call Format) (.vcf)

- Stores **genetic variants** (SNPs, indels) relative to a reference genome.

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

### BED (Browser Extensible Data) (.bed)

- Stores **genomic regions/intervals** — simple, 0-based, tab-delimited.

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

### GTF / GFF

Used to store genome and gene annotation information.

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

## 8. Reference Genome & Annotation

### Reference Genome

A **reference genome** is a representative DNA sequence assembled from one or more individuals of a species, used as a standard coordinate system for aligning sequencing reads, calling variants, and annotating genes. Annotation files describe what functional elements exist at each genomic coordinate.

- Not a single individual's exact genome — a **consensus/representative assembly**
- Provides a coordinate system: chromosome + position (e.g., chr1:11,869)
- Continuously improved through new assembly versions

### Human Reference Genome Versions

| Version | Also known as | Notes |
|---------|---------------|-------|
| **GRCh37** | hg19 | Older, still used in some legacy datasets/clinical pipelines |
| **GRCh38** | hg38 | Current standard, improved assembly, fixed many gaps/errors |
| **T2T-CHM13** | Telomere-to-Telomere | Newest, gapless complete assembly (2022), includes previously unresolved repetitive regions |

> Important: coordinates are **not interchangeable** between versions — always confirm which genome build your data/reference uses before analysis (liftover tools exist for conversion).


### Genome Annotation

Annotation adds biological meaning to raw genome coordinates — where genes, exons, introns, regulatory elements are located.

### Major Annotation Sources
- **Ensembl** – comprehensive, automated + manual annotation
- **GENCODE** – widely used for human/mouse, high-quality curated annotation
- **RefSeq (NCBI)** – curated reference sequences, often used in clinical contexts
- **UCSC Genome Browser** – visualization + annotation hub

Genome annotation identifies biological features such as:

- Genes
- Transcripts
- Exons
- CDS
- Regulatory regions

### Annotation File Formats

#### GTF (Gene Transfer Format)
```
chr1 HAVANA gene 11869 14409 . + . gene_id "ENSG00000223972"; gene_name "DDX11L1";
chr1 HAVANA exon 11869 12227 . + . gene_id "ENSG00000223972"; transcript_id "ENST00000456328";
```
#### GFF3 (General Feature Format v3)
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

### Genome Browsers

- **UCSC Genome Browser**, **Ensembl Genome Browser**, **IGV (Integrative Genomics Viewer)**
- Used to visually inspect: gene models, read alignments (BAM), variants (VCF), coverage tracks (BigWig)
- IGV is especially useful for manually inspecting RNA-seq alignments (e.g., confirming splice junctions, checking coverage at a gene of interest)


---

## 9. Sequencing Technology Basics (Illumina / NGS)

Next-Generation Sequencing (NGS) refers to high-throughput sequencing technologies that sequence millions of DNA/RNA fragments in parallel. **Illumina** sequencing-by-synthesis (SBS) is the most widely used platform and is the basis for most bulk and single-cell RNA-seq data.

### General NGS Workflow
```
Sample → Library Prep → Cluster Generation → Sequencing → Base Calling → FASTQ files
```

### For RNA-seq specifically:
```
RNA extraction → rRNA depletion / poly-A selection →
Reverse transcription (RNA→cDNA) → Fragmentation →
Adapter ligation → PCR amplification → Sequencing
```
### Illumina Sequencing-by-Synthesis (SBS) — How It Works

1. **Library preparation** – DNA/cDNA fragmented, adapters ligated to both ends
2. **Cluster generation (bridge amplification)** – fragments attach to a flow cell, bend over, and amplify into clonal clusters (each cluster = many copies of one original fragment)
3. **Sequencing** – fluorescently labeled nucleotides are added one cycle at a time; each nucleotide incorporation emits a color, captured by imaging
4. **Base calling** – software converts fluorescent signal into a nucleotide sequence + quality score per cycle

- Each cluster on the flow cell effectively acts as a mini reaction generating one read

### Key Illumina Platforms (context, not exhaustive)

- **MiSeq** – smaller scale, faster turnaround, good for targeted sequencing
- **NextSeq** – mid-throughput
- **NovaSeq** – high-throughput, standard for large RNA-seq/WGS studies

### Other Sequencing Technologies

| Technology | Type | Notes |
|------------|------|-------|
| **Illumina** | Short-read | High accuracy, widely used, basis of most bulk/single-cell RNA-seq |
| **Oxford Nanopore** | Long-read | Real-time, portable, useful for structural variants, full-length transcripts |
| **PacBio (SMRT)** | Long-read | High accuracy long reads, useful for isoform sequencing (Iso-Seq) |

- Long-read technologies are increasingly relevant for **full-length isoform detection** and **pathogen genome assembly** (useful given the program's infectious disease focus)


---

## 10. Sequencing Data

### Raw Reads

Raw reads are sequences generated directly from a sequencing experiment.

### Read Length

The number of bases present in a sequencing read.

- Common Illumina read lengths: 50, 75, 100, 150 bp (varies by platform/kit)
- Longer reads → better mapping accuracy, especially across splice junctions and repetitive regions
- Trade-off: longer reads = more expensive, fewer reads per run (throughput trade-off)


### Sequencing Depth & Coverage

The number of sequencing reads generated for a sample.

| Term | Meaning |
|------|---------|
| **Depth/Coverage** | Average number of times a given base is sequenced |
| **Library size** | Total number of reads generated for a sample |

- For RNA-seq: depth is usually described as "reads per sample" (e.g., 20-30 million reads/sample for standard bulk RNA-seq differential expression)
- Higher depth needed for: detecting lowly expressed genes, isoform-level resolution, single-cell RNA-seq (though per-cell depth is much lower than bulk)
- Coverage describes how many times a genomic region is represented by sequencing reads.

### Library Layout

| Type | Description |
|------|-------------|
| **Single-end (SE)** | Sequencing from one end of the fragment only |
| **Paired-end (PE)** | Sequencing from both ends of the fragment — gives more information (better mapping, detects insertions/deletions, fusion transcripts) |

- Paired-end is standard for most modern RNA-seq experiments

### Paired-end Sequencing

In paired-end sequencing, both ends of a DNA or RNA fragment are sequenced.

```text
Fragment
|----------------------|

Read 1 →              ← Read 2
```


## 11. Quality Scores

Before any alignment or downstream analysis, raw sequencing reads must be quality-checked. Poor-quality reads can introduce false variants, misalignment, and biased expression estimates. This file covers the core QC concepts used to interpret tools like **FastQC** and **MultiQC**.

### Phred Quality Score

- Encodes the probability that a given base call is incorrect
- Higher Phred score means higher base-calling confidence.
- Formula: **Q = -10 × log10(P)**, where P = probability of error

### Common Phred Scores

| Phred Score (Q) | Error Probability | Base Call Accuracy |
|------------------|--------------------|----------------------|
| Q10 | 1 in 10 | 90% |
| Q20 | 1 in 100 | 99% |
| Q30 | 1 in 1,000 | 99.9% |
| Q40 | 1 in 10,000 | 99.99% |

- **Q30 is the widely used benchmark** — a base with Q30 or higher is considered high-confidence
- Quality scores are ASCII-encoded in the 4th line of each FASTQ read (Phred+33 encoding is standard for modern Illumina data)


### Quality Control

Common tools include:

- FastQC
- MultiQC

### Key FastQC Metrics

| Metric | What It Shows | Common Issue Flagged |
|--------|----------------|------------------------|
| **Per base sequence quality** | Quality score distribution at each read position | Quality often drops toward the 3' end (normal SBS chemistry artifact) |
| **Per sequence quality scores** | Distribution of average quality across all reads | Bimodal distribution may indicate a subset of poor reads |
| **Per base sequence content** | %A/T/G/C at each position | Bias at read start can indicate adapter contamination or non-random priming |
| **Per sequence GC content** | GC% distribution across reads | Deviation from expected can indicate contamination |
| **Sequence duplication levels** | % of duplicate reads | High duplication can indicate low-complexity library or over-amplification (PCR duplicates) |
| **Overrepresented sequences** | Sequences appearing more than expected | Often adapter sequences or contamination |
| **Adapter content** | Presence of sequencing adapters in reads | Needs adapter trimming before alignment |

### Coverage vs Depth

- **Depth (for RNA-seq)** – usually expressed as total reads per sample, not per-base coverage like DNA-seq
- Typical bulk RNA-seq depth: **20-30 million reads/sample** for standard differential expression
- Higher depth needed for: low-expression gene detection, isoform-level analysis, allele-specific expression

### Common QC Issues & Fixes

| Issue | Likely Cause | Fix |
|-------|---------------|-----|
| Low per-base quality at 3' end | Normal SBS signal decay | Trim low-quality bases (Trimmomatic/Cutadapt) |
| Adapter contamination | Short insert fragments | Adapter trimming |
| High duplication | PCR over-amplification or low input material | Flag/note (don't always remove for RNA-seq — high expression genes naturally show duplication) |
| GC content skew | Contamination or library bias | Investigate overrepresented sequences, check organism source |
| Low overall quality | Sequencing run/flow cell issue | Consider re-sequencing if severe |

> **Note for RNA-seq specifically:** unlike DNA-seq, high duplication rates are often *expected and biologically valid* (highly expressed genes will naturally produce many identical reads) — so PCR duplicate removal is generally NOT recommended for standard bulk RNA-seq differential expression.

### MultiQC

- Aggregates FastQC (and other tool) reports across many samples into a single interactive HTML report
- Essential when working with multiple samples (e.g., GEO datasets with 6-30+ samples) — spot outlier samples quickly before proceeding to alignment

---

## 11. Basic Sequence Analysis

Important sequence properties include:

- Sequence length
- Nucleotide composition
- GC content
- AT content
- Base frequency
- Reverse complement
- Open Reading Frame (ORF)

### GC Content

```text
GC Content =
(G + C) / Total Bases × 100
```
### Reverse Complement

The reverse complement is generated by first obtaining the complementary sequence and then reversing it.

Example:

```text
Sequence:
ATGC

Complement:
TACG

Reverse Complement:
GCAT
```
## 12. Alignment Concepts

Sequence alignment is used to compare biological sequences.

### Pairwise Alignment

Alignment between two sequences.

### Multiple Sequence Alignment

Alignment of three or more sequences.

### Global Alignment

Aligns sequences across their entire length.

### Local Alignment

Identifies the most similar regions between sequences.

### Reference Alignment

Sequencing reads are aligned against a reference genome or transcriptome.

---

## 13. Biological Databases & Resources

| Resource | Main Use |
|---|---|
| NCBI | Biological and sequence data |
| GenBank | Nucleotide sequences |
| RefSeq | Reference sequences |
| Ensembl | Genome annotation |
| UniProt | Protein information |
| UCSC Genome Browser | Genome visualization |
| GEO | Gene expression datasets |
| SRA | Sequencing data |
| PubMed | Scientific literature |

---

## 14. Bioinformatics and RNA-seq

A simplified RNA-seq workflow:

```text
FASTQ
  ↓
Quality Control
  ↓
Read Processing
  ↓
Alignment / Quantification
  ↓
Expression Matrix
  ↓
Differential Expression
  ↓
Functional Enrichment
  ↓
Biological Interpretation
```
### Common Tools

- FastQC
- MultiQC
- Salmon
- STAR
- HISAT2
- featureCounts
- DESeq2
- edgeR
- limma
- clusterProfiler

---

## 15. Bioinformatics and Genomics

A simplified genomics workflow:

```text
FASTQ
  ↓
Quality Control
  ↓
Read Processing
  ↓
Alignment / Assembly
  ↓
Variant Calling
  ↓
Variant Annotation
  ↓
Biological Interpretation
```
### Common Analysis Types

- Whole Genome Sequencing (WGS)
- Whole Exome Sequencing (WES)
- Variant analysis
- Genome assembly
- Genome annotation
- Comparative genomics

---

## 16. Reproducibility

A bioinformatics analysis should be reproducible.

### Important Information to Record

- Dataset accession
- Sample metadata
- Reference genome version
- Annotation version
- Software versions
- Analysis parameters
- Analysis scripts
- Computational environment
- Results
- Documentation

### Version Control

Common tools:

- Git
- GitHub

### Environment Management

Examples:

- Conda
- Pixi

---

## 17. Bioinformatics in Research

Bioinformatics is widely used in:

- Genome analysis
- Transcriptomics
- Variant analysis
- RNA-seq
- Single-cell analysis
- Metagenomics
- Phylogenetics
- Protein analysis
- Drug discovery
- Disease research
- Precision medicine

---

## 18. Connection with Biology

Bioinformatics should always connect computational results with biological questions.

### Example

```text
RNA-seq Data
      ↓
Differentially Expressed Genes
      ↓
Pathway Analysis
      ↓
Biological Processes
      ↓
Disease Mechanisms
```
The goal is not only to identify statistically significant results, but also to understand their biological meaning.

---

## 19. Essential Concepts to Remember

Before starting advanced bioinformatics, understand:

- DNA
- RNA
- Protein
- Gene
- Transcript
- Genome
- Reference genome
- Gene annotation
- FASTA
- FASTQ
- SAM
- BAM
- VCF
- GTF
- GFF
- Sequencing depth
- Coverage
- Phred score
- Alignment
- BLAST
- Biological databases
- RNA-seq workflow
- Genomics workflow
- Reproducibility

---

## 20. References

### Major Resources

- NCBI
- Ensembl
- UniProt
- UCSC Genome Browser
- GEO
- SRA
- PubMed

### Books

- *Bioinformatics Algorithms* — Compeau & Pevzner
- *Introduction to Bioinformatics* — Arthur M. Lesk
