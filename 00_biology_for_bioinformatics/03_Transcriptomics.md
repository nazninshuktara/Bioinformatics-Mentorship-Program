# Transcriptomics

## 1. Overview & Scope

**Transcriptomics** is the branch of molecular biology and bioinformatics that studies the complete set of RNA transcripts produced by a cell, tissue, or organism under specific conditions.

The transcriptome represents the **active expression state of the genome** at a particular time and condition.

- Genome → Complete DNA content of an organism
- Transcriptome → All RNA molecules produced from the genome
- Proteome → Complete set of proteins produced

**Scope:** RNA biology, gene expression analysis, RNA sequencing (RNA-seq), transcript quantification, differential expression analysis, alternative splicing, non-coding RNA analysis, pathway analysis, and functional genomics.

**Applications:**

- Disease mechanism studies
- Biomarker discovery
- Drug response analysis
- Host-pathogen interaction studies
- Cancer transcriptomics
- Immunology research
- Infectious disease research
- Systems biology


---

# 2. Transcriptome

The **transcriptome** is the complete collection of RNA molecules present in a cell or tissue at a specific time.

Unlike the genome, the transcriptome is:

- Dynamic
- Condition-dependent
- Tissue-specific
- Developmental-stage dependent

Example:

A lung cell and a blood cell have the same genome but different transcriptomes because different genes are expressed.


---

# 3. Types of RNA in Transcriptomics

Transcriptomics studies different RNA molecules including:

| RNA Type | Function |
|---|---|
| mRNA | Coding RNA that carries information for protein synthesis |
| rRNA | Structural and catalytic component of ribosomes |
| tRNA | Transfers amino acids during translation |
| miRNA | Small regulatory RNA controlling gene expression |
| lncRNA | Long non-coding RNA involved in regulation |
| circRNA | Circular RNA with regulatory functions |

For RNA-seq, the major focus is usually:

- mRNA
- lncRNA
- miRNA


---

# 4. Gene Expression

**Gene expression** is the process by which information encoded in DNA is used to produce functional RNA or protein.

General pathway:
```
DNA
 |
Transcription
 |
RNA
 |
Translation
 |
Protein
```

Transcriptomics mainly studies the transcriptional level:
```
DNA → RNA
```

Gene expression varies depending on:

- Cell type
- Disease condition
- Environmental signals
- Developmental stage
- Treatment response


---

# 5. Transcriptome vs Genome

| Genome | Transcriptome |
|---|---|
| Complete DNA sequence | Complete RNA transcript set |
| Mostly constant | Changes with conditions |
| Present in all cells | Cell-type specific |
| Represents genetic potential | Represents active gene expression |


---

# 6. RNA-seq (RNA Sequencing)

RNA-seq is a next-generation sequencing technology used to measure and analyze RNA expression levels across the transcriptome.

It allows researchers to:

- Identify expressed genes
- Quantify transcript abundance
- Detect differentially expressed genes
- Discover novel transcripts
- Study alternative splicing


---

# 7. Bulk RNA-seq Workflow

General RNA-seq workflow:
```
Biological Sample
        ↓
RNA Extraction
        ↓
RNA Quality Control
        ↓
Library Preparation
        ↓
Sequencing
        ↓
FASTQ Files
        ↓
Quality Control
        ↓
Read Alignment / Quantification
        ↓
Gene Expression Matrix
        ↓
Differential Expression Analysis
        ↓
Functional Interpretation
```


---

# 8. RNA Quality Control

RNA quality assessment is important before sequencing.

Important parameters:

## RNA Quantity

Amount of RNA available for library preparation.

## RNA Integrity

RNA degradation is measured using:

- RIN (RNA Integrity Number)

High-quality RNA:

- Less degradation
- Better sequencing results

Common QC methods:

- NanoDrop
- Qubit
- Bioanalyzer


---

# 9. RNA-seq Library Preparation

Library preparation converts RNA molecules into sequencing-compatible fragments.

Major steps:

1. RNA isolation
2. mRNA enrichment or rRNA depletion
3. RNA fragmentation
4. cDNA synthesis
5. Adapter ligation
6. Library amplification
7. Sequencing


---

# 10. Sequencing Technologies

## Illumina Sequencing

Most commonly used RNA-seq platform.

Features:

- Short reads
- High accuracy
- Large-scale sequencing


## Long-read Sequencing

Examples:

- Oxford Nanopore
- PacBio

Advantages:

- Full-length transcript detection
- Isoform analysis


---

# 11. FASTQ File Format

RNA-seq raw data is stored as FASTQ files.

FASTQ contains:

1. Sequence identifier
2. Nucleotide sequence
3. Separator
4. Quality score


Example:
```
@Read001
ATGCGTACG
+
IIIIIIII
```

Quality score represents confidence of nucleotide calls.


---

# 12. RNA-seq Quality Control

Before downstream analysis, sequencing quality is checked.

Important parameters:

- Read quality score
- Adapter contamination
- GC content
- Sequence duplication
- Overrepresented sequences

Tools:

- FastQC
- MultiQC


---

# 13. Read Alignment

Alignment maps sequencing reads to a reference genome.

Purpose:

- Identify genomic origin of reads
- Determine expressed genes
- Detect splice junctions

Common tools:

- STAR
- HISAT2

Output:

- BAM files


---

# 14. Transcript Quantification

Quantification estimates transcript or gene expression levels.

## Alignment-based Methods

Reads are mapped before quantification.

Examples:

- featureCounts
- HTSeq


## Alignment-free Methods

Transcript abundance estimation without full alignment.

Examples:

- Salmon
- Kallisto


Expression units:

- TPM (Transcripts Per Million)
- Counts


---

# 15. Gene Expression Matrix

After quantification, expression data is represented as a matrix.

Example:

| Gene | Sample 1 | Sample 2 |
|---|---|---|
| TP53 | 120 | 300 |
| IL6 | 50 | 500 |

Rows → Genes  
Columns → Samples


---

# 16. Differential Gene Expression Analysis (DGE)

Differential expression identifies genes with different expression levels between conditions.

Example:
COVID Patient vs Healthy Control

Output:

- Upregulated genes
- Downregulated genes

Common tools:

- DESeq2
- edgeR
- limma

Important values:

- Fold Change
- log2 Fold Change
- Adjusted p-value


---

# 17. RNA-seq Visualization

Common visualization methods:

## PCA Plot

Shows sample similarity and variation.

## Heatmap

Displays gene expression patterns.

## Volcano Plot

Shows:

- Fold change
- Statistical significance

## MA Plot

Shows expression changes relative to average expression.

Tools:

- ggplot2
- pheatmap
- EnhancedVolcano


---

# 18. Functional Enrichment Analysis

After identifying Differentially Expressed Genes (DEGs), biological meaning is investigated.

## Gene Ontology (GO)

Three categories:

- Biological Process
- Molecular Function
- Cellular Component


## Pathway Analysis

Examples:

- KEGG
- Reactome

Tools:

- clusterProfiler
- ReactomePA


---

# 19. Gene Set Enrichment Analysis (GSEA)

GSEA determines whether predefined gene sets show coordinated expression changes.

Advantages:

- Uses all genes
- Does not require strict DEG cutoff

Applications:

- Pathway activation analysis
- Disease mechanism studies


---

# 20. Alternative Splicing Analysis

Alternative splicing allows one gene to produce multiple transcript isoforms.

Types:

- Exon skipping
- Intron retention
- Alternative splice sites

Tools:

- rMATS
- SUPPA


---

# 21. Single-cell Transcriptomics (scRNA-seq)

Single-cell RNA sequencing measures gene expression at individual cell level.

Advantages:

- Identifies cell populations
- Reveals cellular heterogeneity

Workflow:
```
Single Cells
      ↓
Library Preparation
      ↓
Sequencing
      ↓
Cell Clustering
      ↓
Cell Type Annotation
```

Tools:

- Seurat
- Scanpy


---

# 22. Transcriptomics in Disease Research

Applications:

- Cancer transcriptomics
- Immune response studies
- Viral infection studies
- Drug response analysis

Example:
```
SARS-CoV-2 Infection
        ↓
Host Immune Response
        ↓
Gene Expression Changes
        ↓
DEG Analysis
        ↓
Pathway Identification
```


---

# 23. Transcriptomics in Bioinformatics

Transcriptomics connects biology with computational analysis.

Required skills:

- Linux
- R programming
- Statistics
- Data visualization
- Workflow management

Common tools:

| Step | Tool |
|---|---|
| QC | FastQC, MultiQC |
| Quantification | Salmon |
| Alignment | STAR, HISAT2 |
| Counting | featureCounts |
| DEG Analysis | DESeq2, limma |
| Pathway Analysis | clusterProfiler |
| Visualization | ggplot2 |


---

# 24. References

- *Molecular Biology of the Cell* — Alberts et al.
- *Bioinformatics Data Skills* — Vince Buffalo
- Bioconductor RNA-seq Documentation
