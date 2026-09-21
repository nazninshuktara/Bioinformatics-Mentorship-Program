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

## 2. Transcriptome

The **transcriptome** is the complete collection of RNA molecules present in a cell or tissue at a specific time.

Unlike the genome, the transcriptome is:

- Dynamic
- Condition-dependent
- Tissue-specific
- Developmental-stage dependent

Example:

A lung cell and a blood cell have the same genome but different transcriptomes because different genes are expressed.


---

## 3. Types of RNA in Transcriptomics

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

## 4. Gene Expression

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

## 5. Transcriptome vs Genome

| Genome | Transcriptome |
|---|---|
| Complete DNA sequence | Complete RNA transcript set |
| Mostly constant | Changes with conditions |
| Present in all cells | Cell-type specific |
| Represents genetic potential | Represents active gene expression |


---

## 6. RNA-seq (RNA Sequencing)

RNA-seq is a next-generation sequencing technology used to measure and analyze RNA expression levels across the transcriptome.

It allows researchers to:

- Identify expressed genes
- Quantify transcript abundance
- Detect differentially expressed genes
- Discover novel transcripts
- Study alternative splicing


---

## 7. Bulk RNA-seq Workflow

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

## 8. RNA Quality Control

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

## 9. RNA-seq Library Preparation

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

## 10. Sequencing Technologies

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

## 11. FASTQ File Format

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

## 12. RNA-seq Quality Control

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

## 13. Read Alignment

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

## 14. Transcript Quantification

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

## 15. Gene Expression Matrix

After quantification, expression data is represented as a matrix.

Example:

| Gene | Sample 1 | Sample 2 |
|---|---|---|
| TP53 | 120 | 300 |
| IL6 | 50 | 500 |

Rows → Genes  
Columns → Samples


---

## 16. Differential Gene Expression Analysis (DGE)

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

## 17. RNA-seq Visualization

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

## 18. Functional Enrichment Analysis

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

## 19. Gene Set Enrichment Analysis (GSEA)

GSEA determines whether predefined gene sets show coordinated expression changes.

Advantages:

- Uses all genes
- Does not require strict DEG cutoff

Applications:

- Pathway activation analysis
- Disease mechanism studies


---

## 20. Alternative Splicing Analysis

Alternative splicing allows one gene to produce multiple transcript isoforms.

Types:

- Exon skipping
- Intron retention
- Alternative splice sites

Tools:

- rMATS
- SUPPA


---

## 21. Single-cell Transcriptomics (scRNA-seq)

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

## 22. Transcriptomics in Disease Research

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

## 23. Transcriptomics in Bioinformatics

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

## 24. References

- *Molecular Biology of the Cell* — Alberts et al.
- *Bioinformatics Data Skills* — Vince Buffalo
- Bioconductor RNA-seq Documentation

---
# Required Practical - Transcriptomics

## Practical 1 — RNA Extraction and RNA Quality Assessment

### Aim

To extract high-quality RNA from cells or tissues for transcriptomics analysis.

### Principle

RNA extraction involves:

**Cell lysis → RNA release → Contaminant removal → RNA purification → RNA recovery**

RNA is easily degraded by RNases. Therefore, RNA extraction must be performed using RNase-free technique.

### Key Steps

1. Collect and preserve the biological sample.
2. Lyse cells or tissue.
3. Isolate total RNA.
4. Remove contaminants.
5. Perform DNase treatment if required.
6. Recover purified RNA.
7. Measure RNA concentration, purity, and integrity.

### Quality Assessment

- RNA concentration
- A260/A280 ratio
- A260/A230 ratio
- RNA integrity
- RIN concept
- Qubit, NanoDrop, and Bioanalyzer concept

---

## Practical 2 — cDNA Synthesis and RT-qPCR

### Aim

To convert RNA into cDNA and validate expression of selected genes.

### Principle

PCR requires DNA as a template. RNA is first converted to complementary DNA, or cDNA, using reverse transcriptase.

**RNA → cDNA → RT-qPCR**

### Key Steps

1. Select high-quality RNA.
2. Synthesize cDNA using reverse transcriptase.
3. Select target and reference genes.
4. Design or select appropriate primers.
5. Perform RT-qPCR.
6. Record Ct or Cq values.
7. Calculate relative expression.

### Data Interpretation

```text
ΔCt = Ct(target) − Ct(reference)

ΔΔCt = ΔCt(sample) − ΔCt(control)

Relative expression = 2⁻ΔΔCt
```

### Important Controls
- No-template control
- No-RT control
- Technical replicate
- Stable reference gene

---

## Practical 3 — RNA-seq Experimental Design and Library Preparation

### Aim
To prepare RNA samples as sequencing-ready libraries.

### Principle
RNA-seq library preparation converts RNA into cDNA fragments compatible with a sequencing platform.

### Key Steps
1. Select appropriate biological samples.
2. Include biological replicates.
3. Record sample metadata.
4. Perform mRNA enrichment or rRNA depletion.
5. Fragment RNA where appropriate.
6. Synthesize cDNA.
7. Add sequencing adapters.
8. Add sample indexes or barcodes.
9. Amplify and assess the library.

### Important Concepts
- Biological replicates
- Control and treatment groups
- Batch effects
- Poly(A) selection
- rRNA depletion
- Adapter ligation
- Indexing

---

## Practical 4 — RNA-seq Data Quality Control

### Aim
To assess the quality of raw RNA-seq reads before analysis.

### Principle
RNA-seq machines generate raw sequencing reads in FASTQ format. These reads must be checked for quality problems before alignment or quantification.

### Key Steps
1. Organize FASTQ files.
2. Run FastQC.
3. Summarize reports using MultiQC.
4. Check read quality.
5. Check adapter contamination.
6. Check GC-content distribution.
7. Check overrepresented sequences.
8. Trim adapters or low-quality bases if required.
9. Repeat quality control after trimming.

### Common Tools
- FastQC
- MultiQC
- fastp
- Cutadapt
- Trim Galore

---

## Practical 5 — Read Alignment and Gene Expression Quantification

### Aim
To map RNA-seq reads and generate gene-expression values.

### Principle
RNA-seq reads are aligned to a reference genome or transcriptome, or quantified directly against a reference transcriptome.

### Key Steps
1. Obtain the reference genome or transcriptome.
2. Align reads using STAR or HISAT2, or quantify using Salmon or Kallisto.
3. Check mapping or assignment rate.
4. Generate gene-level expression counts.
5. Create a gene-expression matrix.

### Output Files
| Output | Meaning |
| FASTQ |	Raw sequencing reads |
| BAM |	Aligned reads |
| Count matrix |Gene expression values across samples |
| TPM |	Transcript abundance estimate |

### Common Tools
- STAR
- HISAT2
- Salmon
- Kallisto
- featureCounts
- HTSeq

---

## Practical 6 — Differential Gene Expression Analysis

###Aim
To identify genes whose expression differs significantly between experimental groups.

### Principle
Gene-expression counts are normalized and compared between groups.

**Example**:
Disease group vs Healthy control group

### Key Steps
1. Prepare raw count matrix.
2. Prepare sample metadata table.
3. Filter low-expression genes.
4. Normalize count data.
5. Perform differential-expression analysis.
6. Identify upregulated and downregulated genes.
7. Generate result tables and plots.

### Important Terms
| Term | Meaning |
| Log2 fold change | Magnitude and direction of expression change |
| P-value |	Statistical significance before correction |
| Adjusted p-value | Multiple-testing corrected p-value |
| False discovery rate | Expected proportion of false positives |
| DEG |	Differentially expressed gene |


### Common Tools
- DESeq2
- edgeR
- limma

### Common Plots
- PCA plot
- Heatmap
- Volcano plot
- MA plot
---

## Practical 7 — Functional Enrichment, Pathway Analysis, and Validation

### Aim
To interpret the biological meaning of RNA-seq results and validate important genes.

### Principle
Differentially expressed genes are analyzed to identify enriched biological functions and pathways.

### Key Steps
1. Select significant differentially expressed genes.
2. Perform Gene Ontology enrichment analysis.
3. Perform pathway analysis.
4. Perform Gene Set Enrichment Analysis where appropriate.
5. Identify important pathways and candidate genes.
6. Select representative genes for RT-qPCR validation.
7. Compare RT-qPCR and RNA-seq findings.

### Common Analysis Types
|Analysis |	Purpose |
|Gene Ontology | Identifies enriched biological functions |
|KEGG analysis | Identifies enriched pathways |
|Reactome analysis | Identifies curated biological pathways |
|GSEA |	Detects coordinated gene-set changes |

### Common Tools
- clusterProfiler
- Enrichr
- g:Profiler
- ReactomePA
---
