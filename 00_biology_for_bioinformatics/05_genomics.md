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