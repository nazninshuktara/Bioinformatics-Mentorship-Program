# 🧬 Day 5 — Introduction to Bulk RNA-Seq - From Quality Control to Pathway Analysis

> **Week 3, Day 5** · Friday, July 17, 2026  
> **Author:** Naznin Akter
---

## 🎯 Learning Checklist
- [1] General principles of RNA-Seq
- [2] Guidance on best practices for experimental design
- [3] A walk through of the steps involved in RNA-seq analysis 
- [4] Reference to applicable file formats
- [5] Reference to appropriate software tools and principle for RNA-seq data analysis
---

## 1. Introduction to Omics and Transcriptomics
**Omics** refers to high-throughput disciplines that analyze comprehensive biological datasets to understand complex cellular functions, disease dynamics, and phenotypes.

```text
               ┌────────────────────────┐
               │        Genomics        │ (DNA)
               └───────────┬────────────┘
                           │
               ┌───────────▼────────────┐
               │     Epigenomics        │ (DNA Modifications)
               └───────────┬────────────┘
                           │
               ┌───────────▼────────────┐
               │    Transcriptomics     │ (RNA Transcripts)
               └───────────┬────────────┘
                           │
               ┌───────────▼────────────┐
               │       Proteomics       │ (Proteins)
               └───────────┬────────────┘
                           │
               ┌───────────▼────────────┐
               │      Metabolomics      │ (Metabolites)
               └────────────────────────┘
```

### The Spectrum of Transcriptomics Technologies
Transcriptomics studies is the collection of all RNA transcripts produced by a genome within specific cells. Depending on the resolution and context, several approaches exist:
- **Bulk Transcriptomics**: Analyzes gene expression from pooled cells (typically millions) to deliver an average expression profile.
- **Single-Cell Transcriptomics**: Measures gene expression in individual cells, enabling cell-type classification, identification of rare cell populations, and heterogeneity mapping.
- **Spatial Transcriptomics**: Measures gene expression while preserving spatial location within tissue sections.
- **Meta-Transcriptomics**: Quantifies gene expression across entire microbial or mixed-organism communities in natural environments.
- **CircRNA Transcriptomics**: Focuses specifically on non-coding circular RNAs formed by back-splicing.

### Advantages and Disadvantages of Bulk Transcriptomics
| Pros | Cons |
|--------|-----------------------|
| Provides rapid, accessible quantification of active gene expression. | Provides an averaged snapshot across all cell types in a sample.|
| Directly samples the protein-coding transcriptome. | Fails to capture cell-to-cell variability or rare cell populations. |
| Allows detection of alternative splicing and coding region SNPs. | Absence of mRNA does not prove genomic absence. |
| Cost-effective for large sample cohorts. | Highly sensitive to batch effects and experimental design. |
---

## 2. RNA-Seq Library Preparation & Sequencing
Since high-throughput sequencers cannot read RNA directly, it must be converted to cDNA.

1. **RNA Isolation & Enrichment**: Total RNA is extracted. Poly-A selection or rRNA depletion is performed to enrich mRNA.

2. **Fragmentation**: Long RNA molecules are fragmented into smaller pieces.

3. **cDNA Synthesis**: Reverse transcriptase synthesizes stable double-stranded cDNA.

4. **Adapter Ligation**: Sequencing adapters are attached to cDNA ends for multiplexing and flow-cell binding.

5. **Perform PCR Enrichment/Amplification**

### How to Sequence RNA?
- **Illumina Sequencing**: Fragments are arranged on a flow cell grid, probes are attached, and individual nucleotides are identified via fluorescent colors to generate digital sequencing data.

- **Phred Quality Score**: Indicates the accuracy and reliability of the base-calling performed by the sequencing instrument.
---

## 3. Raw Data and Data Processing
**FASTQ File Format**
Sequencing platforms output raw reads in FASTQ format. Every single read is represented by 4 lines:

- **Line 1**: @NS500177:196:HFTTTAFXX:1:11101:10916:1458 2:N:0:CGCGGCTG (Sequence Header & Unique ID starting with @)

- **Line 2**: ACACGACGATGAGGTGACAGTCACGGAGGATAAGATCAATGCCCTCATTAAAGCAGCCGGTGTAA (Actual nucleotide sequence (A, C, G, T))

- **Line 3**: + (Separator)

- **Line 4**: AAAAAEEEEEEEEEEE//AEEEAEEEEEEEEEEE/EE/<<EE/AAEEAEE///EEEEAEEEAEA< ## (Phred --- 3. Considerations Design Experimental Quality Scores) ```> [!WARNING]

### Data Preparation-The ultimate preprocessing steps
1. Filter out garbage or low-quality reads.
2. **Read Alignment**: Map high-quality reads back to a reference genome.
3. **Read Counting**: Count how many reads map to each specific gene to construct a Count Matrix.
---

## 4. Experimental Design and Replicates
> **Technical vs. Biological Replicates**
> * **Technical Replicates:** Repeating the assay on the same biological sample. Measures technical variation (rarely required in modern RNA-Seq).
> * **Biological Replicates:** Samples taken from independent biological subjects (e.g., 3 different mice). *A minimum of 3+ biological replicates per condition is required for statistical power in differential expression analysis.*

> [!NOTE]
> **Batch Effects**: 
> Non-biological variations introduced by handling samples in different batches, days, or by different technicians. Randomization and processing samples simultaneously prevent batch bias.

---

## 5. Bulk RNA-Seq Analysis Workflow & Pipeline

| Step | Description | Standard Tools | File Formats |
| :--- | :--- | :--- | :--- |
| **1. Quality Control** | Assess sequence quality and trim adapters/low-quality bases. | FastQC, Trimmomatic, Cutadapt | `.fastq`, `.fastq.gz` |
| **2. Read Alignment** | Map sequencing reads back to a reference genome/transcriptome. | STAR, HISAT2, Salmon | `.sam`, `.bam` |
| **3. Read Quantification** | Count the number of reads mapped to each gene/feature. | featureCounts, HTSeq, StringTie | `.txt`, `.csv` |
| **4. Differential Expression** | Identify statistically significant differentially expressed genes (DEGs). | DESeq2, edgeR, limma (R packages) | `.csv`, `.RData` |
| **5. Functional Analysis** | Perform Gene Ontology (GO) and pathway enrichment analysis. | clusterProfiler, FGSEA, Enrichr | Figures (`.png`, `.pdf`) |

---

## 6. Self-Assessment Questions

1. What is the key difference between **poly-A selection** and **rRNA depletion** during library prep?
2. What information is stored in **Line 4** of a FASTQ file?
3. Why are **biological replicates** preferred over technical replicates in DE analysis?
4. Name two popular aligners used for spliced RNA-Seq read mapping.

🔗 Recommended Resources
- [StatQuest](https://statquest.org/)
- [Introduction to RNA-Seq using high-performance computing - ARCHIVED](https://hbctraining.github.io/Intro-to-rnaseq-hpc-salmon/lessons/experimental_planning_considerations.html)





