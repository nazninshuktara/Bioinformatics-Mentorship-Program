# 🧬 Day 10 — Bulk RNAseq Data Analysis: Bulk RNA-Seq Meta-Analysis using Public GEO Datasets (Project)

> **Week 5, Day 10** · Friday, August 1, 2026  
> **Notes by:** Naznin Akter<br>
> **Course material & scripts:** Md. Jubayer Hossain (DeepBio Academy)
---

## 🎯 Learning Checklist
- [1] Explain why meta-analysis strengthens conclusions beyond a single RNA-seq study
- [2] Plan a meta-analysis project through four structured phases: research plan → database search → eligibility → screening
- [3] Know which public repositories to search for RNA-seq data and why
- [4] Set inclusion/exclusion criteria for combining independent studies
- [5] Structure a reproducible meta-analysis project as a GitHub repository
- [6] Recall the complete bulk RNA-seq pipeline, Day 5 through Day 10, as one connected study plan

---

## 📑 Part 1 — Why Meta-Analysis?

A single RNA-seq study, however well-designed, is still one snapshot — one cohort, one lab, one set of technical conditions. **Meta-analysis** combines multiple independent studies addressing the same biological question, and delivers benefits no single study can:

| Benefit | Why it matters |
|---|---|
| **Increased statistical power** | Pooling samples across studies gives more replicates than any one study alone, making subtle real effects detectable |
| **Reliable biomarker identification** | A gene that's differentially expressed in *one* study could be a batch artifact; a gene consistent *across independent studies, different labs, different cohorts* is a far stronger candidate |
| **Detect genes with small but consistent effects** | A gene with a modest but real effect size might not reach significance in any single small study, but becomes clearly significant when evidence is combined |
| **Comprehensive biological insights** | Aggregating across studies (different populations, disease stages, treatment contexts) reveals patterns that generalize, rather than one cohort's idiosyncrasies |

> [!NOTE]
> This is the same logic behind why a systematic review carries more weight than any single clinical trial — reproducibility *across* independent data sources is the strongest form of evidence in bioinformatics, just as in clinical research.

---

## 📑 Part 2 — The Four-Phase Meta-Analysis Workflow

```
Phase 1: Research Plan 
  → Phase 2: Database Search 
      → Phase 3: Eligibility 
          → Phase 4: Data Screening
```

### Phase 1 — Research Plan
Before touching any data, define exactly what question the meta-analysis will answer. Common framings:
- **Disease vs. Healthy** — the most basic comparison
- **Responders vs. Non-responders** — for treatment/drug studies
- **Early vs. Late Stage** — disease progression comparisons
- **Drug treated vs. Untreated** — pharmacological response
- A concrete, answerable question, e.g.: *"What genes are consistently up/downregulated in `<disease>` across independent RNA-seq studies?"*

> [!WARNING]
> Write the exact research question **before** searching for data. Searching first and then deciding what question the data can answer is how meta-analyses end up cherry-picking datasets that fit a conclusion, rather than testing a hypothesis fairly.

### Phase 2 — Database Search
Search public repositories for RNA-seq datasets matching the research question:

| Database | What it offers |
|---|---|
| **GEO** (Gene Expression Omnibus) | The largest general-purpose repository — raw and processed expression data across virtually all conditions |
| **ArrayExpress** | EBI's equivalent to GEO, strong European/international coverage |
| **GREIN** | A GEO RNA-seq-specific interface with pre-processed, ready-to-use count matrices — saves reprocessing raw FASTQ |
| **recount3** | Uniformly reprocessed RNA-seq data across tens of thousands of samples — useful when you want cross-study comparability without re-running your own pipeline |
| **TCGA** (The Cancer Genome Atlas) | Cancer-specific, large cohort, often paired with clinical metadata |
| **GTEx** (Genotype-Tissue Expression) | Normal tissue expression baseline — useful as a healthy-reference comparator |

**Search strategy:** search each database with your disease/condition term (e.g., "COVID-19", "colorectal cancer"), and keep a running list of candidate study accessions (GSE numbers, etc.) before filtering.

### Phase 3 — Eligibility Criteria
Not every dataset found in Phase 2 belongs in the meta-analysis. Set explicit inclusion criteria up front:

- **Species** — Human? Mouse? (Mixing species without a clear rationale invalidates direct comparison; if both are relevant, analyze and report separately)
- **Sample size determination** — a practical minimum (e.g., **> 5 samples** per condition) below which a study's estimates are too noisy to meaningfully contribute
- **Control vs. Disease structure** — the study must actually have the comparison groups your research question needs (a disease-only cohort with no control group can't answer a disease-vs-healthy question)

> [!NOTE]
> Defining these thresholds **before** looking at how many studies pass or fail them prevents the same cherry-picking problem as in Phase 1 — the criteria should be principled, not adjusted after the fact to hit a target number of studies.

### Phase 4 — Data Screening
Once eligible studies are identified, apply systematic screening steps, mirroring a PRISMA-style filtering flow:
1. **Data Screening** — review each candidate dataset's metadata and description in detail
2. **Remove duplicates** — the same underlying data can appear under multiple accessions (e.g., a sub-series and its parent series, or reanalyzed/resubmitted data)
3. **Filter with "Organism"** — apply the species criterion from Phase 3 programmatically
4. **Filter with "Sample Size"** — apply the minimum sample-size criterion from Phase 3 programmatically

> [!NOTE]
> Keep a record of exactly how many studies were found, excluded, and why at each filtering step — this "flow diagram" (found → screened → eligible → included) is standard practice for any systematic review or meta-analysis and should appear in your final report/methods section.

---

## 📑 Part 3 — Structuring the Project as a Reproducible Repository

A meta-analysis touches many datasets and produces many intermediate files — without a clear structure, it becomes unmanageable quickly.

```
bulk-rnaseq-meta-analysis/
├── data/                              # raw/downloaded datasets per study
├── outputs/                           # output tables, figures, final gene lists
├── scripts/                           # per-study processing + meta-analysis scripts
├── .gitignore                         # exclude large raw data files from version control
├── LICENSE                            # e.g., MIT license for open reuse
├── README.md                          # project description, research question, methods summary
└── bulk-rnaseq-meta-analysis.Rproj    # RStudio project file — keeps working directory consistent
```

> [!NOTE]
> `.gitignore` matters here specifically because meta-analysis `data/` folders can become very large (many datasets × many samples) — raw FASTQ or large count matrices should typically **not** be committed to Git directly; keep only scripts, small processed tables, and results under version control, and document in the README how to regenerate the large files.

---

## 📑 Part 4 — Overall Bulk RNA-Seq Study Plan (Full Pipeline Recap)

This is the complete path from raw sequencing reads to a defensible, cross-validated biological conclusion — everything covered across this course:

```
Day 6: FASTQ → Counts Matrix
   ↓  Download (SRA) → QC (FastQC/MultiQC) → Salmon index/quant → tximport → gene-level counts
Day 7: Count Table → DGE Analysis (theory + practical start)
   ↓  Negative binomial model, DESeq2/edgeR/limma-voom theory → normalize → PCA → DESeq() test
Day 8: DGE Analysis → Pathways
   ↓  Significant gene extraction → volcano/heatmap visualization → GSEA (KEGG) → GO ORA
Day 9: Batch Effects & Complex Designs
   ↓  Detect batch via PCA → model batch in design formula → know when correction tools apply
Day 10: Meta-Analysis (this guide)
   ↓  Combine multiple independent studies → cross-validate findings → robust, generalizable conclusions
```

**The single thread running through all ten days:** every stage exists to answer one question with increasing confidence — *is this biological signal real, or is it noise?* Quality control rules out technical artifacts, the negative binomial model and FDR correction rule out statistical noise, batch modeling rules out confounding, and meta-analysis rules out the idiosyncrasy of any single cohort. A finding that survives all five layers is about as trustworthy as bulk RNA-seq analysis can make it.

> [!NOTE]
> For a PhD application or portfolio, this progression *is* the story to tell: not "I ran DESeq2," but "I built a pipeline that systematically rules out artifacts, noise, confounding, and cohort-specific bias before calling a result real."

---

## ✅ Recap — Five Things to Remember
1. Meta-analysis exists because reproducibility **across independent studies** is stronger evidence than statistical significance within just one.
2. Define the research question and eligibility criteria **before** searching for or filtering data — never adjust criteria to fit a preferred outcome.
3. GEO, ArrayExpress, GREIN, recount3, TCGA, and GTEx each serve different needs — pick based on whether you need raw data, pre-processed counts, cancer-specific cohorts, or normal-tissue baselines.
4. Track exactly how many studies were found, excluded, and included at each screening step — this transparency is what makes a meta-analysis credible.
5. A reproducible project repository (data/results/scripts separation, `.gitignore` for large files, README with the methods) is what turns a personal analysis into a shareable, citable piece of work.

---

## 📖 Glossary
| Term | Meaning |
|---|---|
| Meta-analysis | Statistical combination of results from multiple independent studies addressing the same question |
| GEO / ArrayExpress | General-purpose public gene expression data repositories |
| GREIN / recount3 | Pre-processed, uniformly reprocessed RNA-seq repositories, saving reprocessing effort |
| TCGA / GTEx | Cancer-specific and normal-tissue-baseline expression repositories, respectively |
| Eligibility criteria | Pre-defined rules (species, sample size, study design) for including/excluding a candidate dataset |
| Screening | Systematic, step-by-step filtering of candidate studies down to the final included set |

## 🔍 Bulk RNA-Seq Meta Analysis Study Workflow
- [Bulk RNA-Seq Meta Analysis](https://github.com/nazninshuktara/Bioinformatics-Mentorship-Program/tree/main/03_bulk_rnaseq/day_9/PDAC)


