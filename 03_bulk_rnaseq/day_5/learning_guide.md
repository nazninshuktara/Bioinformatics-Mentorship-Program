# 🧬 Day 5 — Introduction to Bulk RNA-Seq - From Quality Control to Pathway Analysis

> **Week 3, Day 5** · Friday, July 17, 2026  
> **Author:** Naznin Akter
---

## 🎯 Learning Checklist
- [1] General principles of RNA-Seq
- [2] Guidance on best practices for experimental design
- [3] A walk-through of the steps involved in RNA-seq analysis 
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
Each layer answers a different question. 
*Genomics* tells you what genes could be expressed. 
*Transcriptomics* tells you what genes are actually being read at a given moment, in a given condition — the most direct window into a cell's current state and response to a stimulus (like infection), even though it's one step removed from the functional molecules (proteins) that actually do the work.

#### **Why transcriptomics specifically, and not proteomics, for most infection/disease studies?**
RNA-seq is cheaper, faster, and technically more mature than proteomics, and changes in transcription are usually the earliest measurable signal of a cellular response — even if the protein-level effect lags behind or gets modified post-translationally.

### The Spectrum of Transcriptomics Technologies
Transcriptomics studies is the collection of all RNA transcripts produced by a genome within specific cells. Depending on the resolution and context, several approaches exist:
- **Bulk RNA-seq**: Analyzes gene expression from pooled cells (typically millions) to deliver an average expression profile. Fast, cheap, well-established statistics — but cannot distinguish "small change in every cell" from "large change in a minority of cells." Both look identical in bulk data.
- **Single-Cell RNA-seq**: Measures gene expression in individual cells, enabling cell-type classification, identification of rare cell populations, and heterogeneity mapping. Resolves expression per individual cell — needed to say "which specific immune cell type is responding" rather than "the tissue as a whole shows an interferon signature."
- **Spatial Transcriptomics**: Measures gene expression while preserving spatial location within tissue sections. keeps tissue architecture intact — you know not just what is expressed but where, important for something like an infection site where the immediate microenvironment differs from surrounding tissue.
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
- **Illumina Sequencing**: Fragments are arranged on a flow cell grid, probes are attached, and individual nucleotides are identified via fluorescent colors to generate digital sequencing data. This cycle-by-cycle chemistry is why quality degrades toward the read's 3' end — optical/chemical errors accumulate (signal decay, phasing/pre-phasing).

- **Phred Quality Score**: Indicates the accuracy and reliability of the base-calling performed by the sequencing instrument.Q = -10 × log10(P); Q20 → 1% error rate, Q30 = 0.1% error rate, the common "good read" threshold.

> [!NOTE]
> **Library prep choice matters**: poly-A selection misses non-coding RNA and performs poorly on degraded samples; rRNA depletion keeps mRNA + many ncRNAs and works better on degraded/FFPE material. Strandedness must be correctly specified to your aligner/quantifier (Salmon/STAR) — getting it wrong silently corrupts quantification.

---

## 3. Raw Data and Data Processing
**FASTQ File Format**
Sequencing platforms output raw reads in FASTQ format. Every single read is represented by 4 lines:

```
@NS500177:196:HFTTTAFXX:1:11101:10916:1458 2:N:0:CGCGGCTG
ACACGACGATGAGGTGACAGTCACGGAGGATAAGATCAATGCCCTCATTAAAGCAGCCGGTGTAA
+
AAAAAEEEEEEEEEEE//AEEEAEEEEEEEEEEE/EE/<<EE/AAEEAEE///EEEEAEEEAEA
```
- **Line 1**: @NS500177:196:HFTTTAFXX:1:11101:10916:1458 2:N:0:CGCGGCTG (Sequence Header & Unique ID starting with @)

- **Line 2**: ACACGACGATGAGGTGACAGTCACGGAGGATAAGATCAATGCCCTCATTAAAGCAGCCGGTGTAA (Actual nucleotide sequence (A, C, G, T))

- **Line 3**: + (Separator)

- **Line 4**: AAAAAEEEEEEEEEEE//AEEEAEEEEEEEEEEE/EE/<<EE/AAEEAEE///EEEEAEEEAEA< ## (Phred --- 3. Considerations Design Experimental Quality Scores) ```> [!WARNING]

>[!WARNING] 
> **Preprocessing is not optional**. 
> Skipping QC/trimming propagates adapter contamination and low-quality bases downstream into alignment and quantification, silently biasing results.

### Data Preparation-The ultimate preprocessing steps
1. Filter out garbage or low-quality reads.
2. **Read Alignment**: Map high-quality reads back to a reference genome.
3. **Read Counting**: Count how many reads map to each specific gene to construct a Count Matrix.

### Quality Control
FastQC is the standard tool to inspect raw reads before any downstream processing. Key checks and what they actually mean:

| FastQC Metric | What It Shows | Why It Happens / Matters |
|---------------|---------------|--------------------------|
| Per-base sequence quality | Quality score across read positions | Quality typically drops toward the 3' end — a known artifact of sequencing-by-synthesis (signal decay & dephasing accumulate over cycles) |
| Adapter content | % of reads containing adapter sequence | Happens when the fragment insert is shorter than the read length, so sequencing "reads through" into the adapter — must be trimmed or it corrupts alignment |
| Per-sequence GC content | Distribution of GC% across reads | Should roughly match expected transcriptome GC%; skew suggests contamination or library prep bias |
| Sequence duplication levels | % of reads that are exact duplicates | Unlike DNA-seq, some duplication is expected and normal in RNA-seq — highly expressed genes naturally produce many identical reads |
| Overrepresented sequences | Specific sequences appearing far more than expected | Often adapters, or rRNA/mitochondrial contamination if depletion failed |
| Per-base N content| Fraction of ambiguous base calls | High N content signals sequencer/base-calling problems |

> [!NOTE] 
> **QC is a before-and-after check**. 
> Run FastQC on raw reads, trim (adapters + low-quality bases via Trimmomatic/Cutadapt), then re-run FastQC on trimmed reads to confirm the issues were actually resolved — not just assumed fixed. Aggregate many samples' reports at once with MultiQC.

> [!WARNING] 
> Over-trimming (too aggressive quality/length cutoffs) shortens reads and can reduce mappability; under-trimming leaves adapter contamination that causes poor or false alignments. Both directions cause real downstream errors — QC parameters aren't "safe to over-do."

---

## 4. Experimental Design and Replicates

> **Technical vs. Biological Replicates**
> * **Technical Replicates:** Repeating the assay on the same biological sample. Measures technical variation (rarely required in modern RNA-Seq).
> * **Biological Replicates:** Samples taken from independent biological subjects (e.g., 3 different mice). *A minimum of 3+ biological replicates per condition is required for statistical power in differential expression analysis.*

> [!NOTE]
> **Batch Effects**: 
> Non-biological variations introduced by handling samples in different batches, days, or by different technicians. Randomization and processing samples simultaneously prevent batch bias from being confounded with the biological variable of interest.

---

## 5. Bulk RNA-Seq Analysis Workflow & Pipeline

| Step | Description | Standard Tools | File Formats |
| :--- | :--- | :--- | :--- |
| **1. Quality Control** | Assess sequence quality and trim adapters/low-quality bases. | FastQC, Trimmomatic, Cutadapt | `.fastq`, `.fastq.gz` |
| **2. Read Alignment** | Map sequencing reads back to a reference genome/transcriptome. | STAR, HISAT2, Salmon | `.sam`, `.bam` |
| **3. Read Quantification** | Count the number of reads mapped to each gene/feature. | featureCounts, HTSeq, StringTie | `.txt`, `.csv` |
| **4. Differential Expression** | Identify statistically significant differentially expressed genes (DEGs). | DESeq2, edgeR, limma (R packages) | `.csv`, `.RData` |
| **5. Pathway Analysis** | Perform Gene Ontology (GO) and pathway enrichment analysis. | clusterProfiler, FGSEA, Enrichr | Figures (`.png`, `.pdf`) |
---

## 6. The Statistics That Decide What's "Significant"
- **Negative binomial model**: RNA-seq counts are discrete and overdispersed (variance > mean, more than Poisson predicts). NB adds a dispersion parameter to capture that — standard in DESeq2/edgeR.
- **Library size normalization**:  DESeq2's median-of-ratios method is robust to a few highly/differentially expressed genes skewing size estimates
- **Dispersion shrinkage**: with ~3 replicates/group, per-gene dispersion estimates alone are noisy. DESeq2 fits a mean-dispersion trend across all genes and shrinks each gene's estimate toward it — borrowing strength across genes.
- **Design formula & contrasts**: `~ condition + batch` models both, testing condition while holding batch constant. The reference level sets fold-change direction — get it wrong and "upregulated" genes are backwards. A contrast specifies exactly which comparison, needed whenever >2 groups exist.
- **Multiple testing correction**: testing ~20,000 genes at raw p<0.05 yields ~1,000 false positives by chance alone. Benjamini-Hochberg FDR controls the expected proportion of false positives among significant hits — that's `padj`, not `pvalue`. Using raw `pvalue` is one of the most common, consequential mistakes.
- **log2FC shrinkage**: low-count/high-variance genes produce noisy, exaggerated raw fold changes (2→8 counts is "4-fold" with almost no confidence). `apeglm`/`ashr` pull these toward zero proportional to uncertainty — why `lfcShrink()` is recommended before ranking/plotting
---
## 7. Downstream Visualization
| Plot | Axes | Purpose | 
| :--- | :--- | :--- |
| **PCA** | PC1 vs PC2 | Sample clustering, outlier/batch detection |
| **Volcano** | log2FC vs -log10(padj) | Effect size and significance together — flags "significant but trivial" genes |
| **MA plot** | mean expression vs log2FC | Check fold-change stability across expression range, visualize shrinkage |
| **Heatmap + clustering** | genes/samples both axes | Groups by similarity (Euclidean/1-correlation distance) — reveals modules, confirms grouping |
---
## 8. Pathway / Functional Enrichment Analysis
| Approach | Basis | Input | Key Trait |
| :--- | :--- | :--- | :--- |
| **GO(Gene Ontology)** | Curated ontology: Biological Process, Molecular Function, Cellular Component | Gene list or ranked list | Defines the annotation categories used by ORA/GSEA |
| **ORA(Over-Representation Analysis)** | Hypergeometric test | Thresholded significant-gene list | Simple, but discards borderline genes near the cutoff |
| **GSEA(Gene Set Enrichment Analysis)** | Running-sum enrichment score (KS-test-like) | Full ranked gene list | Threshold-free, generally more statistically powerful |
| **KEGG / Reactome** | Curated pathway databases | Gene sets for ORA/GSEA | Represent metabolic and signaling pathway structure |

> [!NOTE] 
> **Background gene set matters**: For ORA, the background should be all genes tested for DE — not the whole genome — otherwise enrichment statistics are biased by genes never expressed in your tissue/condition.

---

## 9. The Whole Pipeline in One Picture
```
FASTQ (raw reads + Phred quality)
   ↓  
FastQC → identify adapter/quality issues
   ↓
Trimmomatic/Cutadapt/fastp → remove adapters & low-quality bases
   ↓
FastQC again → confirm the fix worked
   ↓
STAR/HISAT2 (alignment) or Salmon (pseudoalignment)
   ↓   
featureCounts/HTSeq or tximport → gene-level counts matrix
   ↓
DESeq2: size factors (median-of-ratios) → dispersion shrinkage
        → design formula & contrast → NB hypothesis testing
   ↓
Multiple testing correction (padj) + log2FC shrinkage (apeglm/ashr)
   ↓  
Visualization: PCA (QC check) → volcano/MA (results) → heatmap
   ↓
Pathway analysis: ORA or GSEA against GO/KEGG/Reactome
   ↓
Biological interpretation
```

🔗 Recommended Resources
- [StatQuest](https://statquest.org/)
- [Introduction to RNA-Seq using high-performance computing - ARCHIVED](https://hbctraining.github.io/Intro-to-rnaseq-hpc-salmon/lessons/experimental_planning_considerations.html)





