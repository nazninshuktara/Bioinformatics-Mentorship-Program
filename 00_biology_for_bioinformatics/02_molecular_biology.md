# Molecular biology

## 1. Overview & Scope
**Molecular biology** is the branch of biology that studies biological processes at the molecular level, particularly the structure and function of DNA, RNA, and proteins.

- DNA → stores genetic information
- RNA → carries/regulates genetic information
- Protein → performs cellular functions

It mainly focuses on how genetic information is stored, replicated, expressed, regulated, and transmitted. 

**Scope:** DNA replication, RNA processing, protein synthesis, gene regulation, mutations/repair, recombinant DNA tech, PCR, sequencing, molecular diagnostics, genomics, bioinformatics

**Molecular Biology vs Cell Biology**

| Molecular Biology | Cell Biology |
|---|---|
| Molecular-level processes | Cellular processes |
| DNA, RNA, proteins | Organelles, membranes, signaling |

## 2. Biotechnology
Application of biological systems/organisms/cells to develop useful products/processes.
Major areas: genetic engineering, molecular diagnostics, pharma biotech, industrial biotech, bioinformatics, agri-biotech

## 3. Genetic Engineering
Deliberate modification of genetic material — insert/delete/modify/regulate DNA sequences.
*Example:* recombinant human insulin production

## 4. Flow of Genetic Information/Central Dogma of Molecular Biology
The **Central Dogma** describes the flow of genetic information within a biological system:
```
DNA  --(Transcription)-->  RNA  --(Translation)-->  Protein
```
```
DNA → RNA = Transcription
RNA → Protein = Translation
DNA → DNA = Replication
RNA → DNA = Reverse transcription
```
First proposed by **Francis Crick (1958)**. It explains how genetic instructions stored in DNA are used to build functional proteins that carry out cellular processes.

## 5. Nucleic Acids
DNA and RNA are **nucleic acids** — polymers built from repeating monomer units called **nucleotides**. They store and transmit genetic information.

### Nucleotide Structure

Each nucleotide has 3 components:
1. **Pentose sugar** – deoxyribose (DNA) or ribose (RNA)
2. **Phosphate group** – links nucleotides together via phosphodiester bonds
3. **Nitrogenous base** – purine or pyrimidine

| Nucleoside | Nucleotide |
|---|---|
| Base + Sugar | Base + Sugar + Phosphate |

### Base Types

| Category | Bases | Found in |
|----------|-------|----------|
| Purines (double-ring) | Adenine (A), Guanine (G) | DNA & RNA |
| Pyrimidines (single-ring) | Cytosine (C), Thymine (T) | DNA only |
| Pyrimidines (single-ring) | Cytosine (C), Uracil (U) | RNA only |

- **Uracil (U)** replaces **Thymine (T)** in RNA.

## 6. DNA
- Functions: stores genetic info, replicates, templates RNA synthesis, transmits across generations
- Nucleotide = base + deoxyribose + phosphate
- Bases: Purines (A, G), Pyrimidines (C, T)
- Base pairing: A=T (2 H-bonds), G≡C (3 H-bonds) → GC-rich DNA more thermally stable
- Double helix: antiparallel, complementary base pairing, sugar-phosphate backbone
- DNA polymerase synthesizes only 5′→3′

- Complementary base pairing is the basis of:
  - DNA replication
  - Transcription (template strand pairing with RNA)
  - PCR primer design
  - Sequencing read alignment

- DNA Double Helix

- Discovered structurally by **Watson & Crick (1953)**, based on Rosalind Franklin's X-ray diffraction data (Photo 51).
- Right-handed double helix
- **Major groove** and **minor groove** — sites where proteins (transcription factors) bind DNA
- ~10.5 base pairs per helical turn

## 7. RNA
RNA stands for Ribo-nucleic Acid. In RNA, A pairs with U and G pairs with C.
Unlike DNA, RNA is usually single-stranded but folds back on itself to form secondary structures:

- **Hairpin loops / stem-loops** – common in tRNA, rRNA, regulatory elements
- **Pseudoknots**
- **Internal loops / bulges**

These structures are functionally important (e.g., tRNA cloverleaf structure, riboswitches, miRNA precursors).

RNA Differs from DNA in several ways.

| Feature | DNA | RNA |
|---------|-----|-----|
| Sugar | Deoxyribose (no OH at 2') | Ribose (OH at 2') |
| Strand | Double-stranded (usually) | Single-stranded (usually) |
| Bases | A, T, G, C | A, U, G, C |
| Stability | More chemically stable | Less stable (2'-OH makes it more reactive) |
| Structure | Double helix | Varied (hairpins, loops, folded structures) |
| Function | Long-term genetic storage | Gene expression, catalysis, regulation |

**Types:**

| RNA Type | Structure Note |
|----------|----------------|
| mRNA | Linear, capped (5') and polyadenylated (3') in eukaryotes |
| tRNA | Cloverleaf secondary structure → folds into L-shape |
| rRNA | Complex folded structure, forms ribosome scaffold with proteins |
| miRNA | ~22 nt, derived from hairpin precursor (pri-miRNA → pre-miRNA → mature miRNA) |
| lncRNA | >200 nt, diverse structures, regulatory functions |


## 8. DNA Packaging & Organization
DNA molecules are extremely long. Therefore, they must be compactly organized inside the cell.

- **Organization**: DNA → Nucleosome → Chromatin → Chromosome

- Histones - DNA-associated proteins that help package DNA to form nucleosomes
- Nucleosome - Basic repeating unit of chromatin. It consists of DNA wrapped around a histone protein core
- Chromatin - complex of DNA + proteins. It packages DNA and also participates in regulation of gene accessibility.

| Euchromatin | Heterochromatin |
|---|---|
| Less condensed, more transcriptionally active | More condensed, less active |
| More accessible | Less accessible |

- Chromosome - Highly organized structure containing DNA and associated proteins. It carries genes and other genomic elements.
- Telomere — Repetitive DNA-protein structures at chromosome ends. Protect chromosome ends from degradation and inappropriate DNA repair
- Centromere — Specialized chromosome region important for chromosome segregation during cell division. It is associated with formation of the kinetochore, which interacts with spindle microtubules.


## 9. Replication (DNA → DNA)
- Process by which DNA makes a copy of itself before cell division.
- Ensures genetic continuity across generations of cells.
- Key enzyme: **DNA polymerase**
- Semi-conservative: each new DNA molecule has one old strand + one new strand.

**Key features**: Semi-conservative, template-directed, bidirectional, 5′ → 3′ synthesis

- Semi-Conservative Replication - One parental strand + One newly synthesized strand
- Origin of Replication - specific DNA sequence where replication begins.
- Replication Fork - the region where the parental DNA strands are separated and new DNA is synthesized.
- Leading strand — continuous; Lagging strand — discontinuous (Okazaki fragments)
- Okazaki Fragments - Short DNA fragments produced during lagging-strand synthesis. They are later joined by DNA ligase.

**Why is DNA synthesized 5′ → 3′?**
DNA polymerase adds new nucleotides to the 3′-OH group of the growing strand.
Therefore synthesis proceeds: 5′ → 3′

| Enzyme | Function |
|---|---|
| Helicase | Unwinds DNA |
| Primase | Synthesizes RNA primer |
| DNA polymerase | Synthesizes DNA |
| DNA ligase | Joins fragments |
| Topoisomerase | Relieves torsional stress |

## 10. Transcription (DNA → RNA)
The process of synthesizing RNA using DNA as a template.
DNA → RNA via RNA polymerase
- Steps:
  1. **Initiation** – RNA polymerase binds to the promoter region of a gene.
  2. **Elongation** – RNA polymerase reads the DNA template strand (3'→5') and synthesizes RNA (5'→3').
  3. **Termination** – RNA polymerase reaches a terminator sequence and releases the RNA transcript.
- Produces **pre-mRNA**, which undergoes further processing.

### RNA Processing (Eukaryotes only)
- **5' capping** – Addition of a modified guanine cap to the 5′ end, protects RNA, aids ribosome binding
- **3' polyadenylation** – Addition of a poly(A) tail to the 3′ end, stabilizes RNA
- **Splicing** – introns removed, exons joined together (by the **spliceosome**)
- Alternative splicing allows one gene to produce multiple protein variants
- Promoter → transcription initiation site
- Template strand (read) vs Coding strand (matches RNA, T instead of U)

## 11. Translation (RNA → Protein)
The process of synthesizing a protein using the information encoded in mRNA.
mRNA → Protein, on ribosomes
- mRNA is decoded by **ribosomes** in the cytoplasm to synthesize a protein.
- Key players:
  - **mRNA** – carries the genetic code (codons, triplets of nucleotides)
  - **tRNA** – brings amino acids, matches codon via anticodon
  - **rRNA** – structural/catalytic component of ribosomes
- Steps:
  1. **Initiation** – Ribosome assembles on mRNA and identifies the start codon (AUG)
  2. **Elongation** – tRNAs bring amino acids matching each codon; peptide bonds form
  3. **Termination** – stop codon (UAA, UAG, UGA) reached; polypeptide released

## 12. The Genetic Code
The set of rules by which nucleotide sequences in mRNA specify amino acids.
- 64 possible codons → 20 amino acids (code is **degenerate/redundant**)
- Codon (mRNA, 3 nt) / Anticodon (tRNA, 3 nt)
- Start Codon: AUG (Met); Stop: UAA, UAG, UGA
- Code is (near) **universal** across most organisms
- Ribosome sites: A (entry), P (peptidyl), E (exit)

## 13. Gene Structure
A **gene** is a segment of DNA that contains the information needed to produce a functional product — typically a protein, but also functional RNAs (tRNA, rRNA, miRNA, etc.). Gene structure differs between **prokaryotes** and **eukaryotes**, and understanding it is essential for interpreting annotation files (GTF/GFF) and RNA-seq data.

### General Structure of a Eukaryotic Gene
```
5' ---[Promoter]---[5'UTR]---[Exon1]-[Intron1]-[Exon2]-[Intron2]-[Exon3]---[3'UTR]---[Terminator]--- 3'
_____________ Transcribed region _____________/
```
### Key Components

| Element | Description |
|---------|-------------|
| **Promoter** | Region upstream of TSS where RNA polymerase & transcription factors bind |
| **TSS (Transcription Start Site)** | Point where transcription begins |
| **5' UTR** | Untranslated region before start codon; involved in translation regulation |
| **Exons** | Coding + retained sequences after splicing |
| **Introns** | Non-coding sequences removed during splicing |
| **3' UTR** | Untranslated region after stop codon; contains regulatory elements (e.g., miRNA binding sites) |
| **Terminator** | Signals end of transcription; polyadenylation signal (AAUAAA) in eukaryotes |

### Regulatory Elements

- **Promoter** – DNA region involved in initiating transcription. core region for RNA Pol II binding (often contains TATA box)
- **Enhancers** – Regulatory DNA element that can increase transcription when bound by appropriate regulatory proteins. can be far from gene (upstream/downstream/intronic); increase transcription; work even at long distances via DNA looping
- **Silencers** – Regulatory DNA element that can reduce gene transcription. 
- **Insulators** – block enhancer-promoter interaction, define regulatory domains

### Exon-Intron Structure & Splicing

- Introns begin with **GT** and end with **AG** (GT-AG rule) — recognized by spliceosome
- Exons are joined together to form mature mRNA
- **Alternative splicing** allows a single gene to produce multiple mRNA isoforms:
  - Exon skipping
  - Alternative 5'/3' splice sites
  - Intron retention
  - Mutually exclusive exons
  
### Prokaryotic vs Eukaryotic Gene Structure

| Feature | Prokaryotic | Eukaryotic |
|---------|-------------|------------|
| Introns | Absent (mostly) | Present |
| Operons | Common (polycistronic mRNA) | Absent (monocistronic mRNA) |
| Promoter | Simple (-10, -35 boxes) | Complex (TATA box, multiple TFs) |
| mRNA processing | Minimal | Capping, splicing, polyadenylation |
| Gene density | High, compact genome | Lower, more non-coding DNA |

### Operons (Prokaryotes)
- A cluster of genes transcribed together under one promoter → single polycistronic mRNA
- Example: *lac* operon in *E. coli*

### Coordinates & Annotation
Gene structure is represented computationally in annotation files:
- **GTF/GFF** – describe gene, transcript, exon, CDS coordinates on the reference genome
- Each feature has: chromosome, start, end, strand (+/-), feature type
- Tools like **STAR/HISAT2** use this annotation for splice-aware alignment
- **featureCounts / htseq-count** use exon/gene coordinates to count reads per gene

Example GTF line (conceptual):
```
chr1 HAVANA exon 11869 12227 . + . gene_id "ENSG00000223972"; transcript_id "ENST00000456328";
```

- Coding Region - Contains information that contributes to the amino acid sequence of a protein.
- Regulatory Region - Regulatory regions control when, where, and how strongly a gene is expressed.
- Gene expression: DNA → RNA → Protein → Cellular Function
- Constitutive (continuous) vs Regulated (condition-dependent) expression

## 14. Genome organization
Genome organization refers to how genetic material is packaged, structured, and arranged within a cell. It differs significantly between prokaryotes and eukaryotes, and understanding it is key to interpreting genome assemblies and sequencing data.

### Prokaryotic Genome Organization

- Typically a **single circular chromosome**, located in the **nucleoid** (no membrane-bound nucleus)
- Compact genome, gene-dense, few non-coding regions
- May contain **plasmids** – small circular DNA molecules, often carrying antibiotic resistance genes (relevant for infectious disease/AMR work)
- No histones; DNA supercoiled with help of nucleoid-associated proteins

### Eukaryotic Genome Organization

- DNA is **linear**, organized into multiple **chromosomes**, housed in a membrane-bound **nucleus**
- DNA is packaged with **histone proteins** into **chromatin**
- Levels of packaging:
  1. DNA double helix
  2. Nucleosomes (DNA wrapped around histone octamers) — "beads on a string"
  3. 30nm chromatin fiber
  4. Looped domains
  5. Condensed chromosome (during cell division)

### Chromatin States

| State | Description |
|-------|-------------|
| **Euchromatin** | Loosely packed, transcriptionally active |
| **Heterochromatin** | Tightly packed, transcriptionally silent/inactive |

### Ploidy

- **Haploid (n)** – one set of chromosomes (e.g., gametes)
- **Diploid (2n)** – two sets of chromosomes (e.g., human somatic cells, 46 chromosomes / 23 pairs)
- Polyploidy is common in plants, rare in animals

### Genome Size & Complexity
   
- Genome size does not necessarily correlate with organismal complexity ("C-value paradox")
- Human genome: ~3.1 billion base pairs, ~20,000 protein-coding genes
- Large portion of eukaryotic genomes is **non-coding DNA** (regulatory elements, introns, repetitive elements, transposons)

### Repetitive Elements
- **Transposable elements (TEs)** – ~45% of human genome (e.g., LINEs, SINEs like Alu elements)
- **Tandem repeats** – microsatellites, minisatellites, telomeric repeats
- Relevant for read mapping (multi-mapping reads) and structural variant detection

### Organellar Genomes

- **Mitochondrial DNA (mtDNA)** – circular, maternally inherited, separate from nuclear genome
- **Chloroplast DNA (cpDNA)** – in plants, circular, involved in photosynthesis genes

## 15. Mutation & Genetic Variation
A **mutation** is a change in the DNA sequence. Mutations are the raw material of genetic variation and are central to understanding disease, evolution, and variant calling in bioinformatics.

**Possible effects**:    
- Neutral
- Harmful
- Beneficial


| Type | Description |
|---|---|
| Point mutation | Single nucleotide change |
| SNP | Common population variant |
| Insertion/Deletion | Nucleotide(s) added/removed |
| Frameshift | Indel disrupts reading frame |
| Silent | No amino acid change |
| Missense | Changes amino acid |
| Nonsense | Creates premature stop codon |
| Loss/Gain-of-function | Reduces/increases gene product function |

- **Germline mutations** – present in reproductive cells, heritable, present in all cells of offspring
- **Somatic mutations** – occur in non-reproductive cells, not heritable, relevant in cancer genomics

### Mutation by Location

| Location | Consequence |
|----------|-------------|
| Coding region (exon) | May alter protein sequence |
| Intron | Usually no direct protein effect, but can disrupt splice sites |
| Splice site | Can cause exon skipping/intron retention |
| Promoter/regulatory region | Can alter gene expression levels |
| UTR | Can affect mRNA stability, translation efficiency |

### Zygosity

| Term | Meaning |
|------|---------|
| **Homozygous** | Same allele on both chromosome copies |
| **Heterozygous** | Different alleles on each chromosome copy |


## 16. DNA Damage & Repair
Causes: UV, ROS, chemicals, replication errors

| Repair type | Function |
|---|---|
| Mismatch repair | Corrects mispaired bases |
| Base excision repair | Removes damaged base |
| Nucleotide excision repair | Removes bulky lesions (UV damage) |
| Homologous recombination | Template-based, accurate |
| NHEJ | Direct end-joining, no template |

## 17. Epigenetics
Heritable gene-activity changes without DNA sequence change
- DNA methylation (CpG cytosines) — often represses transcription
- Histone modification (acetylation, methylation) — affects chromatin
- Chromatin remodeling — alters nucleosome positioning/accessibility
- Gene Silencing and Activation - influence whether genes are accessible for transcription.

## 18. Recombinant DNA Technology
- Recombinant DNA - DNA constructed by combining genetic material from different sources.
- Restriction enzymes — cleave at specific sequences
- Sticky ends (overhangs) vs Blunt ends (none)
- DNA ligase — joins fragments
- Plasmid/Vector — small, usually circular, extrachromosomal DNA molecule commonly found in bacteria. carries DNA in host; Insert — the introduced fragment
- Insert → Transformation → Selection → Screening

**Workflow:** Target DNA → Restriction digestion → Ligation → Recombinant vector → Host cell → Selection → Screening

## 19. Molecular Biology Techniques
- **DNA-based:** extraction, purification, quantification, PCR, qPCR, gel electrophoresis, Sanger sequencing, NGS
- **RNA-based:** extraction, QC, cDNA synthesis, RT-PCR, qRT-PCR, RNA-seq
- **Protein-based:** SDS-PAGE, Western blot, ELISA

## 20. PCR
Polymerase Chain Reaction is an in-vitro technique used to amplify a specific DNA sequence.
**Components**: template DNA, primers, DNA polymerase, dNTPs, Mg²⁺, buffer, water
**Steps**: Denaturation(Double-stranded DNA separates into single strands) → Annealing(Primers bind to complementary target sequences) → Extension(DNA polymerase extends the primers and synthesizes new DNA)
- Taq polymerase — thermostable, from *Thermus aquaticus*
- Primer-dimer — unintended primer self/cross-interaction product
- qPCR — real-time quantitative monitoring

## 21. Gel Electrophoresis
**Principles**: DNA (negative charge) migrates toward positive electrode. Smaller DNA fragments migrate faster and farther than larger fragments.
- Agarose Gel - Agarose forms a porous matrix through which DNA fragments migrate.
- DNA ladder — known-size reference. used to estimate the size of unknown DNA fragments.

## 22. DNA Sequencing
- Sanger — Sanger sequencing uses chain-terminating ddNTPs to determine DNA sequence. ddNTP → chain termination. The resulting fragments are separated and detected to determine the nucleotide sequence.
- NGS — NGS allows large numbers of DNA molecules to be sequenced simultaneously.
- FASTQ (reads + quality) vs FASTA (sequence only)

**NGS workflow:** DNA/RNA → Library Prep → Sequencing → QC → Reads → Alignment/Quantification → Downstream Analysis

## 23. Molecular Diagnostics
Applications: pathogen detection, mutation detection, genetic testing, cancer biomarkers
*Example (RNA virus):* RNA → cDNA → PCR/qPCR → Detection

## 24. Molecular Biology in Biotechnology
- Genetic engineering, recombinant protein production (e.g., insulin)
- Vaccine development, molecular diagnostics
- Cancer research, infectious disease research, AMR research
- Drug discovery, gene therapy
- Bioinformatics, RNA-seq

**RNA-seq workflow:** RNA extraction → Library prep → Sequencing → FASTQ → QC → Alignment/quantification → Differential expression → Biological interpretation

## 25.References
- Molecular Biology of the Cell (Alberts et al.)

---

# Required Practical - Molecular Biology Laboratory Techniques

## Practical 1 — DNA Extraction and Purification

### Aim

To isolate purified genomic DNA from biological samples for downstream applications such as PCR, sequencing, genotyping, cloning, or molecular analysis.

### Principle

DNA extraction involves:

**Cell lysis → DNA release → Removal of proteins and contaminants → DNA purification → DNA recovery**

Cells and, where relevant, nuclei are disrupted to release DNA. Proteins, lipids, salts, and other contaminants are removed. The purified DNA is then recovered in nuclease-free water or an appropriate storage buffer.

### Common Materials

- Biological sample
- Lysis buffer
- Protein-removal reagent or protease
- DNA-binding column, magnetic beads, or precipitation reagents
- Ethanol or isopropanol, where applicable
- Microcentrifuge tubes
- Micropipettes and sterile tips
- Microcentrifuge
- Nuclease-free water or DNA storage buffer

### General Workflow

1. Collect the biological sample.
2. Add lysis buffer.
3. Disrupt cells to release nucleic acids.
4. Remove proteins and cellular debris.
5. Separate or bind DNA, depending on the extraction method.
6. Wash away contaminants.
7. Elute or resuspend purified DNA.
8. Measure DNA concentration, purity, and integrity.

### Common DNA Extraction Methods

| Method | Basic concept |
|---|---|
| Organic extraction | Uses organic solvents to separate DNA from proteins and lipids |
| Salt precipitation | Uses salt and alcohol to precipitate DNA |
| Spin-column extraction | DNA binds to a silica membrane and contaminants are washed away |
| Magnetic-bead extraction | DNA binds to magnetic beads and is purified using magnetic separation |

### Important Points

- Use clean tubes and tips to avoid contamination.
- Avoid vigorous mixing if high-molecular-weight DNA is required.
- Use appropriate storage conditions to prevent DNA degradation.
- DNA quality should be checked before sensitive downstream assays.

---
## Practical 2 — DNA Quantification and Quality Assessment

### Aim

To determine DNA concentration, purity, and integrity.

### Principle

Nucleic acids absorb ultraviolet light strongly at approximately 260 nm. Absorbance-based instruments estimate nucleic acid concentration and provide purity ratios.

### Important Parameters

| Parameter | Meaning |
|---|---|
| DNA concentration | Amount of DNA, commonly expressed as ng/µL |
| A260/A280 | Indicates possible protein contamination |
| A260/A230 | Indicates possible contamination from salts, phenol, carbohydrates, or extraction reagents |
| DNA integrity | Indicates whether DNA is intact or degraded |

### General Interpretation

- Purified double-stranded DNA commonly has an **A260/A280 ratio near 1.8**.
- RNA commonly has an **A260/A280 ratio near 2.0**.
- An **A260/A230 ratio around 2.0–2.2** is generally desirable.

Low ratios do not prove one specific contaminant, but they can indicate that the sample requires further purification or careful interpretation.

### Methods

| Method | Use |
|---|---|
| NanoDrop or spectrophotometer | Estimates concentration and purity ratios |
| Qubit or fluorometer | More specific concentration measurement, especially for low-concentration samples |
| Agarose gel electrophoresis | Assesses DNA size and integrity |

### General Procedure

1. Prepare the instrument.
2. Blank it with the same buffer used for the DNA sample.
3. Load the DNA sample.
4. Record concentration, A260/A280, and A260/A230.
5. Assess integrity by gel electrophoresis if required.
6. Decide whether the DNA is suitable for the planned downstream application.

---
## Practical 3 — Agarose Gel Electrophoresis

### Aim

To separate DNA fragments by size and visualize DNA bands.

### Principle

DNA has a negatively charged phosphate backbone. In an electric field, DNA migrates toward the positive electrode.

The agarose gel acts as a molecular sieve:

- Smaller DNA fragments generally move faster.
- Larger DNA fragments generally move more slowly.

### Materials

- Agarose
- Running buffer
- DNA samples
- DNA ladder
- Loading dye
- Electrophoresis chamber
- Power supply
- DNA stain or visualization system

### General Workflow

**Prepare gel → Load DNA ladder and samples → Run electrophoresis → Visualize bands → Interpret results**

### Role of Important Components

| Component | Role |
|---|---|
| Agarose | Forms a porous matrix for separating DNA fragments |
| DNA ladder | Contains fragments of known sizes for estimating unknown DNA size |
| Loading dye | Helps track sample loading and migration |
| Running buffer | Provides ions needed for electrical current and maintains pH |
| DNA stain | Allows DNA bands to be visualized |

### Band Interpretation

| Observation | Possible interpretation |
|---|---|
| Clear single band | Expected DNA fragment or specific PCR product |
| Multiple bands | Non-specific amplification, mixed template, or multiple DNA products |
| Smear | Degraded DNA, overloading, contamination, or unsuitable run conditions |
| Very faint band | Low DNA concentration or poor detection |
| No band | No DNA, failed PCR, loading problem, or detection issue |

---
## Practical 4 — Polymerase Chain Reaction (PCR)

### Aim

To amplify a specific DNA sequence.

### Principle

PCR is an *in vitro* method used to produce many copies of a defined DNA region.

The three main stages are:

**Denaturation → Annealing → Extension**

Repeated cycles produce exponential amplification of the target region.

### Main Components

| Component | Role |
|---|---|
| Template DNA | Contains the target sequence |
| Forward primer | Defines one boundary of the target region |
| Reverse primer | Defines the opposite boundary of the target region |
| DNA polymerase | Synthesizes new DNA strands |
| dNTPs | Building blocks for DNA synthesis |
| Mg²⁺ | Required cofactor for polymerase activity |
| Reaction buffer | Maintains appropriate chemical conditions |
| Nuclease-free water | Adjusts final reaction volume |

### PCR Cycle

1. **Denaturation**  
   Double-stranded DNA separates into single strands.

2. **Annealing**  
   Primers bind to complementary sequences on the template DNA.

3. **Extension**  
   DNA polymerase extends from the primers and synthesizes new DNA.

### PCR Controls

| Control | Purpose |
|---|---|
| Positive control | Confirms that the PCR system can amplify a known target |
| No-template control | Detects possible reagent contamination |
| Negative control | Helps identify non-specific or unwanted amplification |

### Applications

- Detection of DNA sequences
- Genotyping
- Cloning
- Pathogen detection
- Mutation analysis
- DNA sequencing preparation

---
## Practical 5 — Primer Design and PCR Troubleshooting

### Primer Design Basics

Primers are short DNA sequences that determine which region will be amplified by PCR.

A good primer pair should have:

- Target specificity
- Suitable primer length
- Similar melting temperatures
- Balanced GC content
- Minimal self-complementarity
- Minimal primer-dimer potential
- Appropriate expected amplicon size

### Common PCR Problems

| Problem | Possible cause |
|---|---|
| No band | Poor template quality, missing reagent, unsuitable primers, incorrect cycling conditions, or PCR inhibition |
| Multiple bands | Low annealing temperature, poor primer specificity, excessive template, or excessive cycle number |
| Primer-dimer | Primers anneal to each other and form a short non-specific product |
| Smearing | Poor template quality, too much template, non-specific amplification, or unsuitable conditions |
| Weak band | Low template amount, inefficient amplification, or insufficient detection |

### General Troubleshooting Strategy

1. Check positive and no-template controls.
2. Verify template quality and amount.
3. Confirm primer sequence and expected amplicon size.
4. Review primer concentration.
5. Optimize annealing conditions.
6. Check reaction components and thermal cycling parameters.
7. Confirm that the correct PCR product is being assessed on a gel.

---
## Practical 6 — PCR Product Purification and Gel Extraction

### Aim

To purify a PCR product or recover a specific DNA band from an agarose gel.

### Principle

PCR cleanup removes unwanted reaction components, such as:

- Primers
- dNTPs
- Enzymes
- Salts
- Small non-specific products

Gel extraction allows recovery of a DNA fragment of the desired size after gel electrophoresis.

### Workflow

**PCR product → Cleanup or gel separation → DNA purification → Purified DNA**

### Applications

- Sanger sequencing
- Cloning
- Restriction digestion
- Ligation
- Template preparation for downstream assays

### Important Considerations

- Select the correct target band.
- Avoid contamination from nearby bands.
- Confirm DNA concentration after purification.
- Use purified DNA promptly or store it appropriately.

---
## Practical 7 — RNA Extraction, Quantification, and Quality Assessment

### Aim

To isolate high-quality RNA from biological samples.

### Principle

RNA extraction involves:

**Cell lysis → RNA release → Removal of contaminants → RNA purification → RNA recovery**

RNA is highly susceptible to degradation by RNases. Therefore, careful RNase-free technique is essential.

### Materials

- Biological sample
- RNA extraction reagent or kit
- RNase-free tubes
- RNase-free pipette tips
- Clean gloves
- Centrifuge
- RNA storage solution
- DNase treatment reagent, where appropriate

### General Workflow

**Sample → Cell lysis → RNA release → Contaminant removal → RNA purification → RNA quality assessment**

### RNA Quality Assessment

| Parameter | Importance |
|---|---|
| Concentration | Determines amount available for downstream analysis |
| Purity | Indicates possible contamination |
| Integrity | Indicates whether RNA is degraded |
| Genomic DNA contamination | Can interfere with RT-PCR and RT-qPCR |

### Important Precautions

- Use RNase-free tubes and pipette tips.
- Keep samples cold where appropriate.
- Avoid repeated freeze-thaw cycles.
- Wear clean gloves.
- Maintain a clean RNase-free workspace.
- Use DNase treatment when genomic DNA contamination is a concern.

### Applications

- cDNA synthesis
- RT-PCR
- RT-qPCR
- RNA sequencing
- Gene-expression analysis

---
## Practical 8 — cDNA Synthesis / Reverse Transcription

### Aim

To convert RNA into complementary DNA, or cDNA.

### Principle

**RNA → cDNA**

The enzyme **reverse transcriptase** synthesizes cDNA using RNA as a template.

### Main Components

- RNA template
- Reverse transcriptase
- Primers
- dNTPs
- Reaction buffer
- Nuclease-free water

### Primer Types for Reverse Transcription

| Primer type | General use |
|---|---|
| Oligo(dT) primers | Bind to poly(A) tails of many eukaryotic mRNAs |
| Random primers | Can generate cDNA from many RNA regions |
| Gene-specific primers | Used when cDNA is needed for a specific RNA target |

### Workflow

**RNA → Reverse transcription → cDNA → PCR or RT-qPCR**

### Importance

PCR amplifies DNA templates. Therefore, RNA is first converted into cDNA before PCR-based gene-expression analysis.

---
## Practical 9 — End-point RT-PCR

### Aim

To detect RNA-derived targets after reverse transcription and conventional PCR.

### Principle

End-point RT-PCR involves:

**RNA → cDNA → Conventional PCR → Agarose gel electrophoresis**

The amplified product is assessed at the end of the reaction, usually by gel electrophoresis.

### Applications

- Detection of transcript presence
- RNA-virus detection concept
- Confirmation of gene expression
- Molecular diagnostics concept

### Difference Between End-point RT-PCR and RT-qPCR

| End-point RT-PCR | RT-qPCR |
|---|---|
| Product is assessed after amplification | Fluorescence is measured during amplification |
| Usually gel-based | Real-time fluorescence-based |
| Mainly qualitative or semi-quantitative | Can support quantitative analysis |

---

## Practical 10 — RT-qPCR / Real-Time PCR and Data Interpretation

### Aim

To detect and quantify nucleic acid amplification in real time.

### Principle

qPCR measures fluorescence during DNA amplification.

**Target DNA increases → Fluorescence increases**

For RNA expression studies:

**RNA → cDNA → Real-time PCR = RT-qPCR**

### Ct or Cq Value

Ct or Cq is the cycle at which fluorescence crosses a defined threshold.

- Lower Ct or Cq generally indicates more starting target.
- Higher Ct or Cq generally indicates less starting target.

This interpretation requires proper assay performance and suitable controls.

### Important Controls

| Control | Purpose |
|---|---|
| No-template control | Detects reagent contamination |
| No-RT control | Detects possible genomic DNA contamination |
| Technical replicate | Assesses technical consistency |
| Reference gene | Normalizes variation in input and reaction handling |

### Relative Gene-Expression Analysis

**ΔCt = Ct(target) − Ct(reference)**

**ΔΔCt = ΔCt(sample) − ΔCt(control)**

**Relative expression = 2⁻ΔΔCt**

The 2⁻ΔΔCt method is appropriate when target and reference-gene amplification efficiencies are sufficiently similar and the reference gene is stable under the experimental condition.

### Melt Curve

A melt curve helps assess whether amplification is consistent with a specific product in dye-based qPCR assays.

---
## Practical 11 — Restriction Digestion

### Aim

To cut DNA at specific recognition sequences using restriction enzymes.

### Principle

Restriction enzymes are endonucleases that recognize specific DNA sequences and cleave DNA at or near those sequences.

### Types of DNA Ends

| End type | Description |
|---|---|
| Sticky ends | Short single-stranded overhangs that can base-pair with complementary ends |
| Blunt ends | DNA ends without single-stranded overhangs |

### Workflow

**DNA + Restriction enzyme → Incubation → DNA fragments → Gel electrophoresis**

### Applications

- DNA cloning
- Plasmid verification
- Recombinant DNA construction
- DNA fragment analysis

---

## Practical 12 — DNA Ligation

### Aim

To join DNA fragments together.

### Principle

DNA ligase joins DNA fragments by forming phosphodiester bonds in the sugar-phosphate backbone.

### Workflow

**Vector + Insert → DNA ligase → Recombinant plasmid**

### Key Concepts

| Component | Role |
|---|---|
| Vector | DNA molecule that carries the insert |
| Insert | DNA fragment of interest |
| DNA ligase | Enzyme that joins DNA fragments |
| Compatible ends | Ends that allow vector and insert to join efficiently |

### Applications

- Molecular cloning
- Plasmid construction
- Recombinant protein production
- Genetic engineering

---

## Practical 13 — Bacterial Transformation and Antibiotic Selection

### Aim

To introduce plasmid DNA into competent bacterial cells.

### Principle

Transformation is the uptake of external DNA by bacterial cells.

### General Workflow

**Competent cells → Plasmid DNA → DNA uptake → Recovery → Antibiotic selection → Colonies**

### Antibiotic Selection

Many plasmids contain an antibiotic-resistance marker.

Under the correct selective condition:

- Cells carrying the plasmid are expected to grow.
- Cells without the plasmid are expected not to grow.

### Applications

- Plasmid propagation
- Cloning
- Recombinant protein expression
- Genetic engineering

---

## Practical 14 — Colony PCR

### Aim

To screen bacterial colonies for the presence of a desired DNA insert.

### Principle

PCR is performed using colony material or colony-derived material as the DNA source.

### Workflow

**Bacterial colony → Colony PCR → Gel electrophoresis → Band analysis → Candidate positive clone**

### Interpretation

| Result | Interpretation |
|---|---|
| Expected-size band | Candidate positive colony |
| No expected band | Candidate negative colony or failed reaction |
| Incorrect-size band | Possible non-specific product or incorrect construct |

A colony PCR result identifies candidate clones. Final confirmation may require plasmid isolation, restriction analysis, or Sanger sequencing.

---

## Practical 15 — Plasmid DNA Isolation / Miniprep

### Aim

To isolate plasmid DNA from bacterial cells.

### Principle

A common plasmid isolation method uses **alkaline lysis**.

Bacterial cells are lysed. During neutralization and clarification, chromosomal DNA, proteins, and cellular debris are separated from plasmid DNA. The plasmid DNA is then purified.

### Workflow

**Bacterial culture → Cell harvesting → Alkaline lysis → Neutralization → Clarification → Plasmid purification → Plasmid DNA**

### Quality Assessment

- Plasmid concentration
- Purity ratios
- Agarose gel profile
- Restriction digestion pattern
- Sequencing confirmation

### Applications

- Restriction digestion
- Ligation
- Transformation
- Sanger sequencing
- Recombinant protein expression

---

## Practical 16 — Plasmid Verification

### Aim

To confirm that a plasmid contains the expected insert.

### Common Verification Methods

| Method | What it can show |
|---|---|
| Colony PCR | Presence of candidate insert |
| Restriction digestion | Expected fragment pattern and approximate insert size |
| Agarose gel electrophoresis | DNA fragment pattern |
| Sanger sequencing | Exact nucleotide sequence and insert orientation |

### Workflow

**Candidate colony → Miniprep → Restriction analysis or PCR → Gel electrophoresis → Sequencing confirmation**

### Important Point

A correct band size does not guarantee that the full sequence is correct. Sanger sequencing is commonly used for final confirmation.

---

## Practical 17 — Sanger DNA Sequencing

### Aim

To determine the nucleotide sequence of a DNA fragment.

### Principle

Sanger sequencing uses chain termination by modified nucleotides called **ddNTPs**.

When a ddNTP is incorporated, DNA extension stops because it lacks the 3′-OH group needed for further DNA synthesis.

### Important Components

- Template DNA
- Sequencing primer
- DNA polymerase
- dNTPs
- Fluorescently labelled ddNTPs

### Result

The sequencing instrument produces a **chromatogram** or **electropherogram**.

Each peak represents one nucleotide base.

### Applications

- Plasmid verification
- PCR-product verification
- Mutation confirmation
- Insert orientation confirmation
- Small-scale DNA sequence analysis

---

## Practical 18 — Basic Next-Generation Sequencing Workflow

### Principle

Next-generation sequencing, or NGS, refers to high-throughput sequencing technologies that generate a very large number of DNA or RNA sequence reads in parallel.

### Basic Workflow

**Sample → DNA/RNA extraction → Quality assessment → Library preparation → Adapter addition → Sequencing → FASTQ files → Quality control → Alignment or quantification → Downstream analysis**

### Important Terms

| Term | Meaning |
|---|---|
| Library | Prepared DNA or cDNA fragments suitable for sequencing |
| Adapter | Short sequence added during library preparation for sequencing and sample identification |
| Index or barcode | Sequence used to distinguish samples in pooled sequencing runs |
| Read | Sequence generated by a sequencing instrument |
| FASTQ | File format containing nucleotide sequences and per-base quality scores |
| Phred score | Numerical estimate of base-calling quality |
| Quality control | Assessment of read quality before analysis |
| Alignment | Mapping reads to a reference genome or sequence |
| Quantification | Estimating abundance of genes, transcripts, or DNA targets |
| Variant calling | Identifying sequence variants in DNA sequencing data |

### Common NGS Applications

- Whole-genome sequencing
- Targeted sequencing
- Amplicon sequencing
- RNA-seq
- Metagenomics
- Variant detection
- Gene-expression profiling
