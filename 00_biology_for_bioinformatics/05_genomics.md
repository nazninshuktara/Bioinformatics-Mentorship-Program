# Genomics

## 1. Overview & Scope

**Genomics** is the branch of biology that studies the complete set of genetic material (genome) of an organism, including its structure, function, evolution, and interactions.

Unlike genetics, which often focuses on individual genes or traits, genomics studies the entire genome at a large scale.

- Genome → Complete set of DNA in an organism
- Genomics → Study of complete genome information

**Scope:**

- Genome sequencing
- Genome assembly
- Genome annotation
- Comparative genomics
- Functional genomics
- Population genomics
- Structural variation analysis
- Genome-based disease studies


**Applications:**

- Disease genetics
- Precision medicine
- Evolutionary biology
- Pathogen surveillance
- Drug discovery
- Agriculture biotechnology
- Bioinformatics research


---

# 2. Genome

A **genome** is the complete collection of genetic material present in an organism.

It includes:

- Protein-coding genes
- Non-coding regions
- Regulatory elements
- Repetitive sequences
- Structural elements


## Human Genome

Key features:

- Approximately 3.1 billion base pairs
- 23 chromosome pairs
- Around 20,000 protein-coding genes
- Large proportion of non-coding DNA


---

# 3. Genome Organization

## Prokaryotic Genome

Characteristics:

- Usually one circular chromosome
- Located in nucleoid region
- Compact genome
- High gene density
- May contain plasmids


## Eukaryotic Genome

Characteristics:

- Multiple linear chromosomes
- Located inside nucleus
- Contains introns and regulatory regions
- Large amount of non-coding DNA


Genome organization:
```
Genome
  ↓
Chromosome
  ↓
DNA
  ↓
Gene
  ↓
Transcript
  ↓
Protein
```


---

# 4. Types of Genomics

## Structural Genomics

Studies:

- Genome organization
- Genome sequence
- Chromosome structure
- Genetic variation


## Functional Genomics

Studies:

- Gene function
- Gene expression
- Regulatory networks

Examples:

- RNA-seq
- CRISPR screening


## Comparative Genomics

Compares genomes between:

- Different species
- Different populations
- Different strains


## Population Genomics

Studies genome variation within populations.

Applications:

- Evolution
- Disease risk
- Genetic diversity


---

# 5. Genome Sequencing

Genome sequencing determines the complete DNA sequence of an organism.

## Sanger Sequencing

Features:

- High accuracy
- Low throughput
- Used for small DNA regions


## Next Generation Sequencing (NGS)

Features:

- High throughput
- Millions of reads simultaneously
- Used for whole genome sequencing


## Long-read Sequencing

Examples:

- Oxford Nanopore
- PacBio

Advantages:

- Long DNA fragments
- Better repetitive region resolution
- Improved genome assembly


---

# 6. Whole Genome Sequencing (WGS)

Whole Genome Sequencing determines the complete DNA sequence of an organism.

Workflow:
```
DNA Extraction
        ↓
Library Preparation
        ↓
Sequencing
        ↓
Raw Reads
        ↓
Quality Control
        ↓
Genome Assembly / Alignment
        ↓
Variant Detection
        ↓
Genome Annotation
```


Applications:

- Disease mutation discovery
- Pathogen identification
- Population studies
- Evolution research


---

# 7. Genome Assembly

Genome assembly reconstructs the original genome sequence from sequencing reads.

Input:
```
Short DNA Reads
```

Output:
```
Complete Genome Sequence
```


## Assembly Approaches

### Reference-based Assembly

Reads are aligned to an existing reference genome.

Advantages:

- Faster
- Requires reference genome


### De novo Assembly

Genome is assembled without a reference.

Advantages:

- Useful for new organisms


Important concepts:

- Contig
- Scaffold
- Assembly quality


---

# 8. Genome Annotation

Genome annotation identifies and describes genome features.

It includes:

- Gene locations
- Coding regions
- Regulatory regions
- Functional information


Annotation steps:
```
Genome Sequence
        ↓
Gene Prediction
        ↓
Functional Annotation
        ↓
Biological Interpretation
```


Common annotation formats:

- GFF
- GTF


---

# 9. Reference Genome

A **reference genome** is a standard genome sequence used as a comparison framework.

Applications:

- Read alignment
- Variant detection
- Genome analysis


Examples:

- Human reference genome
- SARS-CoV-2 reference genome


---

# 10. Genetic Variants in Genomics

Genomic variation refers to differences in DNA sequences among individuals.

Major types:

## SNP (Single Nucleotide Polymorphism)

Single base change.

Example:
```
A → G
```


## Small Indels

Insertion or deletion of small DNA segments.


## Structural Variants

Large genomic changes:

- Deletion
- Duplication
- Inversion
- Translocation


## Copy Number Variation (CNV)

Changes in the number of copies of genomic regions.


---

# 11. Variant Calling

Variant calling identifies differences between sample genome and reference genome.

Workflow:
```
Sequencing Reads
        ↓
Quality Control
        ↓
Read Alignment
        ↓
Variant Calling
        ↓
Variant Filtering
        ↓
Variant Annotation
```


Common tools:

- BWA
- SAMtools
- GATK


---

# 12. Variant Annotation

Variant annotation determines the biological effect of genetic variants.

Possible effects:

- Coding variant
- Missense mutation
- Nonsense mutation
- Splice-site variant
- Regulatory variant


Tools:

- ANNOVAR
- VEP (Variant Effect Predictor)


---

# 13. Genome Databases

Important genomic databases:

| Database | Purpose |
|---|---|
| NCBI | Genome and sequence data |
| Ensembl | Genome annotation |
| UCSC Genome Browser | Genome visualization |
| dbSNP | SNP database |
| ClinVar | Clinical variants |
| COSMIC | Cancer mutations |


---
# 14. Pathogen Genomics Basics
Given the program's focus on **infectious disease research**, understanding how pathogen genomes differ from human genomes — and how they're studied — is foundational before moving into pathogen-specific bioinformatics workflows (outbreak genomics, AMR detection, variant surveillance).

## Bacterial Genomes

- Typically a **single circular chromosome**, ~1-10 Mb (much smaller than human's ~3.1 Gb)
- Gene-dense, minimal non-coding DNA, no introns (mostly)
- Often carry **plasmids** – small, circular, extrachromosomal DNA
  - Plasmids frequently carry **antibiotic resistance genes (AMR)** and virulence factors
  - Can be transferred between bacteria (horizontal gene transfer) — important for AMR spread
- Reproduce by binary fission; genome replicates as a whole

## Viral Genomes

- Highly variable: can be DNA or RNA, single-stranded (ss) or double-stranded (ds)

| Genome Type | Examples |
|-------------|----------|
| dsDNA | Herpesvirus, Adenovirus |
| ssDNA | Parvovirus |
| dsRNA | Rotavirus |
| ssRNA (+) (positive-sense) | SARS-CoV-2, Dengue |
| ssRNA (-) (negative-sense) | Influenza, Ebola |
| Retrovirus (ssRNA, reverse-transcribed) | HIV |

- Much smaller genomes than bacteria (few kb to ~200 kb)
- RNA viruses mutate faster (no proofreading in RNA-dependent RNA polymerase) — relevant for tracking viral evolution/variants
- No independent metabolism — obligate intracellular parasites, rely on host cell machinery

## Bacterial vs Viral Genome — Quick Comparison

| Feature | Bacteria | Virus |
|---------|----------|-------|
| Genome type | DNA (circular chromosome) | DNA or RNA |
| Size | ~1-10 Mb | ~1kb - 200kb |
| Independent replication | Yes | No (needs host cell) |
| Plasmids | Common | Absent |
| Mutation rate | Lower | Higher (esp. RNA viruses) |

## Antimicrobial Resistance (AMR) — Genomic Basis

- Resistance can arise via:
  - **Chromosomal mutations** (e.g., target site modification)
  - **Acquisition of resistance genes** via plasmids, transposons, or integrons (horizontal gene transfer)
- Common AMR gene databases used in bioinformatics: **CARD**, **ResFinder**, **NCBI AMRFinderPlus**
- AMR detection workflow (conceptual): WGS reads → assembly or direct read mapping → compare against AMR gene database → report resistance genes/mutations present

## Outbreak & Variant Surveillance (context)

- **Variant calling** in pathogens tracks mutations relevant to:
  - Transmissibility
  - Immune escape (e.g., SARS-CoV-2 spike protein variants)
  - Drug resistance
- **Phylogenetics** – building trees from pathogen genome sequences to trace transmission chains and outbreak origins
- Relevant tools (context, not required yet): Nextstrain, Pangolin (SARS-CoV-2 lineage), snippy (bacterial variant calling)

## Host-Pathogen Interaction (brief)

- Innate immune response – first-line, non-specific (e.g., interferons, inflammation)
- Adaptive immune response – specific, involves antibodies (B cells) and T cells, provides memory
- Relevant for RNA-seq: host transcriptomic response to infection is itself a common RNA-seq study design (e.g., comparing infected vs uninfected host tissue expression)


# 15. Comparative Genomics

Comparative genomics compares genome sequences between organisms.

Applications:

- Evolutionary relationships
- Conserved genes
- Functional regions
- Pathogen comparison


Concepts:

- Sequence similarity
- Homologous genes
- Conserved regions


---

# 16. Functional Genomics

Functional genomics studies genome function on a large scale.

Approaches:

- Transcriptomics
- Proteomics
- Epigenomics
- CRISPR screening


Goal:

To understand how genes work together to control biological processes.


---

# 17. Epigenomics

Epigenomics studies genome-wide changes that regulate gene activity without changing DNA sequence.

Examples:

- DNA methylation
- Histone modification
- Chromatin accessibility


Techniques:

- ATAC-seq
- ChIP-seq
- Bisulfite sequencing


---

# 18. Genomics and Bioinformatics

Genomics requires computational analysis because genome data is extremely large.

Important skills:

- Linux
- Programming
- Statistics
- Data analysis


Common tools:

| Analysis | Tools |
|---|---|
| Read QC | FastQC, MultiQC |
| Alignment | BWA, Bowtie2 |
| Assembly | SPAdes |
| Variant Calling | GATK, SAMtools |
| Annotation | VEP, ANNOVAR |
| Visualization | IGV, UCSC Browser |


---

# 19. Genomics in Disease Research

Applications:

- Cancer genome analysis
- Rare disease diagnosis
- Infectious disease surveillance
- Pharmacogenomics


Example:
```
Patient DNA
      ↓
Whole Genome Sequencing
      ↓
Variant Identification
      ↓
Clinical Interpretation
```


---

# 20. Genomics in Biotechnology

Applications:

- Genome engineering
- Synthetic biology
- Vaccine development
- Microbial identification
- Agricultural improvement


---

# 21. References

- *Genomes* — T.A. Brown
- *Bioinformatics Data Skills* — Vince Buffalo
- *Human Molecular Genetics* — Strachan & Read
- NCBI Genome Resources


---

# Required Practical - Genomics

## Practical 1 — Genomic DNA Extraction and Quality Assessment

### Aim

To isolate high-quality genomic DNA suitable for sequencing and genomics analysis.

### Principle

Genomic DNA extraction involves:

**Cell lysis → DNA release → Removal of proteins and contaminants → DNA purification → DNA quality assessment**

High-quality DNA is needed for whole-genome sequencing, targeted sequencing, variant analysis, and genome assembly.

### Materials

- Biological sample
- DNA extraction reagent or kit
- Lysis buffer
- Protein-removal reagent
- Microcentrifuge tubes
- Micropipettes and tips
- Centrifuge
- Nuclease-free water or DNA storage buffer
- NanoDrop or Qubit
- Agarose gel electrophoresis system

### General Workflow

1. Collect the biological sample.
2. Lyse cells to release DNA.
3. Remove proteins, RNA, and contaminants where appropriate.
4. Purify genomic DNA.
5. Elute or resuspend DNA.
6. Measure DNA concentration and purity.
7. Assess DNA integrity using agarose gel electrophoresis if required.

### Quality Assessment

| Parameter | Importance |
|---|---|
| DNA concentration | Determines whether enough DNA is available for library preparation |
| A260/A280 ratio | Indicates possible protein contamination |
| A260/A230 ratio | Indicates possible reagent or salt contamination |
| DNA integrity | Indicates whether DNA is intact or degraded |

---

## Practical 2 — Whole-Genome Sequencing Library Preparation

### Aim

To convert genomic DNA into a sequencing-ready library.

### Principle

Library preparation converts genomic DNA into DNA fragments compatible with a sequencing platform.

### General Workflow

```text
Genomic DNA
 ↓
DNA fragmentation
 ↓
End repair
 ↓
Adapter ligation
 ↓
Indexing or barcoding
 ↓
Library amplification where required
 ↓
Library quality control
 ↓
Sequencing-ready library
```
### Important Steps
- DNA fragmentation
- End repair
- Adapter ligation
- Indexing or barcoding
- Library amplification
- Library quantification
- Fragment-size assessment
- Sample pooling where appropriate

### Important Terms
|Term	| Meaning |
|Library | Prepared DNA fragments suitable for sequencing |
|Adapter | Short DNA sequence added for sequencing |
|Index or barcode | Sequence used to distinguish samples in a pooled run |
|Paired-end sequencing | Both ends of a DNA fragment are sequenced |
|Coverage |	Average number of sequencing reads covering a genomic region |


## Practical 3 — Sequencing Data Retrieval and Raw Read Quality Control

### Aim
To organize raw sequencing data and assess read quality before analysis.

### Principle
Sequencing instruments generate raw reads, commonly stored in FASTQ files. Read quality must be checked before alignment, assembly, or variant calling.

### FASTQ File Content
A FASTQ record includes:
1. Sequence identifier
2. Nucleotide sequence
3. Separator line
4. Per-base quality score

### Quality-Control Checks
- Per-base quality score
- Read-length distribution
- Adapter contamination
- GC-content distribution
- Sequence duplication
- Overrepresented sequences
- Total number of reads

### Common Tools
| Tool | Use |
| FastQC |	Quality control for individual FASTQ files | |
| MultiQC |	Combined quality-control summary for multiple samples
| fastp |	Read filtering and quality control |
| Cutadapt | Adapter trimming |


### General Workflow

```
FASTQ files
 ↓
FastQC
 ↓
MultiQC summary
 ↓
Adapter and quality assessment
 ↓
Read trimming or filtering if required
 ↓
Post-trimming quality control
```
---

## Practical 4 — Read Alignment and Alignment Quality Assessment

### Aim
To align sequencing reads to a reference genome and assess alignment quality.

### Principle
Read alignment maps sequencing reads to a known reference genome.
This is commonly used for:
- Human genome analysis
- Pathogen genome analysis
- Variant calling
- Targeted sequencing analysis

### General Workflow

```
Quality-controlled reads
 ↓
Reference genome preparation
 ↓
Read alignment
 ↓
SAM or BAM file generation
 ↓
Sorting and indexing
 ↓
Alignment quality assessment

```

### Important Terms
| Term |	Meaning |
| Reference genome |	Standard genome sequence used for comparison |
| SAM |	Text-based alignment format |
| BAM |	Compressed binary alignment format |
| Mapping rate |	Percentage of reads aligned to the reference |
| Coverage |	Number of reads covering a genomic position |
| Depth | Sequencing coverage at a specific location |


### Common Tools
| Tool |	Use |
| BWA	| DNA-sequence alignment |
| Bowtie2	| Short-read alignment |
| SAMtools |	BAM/SAM processing and statistics |
| IGV	| Alignment visualization |

---

## Practical 5 — Genome Assembly and Assembly Quality Assessment

### Aim
To reconstruct a genome sequence from sequencing reads.

### Principle
Genome assembly combines sequencing reads into longer DNA sequences.

### Assembly Approaches

| Approach |	Description |
| Reference-based assembly |	Reads are aligned to an existing reference genome |
| De novo assembly |	Genome is assembled without a reference genome |


### General Workflow
```
Quality-controlled reads
 ↓
Genome assembly
 ↓
Contigs
 ↓
Scaffolds where applicable
 ↓
Assembly quality assessment
 ↓
Genome annotation
```

### Important Terms

| Term | Meaning |
|---|---|
| Contig | Continuous DNA sequence assembled from reads |
| Scaffold | Ordered or linked group of contigs |
| N50 | Assembly-contiguity metric |
| Coverage | Amount of sequence data supporting an assembly |
| Assembly quality | Completeness, contiguity, and possible error assessment |

### Common Tools

| Tool | Use |
|---|---|
| SPAdes | De novo genome assembly |
| Flye | Long-read genome assembly |
| QUAST | Assembly-quality assessment |
| Bandage | Assembly-graph visualization |

---

## Practical 6 — Variant Calling, Filtering, and Annotation

### Aim
To identify genomic variants between a sample and a reference genome.

### Principle
Variant calling identifies DNA differences between sequencing reads and a reference genome.

### General Workflow
```
Aligned reads
 ↓
Variant calling
 ↓
VCF file
 ↓
Variant filtering
 ↓
Variant annotation
 ↓
Biological interpretation
```

### Major Variant Types

| Variant type | Description |
|---|---|
| SNP | Single-nucleotide change |
| Indel | Small insertion or deletion |
| CNV | Copy-number gain or loss |
| Structural variant | Large deletion, duplication, inversion, or translocation |

### Variant Annotation

Annotation helps determine whether a variant is located in:

- Coding region
- Non-coding region
- Splice site
- Regulatory region
- Known disease-associated gene

### Common Tools

| Tool | Use |
|---|---|
| GATK | Variant calling and filtering |
| SAMtools / BCFtools | Variant analysis |
| VEP | Variant-effect prediction |
| ANNOVAR | Variant annotation |
| IGV | Visual inspection of variants |

---

## Practical 7 — Comparative Genomics and Phylogenetic Analysis

### Aim
To compare genome sequences and investigate genetic relationships among organisms, strains, or isolates.

### Principle
Comparative genomics identifies similarities and differences between genomes.
Phylogenetic analysis uses sequence variation to estimate evolutionary relationships.

###General Workflow
```
Genome sequences or variants
 ↓
Sequence alignment
 ↓
Identification of genetic differences
 ↓
Phylogenetic tree construction
 ↓
Interpretation of relatedness
```

###Applications
- Comparison of pathogen strains
- Outbreak investigation
- Evolutionary studies
- Identification of conserved genes
- Detection of lineage-specific mutations

### Important Terms
| Term	| Meaning
| Homologous genes	| Genes related through common ancestry |
| Conserved region	| DNA sequence retained across organisms |
| Phylogenetic tree	| Diagram showing inferred evolutionary relationships |
| Lineage	| Group of related organisms sharing common ancestry |
| Genetic distance	| Estimate of sequence difference between samples |

---

## Practical 8 — Pathogen Genomics, AMR Detection, and Genomic Surveillance

### Aim
To use genome sequencing data for pathogen identification, antimicrobial-resistance analysis, and outbreak surveillance.

###Principle
Pathogen genomics compares microbial genome data with reference genomes and curated databases.

### General Workflow
```
Pathogen sample
 ↓
DNA or RNA extraction
 ↓
Sequencing
 ↓
Read quality control
 ↓
Alignment or genome assembly
 ↓
Variant and lineage analysis
 ↓
AMR gene or mutation detection
 ↓
Phylogenetic interpretation
 ↓
Surveillance report
```

### Antimicrobial Resistance Analysis

Resistance may arise through:
- Chromosomal mutations
- Acquisition of resistance genes
- Plasmids
- Transposons
- Integrons

###Common AMR Resources
| Resource	| Use |
| CARD	| Antibiotic-resistance gene database |
| ResFinder	| Resistance-gene identification |
| NCBI AMRFinderPlus	| AMR gene and mutation analysis |


### Applications
- Pathogen identification
- Outbreak investigation
- Variant surveillance
- Tracking transmission
- Monitoring antimicrobial-resistance genes
- Comparing pathogen isolates

### Important Note
Genomic findings must be interpreted with sample quality, sequencing coverage, laboratory information, clinical context, and relevant surveillance guidelines.
---