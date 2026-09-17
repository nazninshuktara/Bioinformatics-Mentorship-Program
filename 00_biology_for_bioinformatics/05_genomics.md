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

# 14. Comparative Genomics

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

# 15. Functional Genomics

Functional genomics studies genome function on a large scale.

Approaches:

- Transcriptomics
- Proteomics
- Epigenomics
- CRISPR screening


Goal:

To understand how genes work together to control biological processes.


---

# 16. Epigenomics

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

# 17. Genomics and Bioinformatics

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

# 18. Genomics in Disease Research

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

# 19. Genomics in Biotechnology

Applications:

- Genome engineering
- Synthetic biology
- Vaccine development
- Microbial identification
- Agricultural improvement


---

# 20. References

- *Genomes* — T.A. Brown
- *Bioinformatics Data Skills* — Vince Buffalo
- *Human Molecular Genetics* — Strachan & Read
- NCBI Genome Resources