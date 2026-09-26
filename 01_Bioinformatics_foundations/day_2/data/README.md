# Day 2 — Data files

Tiny practice datasets for the Basic Unix + NGS Formats lab. Plain text unless noted.

| File | What it is | Used in |
|------|------------|---------|
| `months` | 12 month names, one per line | Steps 3, 6; Ex 1, 3 |
| `orchard` | A few lines of prose (text-viewing practice) | Step 3 |
| `apple.genes` | Tab-separated gene table, 5456 genes (ID, name, chrom, strand, start, end, exons) | Steps 4, 7, 8; Ex 5, 9 |
| `peach.genes`, `pear.genes` | Same gene-table format, smaller | Steps 2, 10; Ex 4, 7 |
| `apple.samples`, `peach.samples`, `pear.samples` | Sample/tissue name lists | Steps 2, 9; Ex 2, 6 |
| `apple.conditionA/B/C` | Per-condition expression-style tables | Step 2 (globbing); later days |
| `apple.genome`, `peach.genome`, `pear.genome` | FASTA reference genomes (`apple.genome` is ~111 MB) | Ex 2; Day 3 |
| `den2.fasta`, `den3.fasta` | Dengue virus sequences in FASTA | Steps 7, 11 |
| `headers.txt` | A single FASTA header line | reference |
| `demo.fastq` | 1,250,000 sequencing reads (5,000,000 lines, ~412 MB) | Step 11; Ex 8 |
| `sample1_R1.fastq.gz` | Small gzip-compressed FASTQ (`zcat` demo) | Step 11 |
| `sample1_R2.fastq`, `sample3_R1.fastq`, `sample3_R2.fastq` | Placeholder paired-end read files | later days |

**Column layout for `*.genes`:** `1` gene ID · `2` name · `3` chromosome/scaffold · `4` strand (`+`/`-`) · `5` start · `6` end · `7` exon coordinates.

> Large files (`apple.genome`, `demo.fastq`) are for streaming with `head`/`less`/`wc` — do **not** `cat` them.

## ⚠️ Files not in git

`apple.genome` (~111 MB) and `demo.fastq` (~412 MB) exceed GitHub's **100 MB** per-file limit, so they are **git-ignored** and not in this repo. Get them from the course data bundle and drop them into `day2/data/` before running Steps 5, 10 and Exercises 8, 10. Everything else in this folder is committed and ready to use.
