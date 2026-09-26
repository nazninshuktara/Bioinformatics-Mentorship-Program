# Module 4: Co-expression Network Analysis with WGCNA

## What

WGCNA (Weighted Gene Co-expression Network Analysis) identifies **modules of co-expressed genes** and links them to external traits (e.g., tumor vs. normal). Unlike differential expression analysis (which tests genes one at a time) and enrichment analysis (which tests pre-defined gene sets), WGCNA discovers gene groups **de novo** from the data's correlation structure.

Within each module, WGCNA identifies **hub genes** — the most highly connected genes that may be key regulators of the module's biological program.

**Scripts:**
- `scripts/06_wgcna_network_construction.R` — Network building and module detection
- `scripts/07_wgcna_module_trait_hub_genes.R` — Module-trait correlation and hub genes

---

## Why

### Why look at co-expression instead of individual genes?

DE analysis (Module 2) asks: "Which genes differ between tumor and normal?" — one gene at a time. WGCNA asks a different question: "Which genes behave together across samples, and which groups relate to the condition?"

This network-level view captures biological programs that single-gene analysis may miss:

- **Coordinated moderate changes:** A pathway where each gene changes by log2FC = 0.5 (not significant in DE) but all 50 genes shift together would be missed by DE but detected by WGCNA as a co-expression module.
- **Regulatory relationships:** Hub genes (highly connected within a module) may be key regulators driving the module's behavior — candidates for experimental validation.
- **Dimensionality reduction:** Instead of analyzing 5,000 genes, WGCNA summarizes them into ~15 modules, each represented by a single eigengene.

### Why weighted (not unweighted) networks?

An **unweighted network** uses a hard threshold: two genes are either connected (correlation > 0.8) or not (correlation < 0.8). This loses information — a correlation of 0.79 and 0.21 are treated identically (both "not connected").

A **weighted network** uses a soft threshold: the connection strength is a continuous value (correlation raised to a power). This preserves the full information about connection strength and produces more robust module detection.

### Why scale-free topology?

Biological networks tend to follow a **scale-free degree distribution**: most genes have few connections, while a few "hub" genes have many connections. This is different from random networks, where most nodes have similar connectivity.

WGCNA chooses the soft power to make the network approximate scale-free topology (R^2 >= 0.8). This ensures the network has the hub-and-spoke structure characteristic of real biological networks, where hub genes play disproportionate regulatory roles.

### Why VST-transformed data (not raw counts)?

WGCNA computes Pearson correlations between genes across samples. Pearson correlation assumes homoscedastic data (equal variance). Raw RNA-seq counts have variance that increases with mean expression — highly expressed genes would dominate the correlation structure simply because they have more variance.

VST (variance stabilizing transformation, from Module 2) removes this mean-variance dependence, ensuring that correlations reflect true biological co-expression rather than technical artifacts of count data.

### Batch effect caveat

As diagnosed in Module 1b (Script 02), GSE130688 has two batches: Batch 1 (28 samples, patients P01-P14) and Batch 2 (2 samples, patient P15). Batch is confounded with patient, so no computational correction was applied. For WGCNA, this means P15's two samples participate in the network without batch adjustment. Since WGCNA uses all samples simultaneously in correlation-based network construction, P15's batch-specific expression patterns could subtly influence module assignments and eigengene values. With only 2 of 30 samples affected, the impact on module discovery is expected to be minimal, but individual-level conclusions about P15 should be interpreted cautiously. The DE comparison (Module 2) is protected by the paired design; the network analysis is not.

### Why a signed network?

In a **signed network**, the connection strength is based on positive correlations only: genes that are positively correlated are connected, genes that are anti-correlated are NOT in the same module. In an **unsigned network**, both positive and negative correlations count as connections.

We use a signed network because we care about **direction of change**: genes that go up together in tumor should be in one module, genes that go down together should be in another. An unsigned network would merge these into a single module, losing the directional information.

---

## Steps

### Script 07: Network Construction

#### Step 1: Load VST data and select top variable genes
- Input: VST-transformed counts from Module 2 (23,235 genes × 30 samples)
- Select top 5,000 most variable genes (standard WGCNA recommendation)
- **Why:** Low-variance genes contribute little to co-expression patterns; 5,000 focuses on genes that actually vary across samples

#### Step 2: Sample quality check
- `goodSamplesGenes()` identifies outlier samples and genes with missing values
- All 30 samples and 5,000 genes passed

#### Step 3: Soft power selection
- `pickSoftThreshold()` tests powers 1-20 and reports scale-free R^2 for each
- Selected power: 18 (R^2 = 0.871)
- **Why:** The lowest power achieving R^2 >= 0.8 balances scale-free fit with network connectivity

#### Step 4: Network construction (blockwiseModules)
- Compute correlation matrix → raise to soft power → adjacency matrix
- Compute Topological Overlap Matrix (TOM) — refines similarity by accounting for shared neighbors
- Hierarchical clustering on TOM dissimilarity
- Dynamic tree cutting → initial modules
- Merge modules with similar eigengenes (mergeCutHeight = 0.25)
- Result: 14 modules + grey (unassigned)

#### Step 5: Generate diagnostic plots
- **Soft power plot:** R^2 and mean connectivity vs. power
- **Dendrogram:** Gene clustering tree with module colors

### Script 08: Module-Trait Correlation & Hub Genes

#### Step 1: Define trait
- Condition coded as tumor=1, normal=0 (binary numeric trait)

#### Step 2: Calculate module eigengenes
- Eigengene = first principal component of each module
- Summarizes the module's expression profile in one number per sample

#### Step 3: Module-trait correlation
- Pearson correlation between each eigengene and the trait
- Identify significant modules (|r| > 0.5, padj < 0.05)
- Result: 6 significant modules

#### Step 4: Module-trait heatmap
- Visualize all module-trait correlations with p-values

#### Step 5: Intramodular connectivity and module membership
- **kWithin:** Sum of adjacencies to other genes in the same module (how well-connected a gene is within its module)
- **MM (Module Membership):** Correlation between a gene's expression and the module eigengene (how strongly a gene belongs to its module)
- **Hub score:** kWithin × |MM| — combined metric for identifying hub genes

#### Step 6: Identify hub genes
- Top 10 hub genes per significant module (by hub score)
- Hub genes are candidate key regulators for experimental validation

#### Step 7: Eigengene heatmap
- Module eigengenes across samples with condition annotation

#### Step 8: Cross-reference with DE results
- Count DE genes per module
- Modules enriched for DE genes + correlated with condition = most robust findings

---

## Key Parameters

| Parameter | Value | Rationale |
|-----------|-------|-----------|
| Number of genes | Top 5,000 most variable | Standard WGCNA recommendation; focuses on informative genes |
| Soft power | 18 | Lowest power achieving scale-free R^2 >= 0.8 |
| Network type | Signed | Preserves direction of correlation; anti-correlated genes in different modules |
| minModuleSize | 30 | Avoids tiny, unstable modules |
| mergeCutHeight | 0.25 | Merges modules with eigengene dissimilarity < 0.25 (correlation > 0.75) |
| Module-trait significance | \|r\| > 0.5, padj < 0.05 | Standard thresholds for meaningful association |
| Hub gene selection | Top 10 by kWithin × \|MM\| | Combined connectivity + membership metric |

---

## Biological Context

In PDAC, co-expression modules represent biological programs operating in the tumor and normal tissue:

- **Modules positively correlated with tumor** = programs activated in PDAC (e.g., immune infiltration, stromal activation, proliferation)
- **Modules negatively correlated with tumor** = programs suppressed in PDAC (e.g., acinar cell identity, digestive function)
- **Hub genes** in tumor-correlated modules = candidate drivers of PDAC biology (potential therapeutic targets or biomarkers)
- **Hub genes** in normal-correlated modules = candidate regulators of normal pancreatic function (lost in tumor)

The cross-reference with DE results (Module 2) validates that modules correlated with tumor status are also enriched for DE genes — confirming that the network-level and gene-level analyses tell a consistent story.

---

## Code Walkthrough

### Soft power selection

```r
sft <- pickSoftThreshold(datExpr, powerVector = 1:20, networkType = "signed")
# Select lowest power with R^2 >= 0.8
power_selected <- sft$powerEstimate
```

### Network construction

```r
net <- blockwiseModules(
  datExpr,
  power          = 18,
  networkType    = "signed",
  TOMType        = "signed",
  minModuleSize  = 30,
  mergeCutHeight = 0.25
)
```

### Module-trait correlation

```r
MEs <- moduleEigengenes(datExpr, moduleColors)
moduleTraitCor <- cor(MEs$eigengenes, trait, use = "p")
moduleTraitPvalue <- corPvalueStudent(moduleTraitCor, nrow(datExpr))
```

### Hub gene identification

```r
adjacency <- adjacency(datExpr, power = 18, type = "signed")
kWithin <- intramodularConnectivity(adjacency, moduleColors)
geneModuleMembership <- cor(datExpr, MEs$eigengenes)
hub_score <- kWithin$kWithin * abs(geneModuleMembership[, me_col])
```

---

## Expected Outputs

### Tables

| File | Description |
|------|-------------|
| `tables/wgcna_gene_modules.csv` | Gene-module assignments for all 5,000 genes |
| `tables/wgcna_module_trait_cor.csv` | Module-trait correlations with p-values |
| `tables/wgcna_eigengenes.csv` | Module eigengene values per sample |
| `tables/wgcna_hub_genes.csv` | Top 10 hub genes per significant module |
| `tables/wgcna_module_de_overlap.csv` | DE gene overlap per module |

### Figures

| File | Description |
|------|-------------|
| `figures/wgcna_soft_power.png` | Scale-free R^2 and mean connectivity vs. power |
| `figures/wgcna_dendrogram.png` | Gene clustering dendrogram with module colors |
| `figures/wgcna_module_trait_heatmap.png` | Module-trait correlation heatmap |
| `figures/wgcna_eigengene_heatmap.png` | Module eigengenes across samples |
| `figures/wgcna_hub_genes_barplot.png` | Top hub genes for the most significant module |

---

## Key Concepts Glossary

| Term | Definition |
|------|------------|
| **Adjacency matrix** | Gene-gene connection strengths (correlation^power) |
| **TOM (Topological Overlap Matrix)** | Refined similarity accounting for shared neighbors |
| **Module** | A group of co-expressed genes with high topological overlap |
| **Module eigengene (ME)** | First principal component of a module; summarizes its expression profile |
| **kWithin** | Intramodular connectivity; how well a gene connects within its module |
| **Module membership (MM)** | Correlation between a gene and its module eigengene |
| **Hub gene** | Gene with high kWithin and high \|MM\|; central to the module |
| **Grey module** | Genes not assigned to any module (the "trash" module) |
| **Soft power** | Exponent that transforms correlations into connection strengths |
| **Scale-free topology** | Network where most nodes have few connections but few have many (hubs) |
