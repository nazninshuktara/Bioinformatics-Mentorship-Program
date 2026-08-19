# 🧬 Day 6 — Bulk RNAseq Data Analysis: From Fastq to Counts Matrix

> **Week 3, Day 6** · Saturday, July 18, 2026  
> **Author:** Naznin Akter
---

## 🎯 Learning Checklist
- [1] Explain each stage between raw sequencing reads and a gene-level counts matrix
- [2] Run quality control on raw FASTQ files and interpret the report
- [3] Build a decoy-aware Salmon index from a reference transcriptome + genome
- [4] Quantify transcript abundance with Salmon (pseudoalignment)
- [5] Import transcript-level quantifications into R and summarize to gene-level counts with tximport
- [6] Produce a counts matrix ready for DESeq2
---

## 🔍 Prerequisites
- Linux/Ubuntu terminal basics (cd, ls, mkdir, piping)
- R basics
- pixi environment recommended
- Tools confirmed installed: `parallel-fastq-dump`, `fastqc`, `multiqc`, `salmon`, `R (tximport)`
- Dataset used: GSE245922 (NCBI GEO dataset)

## 📁 Project Directory Structure
```
salmon_rnaseq/
├── inputs/           # SRR_Acc_list, SRA_Run_table, decoys, GENCODE fasta files, human_salmon_index
├── fastq/            # raw downloaded FASTQ files
├── outputs/          # qc, salmon_out, figures, tables
└── scripts/          # Bash & R pipeline scripts
```

---

## 📑 Step-by-Step Pipeline Guide

### 💡Step 0 — Environment Setup

``` bash        
#!/usr/bin/

# Initialize a pixi project (run once, from salmon_rnaseq/)
pixi init salmon_rnaseq
cd salmon_rnaseq

# Add required tools from conda-forge/bioconda channels
pixi project channel add conda-forge bioconda
pixi add sra-tools parallel-fastq-dump fastqc multiqc trimmomatic salmon r-base bioconductor-tximport

# Activate the environment
pixi shell
```

> [!NOTE] 
> Commit `pixi.toml` / `pixi.lock` to your GitHub repo — this is what makes your pipeline reproducible for anyone (including future-you) re-running the analysis.

Confirm each tool is reachable before moving on:

``` bash        
#!/usr/bin/env bash

fastqc --version
salmon --version
Rscript -e 'library(tximport); packageVersion("tximport")'
```

### 💡Step 1 — Download / Locate FASTQ Files

GSE245922 samples come from SRA — download using the accession list rather than one-by-one. Use 
`scripts/01_download_fastq.sh`

``` bash        
#!/usr/bin/

# Download FASTQ files using parallel-fastq-dump
# Reads accessions from ../inputs/SRR_Acc_List.txt
# Saves all FASTQ files in the root-level fastq/ directory
# Example:
# parallel-fastq-dump --sra-id SRR2244401 --threads 4 --outdir out/ --split-files --gzip

# Data: https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE245922

mkdir -p ../fastq

while read -r ACC; do
    [[ -z "$ACC" ]] && continue
    echo "Downloading $ACC ..."
    parallel-fastq-dump \
        --sra-id "$ACC" \
        --threads 4 \
        --outdir ../fastq \
        --split-files \
        --gzip
done < ../inputs/SRR_Acc_List.txt

echo "All FASTQ files are saved in ../fastq/"
```

- If starting from a GEO/SRA dataset, get the SRR accessions and use `prefetch` + `parallal-fastq-dump` (SRA toolkit), or download directly if FASTQs are provided.
- Organize files: `fastq/sample1_R1.fastq.gz`, `fastq/sample1_R2.fastq.gz` (paired-end) or single-end equivalents.
- Cross-check inputs/SRA_Run_table.txt against the downloaded files to confirm sample-to-condition mapping (treatment/control, replicate number) before proceeding — this is your metadata table for DESeq2 later.

> [!NOTE] 
> Keep raw files **read-only** once downloaded (`chmod 444../fastq/*.fastq.gz`) — accidental overwriting of raw data is a common, hard-to-recover mistake.

### 💡 Step 2 — Quality Control — FastQC + MultiQC

Run FastQC on all raw FASTQ files before touching anything else.Use `scripts/02_qc.sh`

```bash
#!/usr/bin/

# Run quality check with FastQC and MultiQC
# Input: FASTQ files in ../fastq/
# Output: QC reports in ../outputs/qc/

mkdir -p ../outputs/qc

echo "Running FastQC..."
fastqc ../fastq/*.fastq.gz -o ../outputs/qc/

echo "Running MultiQC..."
multiqc ../outputs/qc/ -o ../outputs/qc/

echo "Quality check complete! Reports saved in ../outputs/qc/"
```
**What to check in the MultiQC summary:**
- Per-base sequence quality (should stay green/Q>28 across most of the read)
- Adapter content
- Sequence duplication levels (some duplication is *normal* in RNA-seq)
- Over-represented sequences (often adapter or rRNA contamination)

> [!NOTE]
> This pipeline quantifies directly from raw reads in Step 4 — Salmon's `--validateMappings` mode is fairly robust to residual adapter content and low-quality tails, so a separate trimming step is skipped here. Still open the MultiQC report before moving on: if adapter content or quality looks unusually bad for a specific sample, that's worth flagging even without a dedicated trim step.

### 💡 Step 3 — Build the Decoy-Aware Salmon Index
`scripts/03_build_salmon_index.sh`:

```bash
#!/usr/bin/

# Step 1. Download the latest GENCODE files
# Visit: https://www.gencodegenes.org/human/
# Fasta files > Transcript sequences > Right Click on Fasta > Copy link address > Paste here
TRANS_URL="https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_49/gencode.v49.pc_transcripts.fa.gz"

# Visit: https://www.gencodegenes.org/human/
# Fasta files > Genome sequence, primary assembly (GRCh38) > Right Click on Fasta > Copy link address > Paste here
GENOME_URL="https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_49/GRCh38.primary_assembly.genome.fa.gz"

wget -c "${TRANS_URL}" -O ../inputs/gencode.v49.pc_transcripts.fa.gz
wget -c "${GENOME_URL}" -O ../inputs/GRCh38.primary_assembly.genome.fa.gz

# Step 2. Create the decoy list
grep '^>' <(gunzip -c ../inputs/GRCh38.primary_assembly.genome.fa.gz) | cut -d ' ' -f 1 > ../inputs/decoys.txt
sed -i -e 's/>//g' ../inputs/decoys.txt

# Step 3. Combine transcriptome and genome FASTAs
cat ../inputs/gencode.v49.pc_transcripts.fa.gz ../inputs/GRCh38.primary_assembly.genome.fa.gz > ../inputs/transcripts_and_decoys.fa.gz

# Step 4. Build the Salmon index
salmon index \
  -t ../inputs/transcripts_and_decoys.fa.gz \
  -d ../inputs/decoys.txt \
  -p 30 \
  -i ../inputs/human_salmon_index \
  --gencode

echo "All files and outputs saved in the existing ./input directory"
```
> [!NOTE]
> This only needs to run **once** per reference build — if `inputs/human_salmon_index` already exists and matches your intended GENCODE release, skip straight to Step 4.

### 💡 Step 4 — Quantify with Salmon
`scripts/04_reads_quant.sh`:

```bash
#!/bin/bash

# Set the path to the Salmon index
salmon_index="../inputs/human_salmon_index"

# Set the path to the "fastq" folder
fastq_dir="../fastq"

# Loop through R1 files in the fastq folder
for r1_file in "${fastq_dir}"/SRR*_1.fastq.gz; do
    # Derive the R2 file and sample name
    samp=$(basename "${r1_file%_1.fastq.gz}")
    r2_file="${fastq_dir}/${samp}_2.fastq.gz"

    echo "Processing sample ${samp}"
    salmon quant -i "$salmon_index" -l A \
        -1 "$r1_file" \
        -2 "$r2_file" \
        -p 28 --validateMappings -o "../outputs/salmon_out/${samp}"
done
```
**Check the mapping rate** in `outputs/salmon_out/<sample>/logs/salmon_quant.log`:
- Healthy bulk RNA-seq library → typically **>80% mapping rate**
- Anything much lower is worth investigating (wrong reference build, contamination, wrong `-l` strandedness flag)

### 💡 Step 5 — Build the tx2gene Mapping Table (R, via EnsDb)
Instead of building `tx2gene` from a downloaded GTF, pull the transcript-to-gene-symbol mapping directly from the `EnsDb.Hsapiens.v86` Bioconductor annotation package:

```r
# Install Bioconductor packages
pak::pkg_install(c("tidyverse", "tximport", "DESeq2", "EnsDb.Hsapiens.v86"))

library(tidyverse)
library(tximport)
library(DESeq2)
library(EnsDb.Hsapiens.v86)

# Explore what's available in the annotation database
columns(EnsDb.Hsapiens.v86)
keys(EnsDb.Hsapiens.v86)

# Get TXID -> SYMBOL mapping for every entry in the database
tx2gene <- AnnotationDbi::select(
  EnsDb.Hsapiens.v86,
  keys = keys(EnsDb.Hsapiens.v86),
  columns = c('TXID', 'SYMBOL')
)
head(tx2gene)

# Drop the GENEID column — tximport only needs TXID -> SYMBOL for gene-level summarization
tx2gene <- dplyr::select(tx2gene, -GENEID)
head(tx2gene)
```
> [!NOTE]
> This approach maps transcripts to **gene symbols** (e.g., `TP53`) rather than Ensembl gene IDs, which is convenient for downstream biological interpretation and pathway analysis. It also avoids needing to download/manage a separate GTF file — the mapping lives inside the `EnsDb.Hsapiens.v86` package, so make sure its genome build (GRCh38) matches the one you used to build your Salmon index.

### 💡 Step 6 — Import with tximport → Counts Matrix (R)

```r
# Collect the sample quant files
samples <- list.dirs('outputs/salmon_out', recursive = FALSE, full.names = FALSE)
samples

# Build paths to each sample's quant.sf
quant_files <- file.path('outputs/salmon_out', samples, 'quant.sf')
names(quant_files) <- samples
print(quant_files)

# Sanity check: every file must exist (all should be TRUE)
file.exists(quant_files)

# Build the tximport object, summarized to gene level via tx2gene
txi <- tximport(
  files = quant_files,
  type = 'salmon',
  tx2gene = tx2gene,
  ignoreTxVersion = TRUE
)

class(txi)

# Raw counts (for DESeq2)
raw_counts <- txi$counts
write.csv(raw_counts, "outputs/counts_data/raw_counts/GSE245922_raw_counts.csv")

# TPM-normalized abundance (for exploratory/visualization use)
tpm_counts <- txi$abundance
write.csv(tpm_counts, "outputs/counts_data/tpm_counts/GSE245922_tpm_counts.csv")
```
> [!WARNING]
> If transcript IDs in your Salmon output carry version suffixes (`.1`, `.2`) that aren't in `tx2gene`, always set `ignoreTxVersion = TRUE` — otherwise every transcript silently fails to match and your counts matrix comes back empty or wrong.

> [!NOTE]
> Next step after this (not covered in today's checklist, but where this feeds into): build your `col_data` metadata data frame with sample-to-condition mapping from `SRA_Run_table`, confirm `all(colnames(txi) == rownames(col_data))` is `TRUE`, then pass `txi` into `DESeqDataSetFromTximport()`.

### 💡 Step 7 — Sanity Check the Output
- `dim(txi$counts)` — rows = genes (symbols), columns = number of samples (matches `SRA_Run_table`)
- `colnames(txi$counts)` matches your sample naming exactly
- `file.exists(quant_files)` returned all `TRUE` before import
- No column is entirely zero (would indicate a failed sample import)
- `raw_counts` (`GSE245922_raw_counts.csv`) saved and ready to feed into `DESeqDataSetFromTximport()`
---

## ✅ End-of-Day Checklist
- pixi environment set up, tools version-confirmed
- FASTQ files downloaded via SRR_Acc_list, cross-checked against SRA_Run_table
- FastQC + MultiQC run on raw reads, report reviewed
- Decoy-aware Salmon index built (or confirmed existing index is current)
- Salmon quant run for all samples, mapping rates logged
- tx2gene table built from EnsDb.Hsapiens.v86 (TXID → SYMBOL)
- tximport run successfully, raw + TPM counts generated and sanity-checked


