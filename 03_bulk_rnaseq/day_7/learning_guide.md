# 🧬 Day 7 — Bulk RNAseq Data Analysis: From Count Table to Differential Gene Expression Analysis

> **Week 4, Day 7** · Saturday, July 24, 2026  
> **Author:** Naznin Akter
---

## 🎯 Learning Checklist
- [1] Explain what gene expression is, and what "differential" expression means
- [2] Explain why a plain t-test fails on RNA-seq counts, and what the negative binomial model fixes
- [3] Compare DESeq2, edgeR, and limma-voom — when to use which
- [4] Understand study design formulas, normalization, dispersion, fold change, p-value, and FDR
- [5] Read and interpret all 12 essential DGE plots biologically, not just visually
---

## 📑 Part 1 — The Core Idea

### What "Gene Expression" Actually Means
Every cell in the body carries the same DNA — think of it as a cookbook with ~20,000 recipes (genes). A liver cell and a neuron own the identical book; they just **read different recipes**. Owning a recipe doesn't mean it's cooked — a gene sitting in DNA does nothing until the cell **reads** it (transcription) and turns it into mRNA, then protein.

```
DNA (master recipe) → mRNA (working copy) → Protein (finished dish)
```

The more a gene is read, the more mRNA is produced. **RNA-seq measures that mRNA** — it's a snapshot of which recipes are actively being cooked, not which recipes exist.

> [!NOTE]
> Two cells (or two people) can share almost identical DNA yet behave completely differently — e.g., healthy tissue vs. a tumor in the same organ. The DNA hasn't changed; **which genes are switched on has**.

### Differential Gene Expression (DGE) — The Central Idea
**DGE compares expression levels between two or more conditions to find which genes are expressed differently.** It's really one question, asked ~20,000 times: *did this gene's activity change?*

Because you can't inspect 20,000 genes by hand, DGE automates three questions at once:
- Which genes increased?
- Which genes decreased?
- Which of those changes are **real** (not random noise)?

### From a Results Table to Biology
| Gene | Healthy | Cancer | Verdict |
|---|---|---|---|
| MYC | 20 | 500 | ↑ Upregulated |
| VEGFA | 15 | 320 | ↑ Upregulated |
| CDH1 | 1000 | 250 | ↓ Downregulated |
| ACTB | 500 | 510 | No meaningful change |

A biologist looking at MYC↑, VEGFA↑, MKI67↑ concludes: *"the tumor is driving cell proliferation and growing new blood vessels."* Without DGE, that pattern stays buried in thousands of raw numbers — this table is the raw material for every plot that follows, starting with the volcano plot.

### The RNA-seq → DGE Pipeline
```
Group A (e.g. healthy) ─┐
                         ├─→ 1. RNA extraction & sequencing 
Group B (e.g. cancer)  ─┘        → 2. Count reads per gene 
                                       → 3. Compare expression between groups (DGE)
                                            → 4. Which genes changed
                                                 → 5. biological insight
```                                                
### What Questions Can DGE Answer?
- Which genes are activated in cancer?
- Which genes respond to a drug?
- Which genes distinguish healthy from diseased tissue?
- Which genes change after infection?
- Which genes are active in one cell type but not another?

All five reduce to the same core question: *what changed, and is it real?*

---

## 📑 Part 2 — The Statistics

### Why a Plain T-Test Fails
RNA-seq data are **counts**, not continuous measurements — and a t-test assumes roughly normal data with constant variance.

| T-test expects | RNA-seq counts actually are |
|---|---|
| Continuous values | Non-negative integers (0, 1, 2…) |
| Normal distribution | Right-skewed, many zeros |
| Constant variance | Variance grows with the mean |

### The Special Nature of Count Data
- Non-negative integers only
- Right-skewed distributions
- Variance increases with the mean
- Many genes have zero counts
- **Overdispersion**: variance > mean — this is the crux of the whole statistical problem

### Why Poisson Isn't Enough Either
A Poisson distribution assumes **mean = variance** (e.g., mean 100 → variance 100). Real RNA-seq data show variance far exceeding the mean (e.g., mean 100 → variance ≈ 800). Poisson underestimates this extra spread — using it would call far too many genes "significant" by chance.

### The Fix: Negative Binomial Distribution
The **negative binomial (NB)** distribution adds a dispersion parameter on top of Poisson, explicitly modeling variance = mean + extra variation. That extra term captures natural biological variability between replicates — this is why nearly every modern RNA-seq DGE tool is built on NB, not Poisson or a normal-distribution t-test.

### Five Quantities Computed Per Gene
For each of ~20,000–60,000 genes, every DGE tool computes:
1. **Average expression** — mean level in each group
2. **Variability** — spread across replicates
3. **Fold change** — size of the difference
4. **p-value** — compatibility with "no change"
5. **Adjusted p-value (FDR)** — corrected for testing thousands of genes at once

### The Toolkit: Three Packages

| Feature | DESeq2 | edgeR | limma-voom |
|---|---|---|---|
| Model | Negative Binomial | Negative Binomial | Linear + variance weights |
| Input | Raw counts | Raw counts | Raw counts |
| Normalization | Median-of-ratios | TMM | TMM + voom |
| Small samples | Excellent | Excellent | Good |
| Large samples | Excellent | Excellent | Excellent |
| Beginner-friendly | ★★★★★ | ★★★★ | ★★★ |
| Best for | Standard bulk RNA-seq (beginner default) | Small samples, flexible designs, fast | Large cohorts, complex designs |

They differ in **how** they estimate variability, not in the biological question they answer.

**DESeq2 workflow:** 
```
Raw counts 
→ normalize (size factors) 
  → estimate dispersion
    → fit NB GLM 
      → Wald/LRT test 
        → adjusted p-values
```
**edgeR workflow:** 
```
Counts 
→ TMM normalization 
  → estimate dispersion 
    → fit GLM 
      → likelihood ratio test
```
**limma-voom workflow:** 
```
Counts 
→ convert to log₂-CPM 
  → estimate mean-variance (voom) 
    → fit weighted linear models 
      → empirical Bayes
```
> [!NOTE]
> **Decision guide:** 
> Learning RNA-seq for the first time or a typical study (3–20 reps/group) 
> **DESeq2**. Very small sample sizes 
> **edgeR**. Large cohorts (dozens–hundreds of samples) or complex factorial designs 
> **limma-voom** (or edgeR)

### Study Design Formulas
Written in R as `~ condition` — a tilde, then the factors that matter.

| Design | Formula | Question |
|---|---|---|
| Two groups | `~ condition` | Does expression differ between healthy and cancer? |
| Drug study | `~ treatment` | Which genes respond to the drug? |
| Batch-aware | `~ batch + condition` | Condition effect *after removing* the batch effect |
| Control for a factor | `~ sex + disease` | Disease effect while controlling for sex |
| Interaction | `~ sex + disease + sex:disease` | Does the disease effect *differ* between sexes? |

> [!WARNING]
> If samples were sequenced in batches that weren't randomized against your biological groups (e.g., all Day-1 samples are "control", all Day-2 are "treated"), technical differences can masquerade as biology. Include the batch as a covariate — but only if it isn't perfectly confounded with the condition of interest.

### Five Key Concepts

**1. Normalization** — Samples are sequenced to different depths (e.g., 20M vs 40M reads). Normalization rescales samples so counts are comparable *before* any gene is tested.

**2. Dispersion** — Measures biological variability among replicates. Low dispersion (replicates agree) → high confidence; high dispersion (replicates scatter) → less confidence in the result.

**3. Fold change** — Healthy 100 → Cancer 400 is a 4× increase, or **log2FC = 2**. Magnitude alone doesn't tell you if the effect is statistically reliable — that's what the p-value is for.

**4. p-value** — Asks: *if there were truly no difference, how often would we see a gap this big by chance?* p = 0.001 is very unlikely to be chance; p = 0.60 is easily explained by noise.

**5. Multiple testing & FDR** — Testing 20,000 genes at p < 0.05 yields ~1,000 "significant" genes by pure chance alone. **Benjamini-Hochberg FDR correction** adjusts p-values to control the expected proportion of false positives among genes called significant. **Always report the adjusted p-value (`padj`), never the raw p-value.**

---

## 📑 Part 3 — Reading the Plots

The analysis is a story, and the plots are told in order:
```
1. Quality check 
      ↓
2. Normalize 
      ↓    
3. Test (DGE) 
      ↓
4. Interpret 
      ↓
5. Discover 

(Plots 1–3 guard quality)   (Plots 4–6 reveal results)   (Plots 7–12 uncover biology)
```

> [!NOTE]
> Each stage gates the next — never interpret biology before the quality plots (1–3) look right. A beautiful volcano plot built on a contaminated or mislabeled sample is not trustworthy.

### Quality Plots

**Plot 1 — Sample Correlation Heatmap**
- *Answers:* Are my biological replicates consistent?
- *Read it:* Dark blocks = high correlation. Clean blocks along the diagonal mean each group clusters with itself.
- *Biological meaning:* A sample landing in the wrong block flags contamination, mislabeling, or a batch effect.

**Plot 2 — PCA Plot**
- *Answers:* Do my conditions differ globally?
- *Read it:* Each dot is a sample. Groups sitting in separate clouds are transcriptionally distinct.
- *Biological meaning:* Clear separation → disease/condition is a major source of variation. Overlap → weak effect or high individual variability.

**Plot 3 — Boxplot (Normalization Check)**
- *Answers:* Are my samples comparable after normalization?
- *Read it:* Each box is one sample's expression spread. After normalizing, medians and boxes should line up.
- *Biological meaning:* Aligned boxes mean later differences reflect biology, not sequencing depth.


### Results Plots

**Plot 4 — MA Plot**
- *Answers:* Which genes change, relative to their overall expression?
- *Read it:* Above zero = up, below = down, on the line = no change. Most genes cluster at zero.
- *Biological meaning:* A few deviating points → specific pathways affected. A whole-cloud shift → a technical artifact worth investigating.

**Plot 5 — Volcano Plot ★ (the signature figure)**
- *Answers:* Which genes changed the most **and** with strong statistical support?
- *Read it:* x = log2 fold change, y = -log10(padj). Top-right = strongly up, top-left = strongly down, middle = unchanged.
- *Biological meaning:* The corner genes are your candidate biomarkers, disease drivers, and drug targets.

**Plot 6 — Heatmap of DE Genes ★**
- *Answers:* Do the DE genes cleanly separate the groups?
- *Read it:* Rows = genes, columns = samples, color = expression. Groups should form mirror-image blocks.
- *Biological meaning:* Blocks of co-expressed genes reveal shared pathways, and can expose disease subtypes.

### Enrichment / Biology Plots

**Plot 7 — GO Enrichment Plot**
- *Answers:* Which biological processes are affected?
- *Read it:* Longer bars = processes more over-represented among your DE genes.
- *Biological meaning:* Turns "500 genes changed" into "the tumor is driving cell division and blood-vessel growth."

**Plot 8 — KEGG Pathway Plot**
- *Answers:* Which signaling pathways are altered?
- *Read it:* Each bar is a curated pathway; length reflects enrichment strength.
- *Biological meaning:* Cell-cycle enrichment → proliferation; NF-κB → inflammation; apoptosis → altered cell death.

**Plot 9 — Protein-Protein Interaction Network**
- *Answers:* How do the altered genes interact?
- *Read it:* Nodes = proteins, edges = interactions. A big, highly-connected node is a **hub gene**.
- *Biological meaning:* Hubs often regulate many downstream genes — prime biomarker and drug-target candidates.

**Plot 10 — GSEA Enrichment Plot**
- *Answers:* Is a whole pathway coordinately up- or down-regulated, even without any single gene passing a strict cutoff?
- *Read it:* The curve peaks early if a gene set concentrates near the top of the ranked gene list.
- *Biological meaning:* Detects coordinated pathway-level shifts that ORA (Plot 7/8-style) can miss.

**Plot 11 — Enrichment Map (Pathway Network)**
- *Answers:* How are the enriched pathways related to each other?
- *Read it:* Each node is a pathway; edges link pathways sharing genes. Clusters = related biology.
- *Biological meaning:* Reveals systems-level programs driving the phenotype, not just isolated terms.

**Plot 12 — Dot / Bubble Plot**
- *Answers:* Which enriched functions are strongest, at a glance?
- *Read it:* Each dot is a term. Size = gene count, color = significance, x-position = gene ratio.
- *Biological meaning:* Big, dark dots are the biological themes worth interpreting first.


### The Complete Interpretation Workflow
```
QUALITY (Correlation, PCA, Boxplot)
   ↓ Do samples separate as expected?
RESULTS (MA, Volcano, Heatmap)
   ↓ Which genes changed?
BIOLOGY (GO, KEGG, GSEA, PPI, Enrichment map, Dot plot)
   ↓ Which processes and regulators are driving it?
Biological conclusions
```

### The Key Principle — Ask Four Questions of Every Figure
1. What biological question does this plot answer?
2. What evidence in the plot supports the conclusion?
3. What process or pathway is changing?
4. How does this help explain the phenotype?

> [!NOTE]
> A figure that answers no question is just decoration — always tie a plot back to one of these four questions before including it in a report or presentation.

---

## 🔍 Bulk RNA-Seq project Exploration
- [salmon-rnaseq](https://github.com/nazninshuktara/Bioinformatics-Mentorship-Program/tree/main/03_bulk_rnaseq/day_6/salmon-rnaseq)
---

## ✅ Recap — Five Things to Remember
1. Expression is **activity**, not sequence — same DNA, different genes switched on.
2. DGE asks one question: **which genes changed activity between conditions?**
3. Counts need the **negative binomial** — a t-test, and even Poisson, underestimate variability.
4. Start with **DESeq2**; reach for edgeR (small n) or limma-voom (large n) as needed.
5. Read every plot **biologically** — connect it back to a question, not just a shape.

---

## 📖 Glossary
| Term | Meaning |
|---|---|
| Gene expression | How much a gene is being read into mRNA |
| Count | Number of reads mapped to a gene in a sample |
| Fold change (log2FC) | Magnitude of change between conditions |
| Normalization | Rescaling for sequencing-depth differences |
| Dispersion | Biological variability among replicates |
| p-value | Chance of seeing this gap if nothing changed |
| FDR / padj | p-value corrected for testing many genes |
| DEG | Differentially expressed gene — passed both fold-change and FDR thresholds |

---

