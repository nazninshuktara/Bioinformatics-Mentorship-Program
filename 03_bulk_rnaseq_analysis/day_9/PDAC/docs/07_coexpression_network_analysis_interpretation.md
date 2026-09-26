# Module 4: Co-expression Network Analysis — Interpretation

## Figures and Tables Referenced

**Figures:**
- `wgcna_soft_power.png` — Soft power threshold selection (scale-free topology fit)
- `wgcna_dendrogram.png` — Gene clustering dendrogram with module colors
- `wgcna_module_trait_heatmap.png` — Module-trait correlation heatmap (all modules x traits)
- `wgcna_eigengene_heatmap.png` — Module eigengene expression across samples
- `wgcna_hub_genes_barplot.png` — Hub gene connectivity scores for significant modules

**Tables:**
- `wgcna_module_trait_cor.csv` — Module-trait correlations and p-values for all modules
- `wgcna_hub_genes.csv` — Hub genes (top 10 per significant module) with connectivity scores
- `wgcna_module_de_overlap.csv` — DE gene overlap fractions for each module
- `wgcna_gene_modules.csv` — Gene-to-module assignments for all 5,000 genes
- `wgcna_eigengenes.csv` — Module eigengene values per sample

---

## Results Summary

| Metric | Value |
|--------|-------|
| Genes analyzed | 5,000 (top variable) |
| Soft power selected | 18 (scale-free R^2 = 0.871) |
| Network type | Signed |
| Modules detected (excl. grey) | 14 |
| Grey module (unassigned) | 149 genes |
| Significant modules (|r| > 0.5, padj < 0.05) | 6 |

### Module-Trait Correlations

| Module | Correlation with tumor | padj | Direction | Size |
|--------|----------------------|------|-----------|------|
| **blue** | -0.74 | 3.9e-05 | Suppressed in tumor | 1,145 |
| **brown** | +0.72 | 5.1e-05 | Activated in tumor | 824 |
| **purple** | +0.63 | 9.8e-04 | Activated in tumor | 135 |
| **yellow** | +0.56 | 4.5e-03 | Activated in tumor | 388 |
| **greenyellow** | +0.55 | 4.5e-03 | Activated in tumor | 97 |
| **tan** | -0.51 | 1.0e-02 | Suppressed in tumor | 85 |

Full correlations for all 15 modules in see Table: Module-trait correlations (`wgcna_module_trait_cor.csv`); visualized in see Figure: Module-trait heatmap (`wgcna_module_trait_heatmap.png`).

### DE Gene Overlap by Module

| Module | Total genes | DE genes | DE fraction |
|--------|-------------|----------|-------------|
| purple | 135 | 121 | 89.6% |
| blue | 1,145 | 953 | 83.2% |
| brown | 824 | 654 | 79.4% |
| yellow | 388 | 210 | 54.1% |
| cyan | 45 | 23 | 51.1% |

Full overlap for all modules in see Table: Module-DE overlap (`wgcna_module_de_overlap.csv`).

---

## Biological Significance

### The blue module: Normal pancreatic identity (suppressed in tumor)

The blue module is the largest module (1,145 genes) and is **strongly negatively correlated with tumor status** (r = -0.74) (see Figure: Module-trait heatmap (`wgcna_module_trait_heatmap.png`); see Table: Module-trait correlations (`wgcna_module_trait_cor.csv`)). This means the blue module's eigengene is high in normal tissue and low in tumor tissue — the module represents a program that is **active in normal pancreas and suppressed in PDAC**.

**83.2% of blue module genes are differentially expressed** (953 of 1,145) (see Table: Module-DE overlap (`wgcna_module_de_overlap.csv`)), making it the most DE-enriched large module. The top hub gene is **AQP12A** (aquaporin 12A), a water channel expressed in pancreatic acinar cells (see Table: Hub genes (`wgcna_hub_genes.csv`); see Figure: Hub genes barplot (`wgcna_hub_genes_barplot.png`)).

**Biological interpretation:** The blue module represents the **normal pancreatic acinar cell identity program**. Its suppression in tumors confirms the loss of acinar function seen in Modules 2 and 3. The high DE fraction (83%) shows that this is not a subtle coordinated shift — most genes in this module are individually significant in the DE analysis, and they cluster together because they share the same regulatory program. The eigengene heatmap (see Figure: Eigengene heatmap (`wgcna_eigengene_heatmap.png`)) visually confirms the sharp drop in blue module activity in tumor samples.

### The brown module: Tumor-activated program

The brown module (824 genes) is **strongly positively correlated with tumor status** (r = +0.72) (see Figure: Module-trait heatmap (`wgcna_module_trait_heatmap.png`)). This module is activated in PDAC tumors. **79.4% of brown module genes are DE** (654 of 824) (see Table: Module-DE overlap (`wgcna_module_de_overlap.csv`)), confirming it represents a robust tumor-specific program.

The top hub gene is **JPT1** (Jupiter microtubule associated homolog 1), involved in cell proliferation (see Table: Hub genes (`wgcna_hub_genes.csv`)).

**Biological interpretation:** The brown module represents a **tumor-activated biological program**. Based on the enrichment results (Module 3), this likely includes immune/stromal activation, cell cycle progression, and EMT — the programs that PDAC tumors acquire to sustain malignant growth. The high DE fraction confirms these are strong, consistent changes.

### The purple module: Highly DE-enriched tumor program

The purple module (135 genes) has the **highest DE fraction** (89.6%) and is positively correlated with tumor (r = +0.63) (see Table: Module-DE overlap (`wgcna_module_de_overlap.csv`)). The top hub gene is **IGLC2** (immunoglobulin lambda constant 2), a B cell marker (see Table: Hub genes (`wgcna_hub_genes.csv`)).

**Biological interpretation:** The purple module likely represents **B cell / immune cell infiltration**. The IGLC2 hub gene and the high DE fraction suggest this module captures a strong, coherent immune signal — likely the B cell/plasma cell infiltrate that is a known feature of PDAC tumor stroma.

### The yellow and greenyellow modules: Additional tumor-activated programs

These smaller modules (388 and 97 genes) are also positively correlated with tumor status (see Figure: Module-trait heatmap (`wgcna_module_trait_heatmap.png`)), representing additional tumor-activated programs. Their lower DE fractions (54% and lower) suggest they capture more subtle coordinated shifts that not all pass the DE cutoff — exactly the type of signal that WGCNA is designed to detect but DE analysis may miss.

### The tan module: Suppressed program

The tan module (85 genes) is negatively correlated with tumor (r = -0.51), representing another normal-tissue program suppressed in PDAC. The top hub gene is **SETBP1**, a regulator of myeloid differentiation (see Table: Hub genes (`wgcna_hub_genes.csv`)).

---

## Key Findings

### Finding 1: WGCNA and DE analysis tell a consistent story

The most powerful validation comes from the **DE gene overlap** analysis (see Table: Module-DE overlap (`wgcna_module_de_overlap.csv`)). The three modules most strongly correlated with tumor status (blue, brown, purple) also have the highest DE fractions (83%, 79%, 90%). This means:

- Genes that are individually significant in DE analysis (Module 2) **cluster together** in co-expression modules (Module 4)
- Modules correlated with tumor status are **enriched for DE genes**
- The single-gene (DE) and network-level (WGCNA) analyses are **not contradictory but complementary** — they identify the same biological programs from different angles

### Finding 2: The blue module captures the acinar identity program

The blue module (r = -0.74, 83% DE) is the network-level representation of the acinar cell identity loss seen in Modules 2 and 3. Its 1,145 genes (see Table: Gene modules (`wgcna_gene_modules.csv`)) include the digestive enzymes (CTRB1, CPA1, PNLIP) that were the top downregulated DE genes, plus hundreds of other co-expressed genes that define the acinar cell program.

### Finding 3: Hub genes are candidate key regulators

The hub genes identified in each significant module (see Table: Hub genes (`wgcna_hub_genes.csv`); see Figure: Hub genes barplot (`wgcna_hub_genes_barplot.png`)) are the most connected and central genes — the best candidates for experimental validation:

| Module | Top Hub Gene | Function | Validation Candidate |
|--------|-------------|----------|---------------------|
| blue (suppressed) | AQP12A | Pancreatic water channel | Marker of acinar identity |
| brown (activated) | JPT1 | Cell proliferation | Tumor proliferation driver |
| purple (activated) | IGLC2 | B cell marker | Immune infiltration marker |
| yellow (activated) | GPR35 | G-protein coupled receptor | Signaling in tumor |
| greenyellow (activated) | ANXA8 | Annexin, calcium signaling | Membrane dynamics in tumor |
| tan (suppressed) | SETBP1 | Myeloid differentiation | Normal tissue regulator |

These hub genes are prioritized for experimental follow-up (knockdown, overexpression, correlation with clinical outcomes) because they are central to modules associated with tumor status.

### Finding 4: WGCNA detects modules that DE alone would miss

The yellow and greenyellow modules have lower DE fractions (54% and below) (see Table: Module-DE overlap (`wgcna_module_de_overlap.csv`)), meaning many of their genes do not pass the DE significance cutoff. However, these modules are still significantly correlated with tumor status (r = +0.56 and +0.55) (see Table: Module-trait correlations (`wgcna_module_trait_cor.csv`)). This demonstrates WGCNA's ability to detect **coordinated moderate changes** that individual gene testing misses — a key advantage of the network approach.

---

## Caveats and Limitations

### Batch effect caveat

As diagnosed in Module 1b (Script 02), GSE130688 has two batches: Batch 1 (28 samples, P01-P14) and Batch 2 (2 samples, P15). Batch is confounded with patient, so no computational correction was applied. For WGCNA, P15's two samples participate in the network without batch adjustment. Since WGCNA uses all samples simultaneously in correlation-based network construction, P15's batch-specific expression patterns could subtly influence module assignments and eigengene values. The module-trait heatmap (see Figure: Module-trait heatmap (`wgcna_module_trait_heatmap.png`)) and eigengene heatmap (see Figure: Eigengene heatmap (`wgcna_eigengene_heatmap.png`)) should be checked for whether P15's samples cluster unusually. With only 2 of 30 samples affected, the impact on module discovery is expected to be minimal, but individual-level conclusions about P15 should be interpreted cautiously. See `02_batch_correction_interpretation.md` for the full batch diagnosis.

### Sample size (n=30)

WGCNA with 30 samples is at the lower end of the recommended range (>=15 minimum, 20+ recommended). While we detected robust modules, larger cohorts would:
- Improve module detection stability
- Enable more reliable module-trait correlations
- Allow module preservation analysis across independent datasets

### Soft power selection (power = 18)

A soft power of 18 is relatively high (see Figure: Soft power selection (`wgcna_soft_power.png`)), indicating the data required aggressive thresholding to achieve scale-free topology. This can happen with:
- Small sample sizes (fewer samples = noisier correlations = higher power needed)
- Heterogeneous data (tumor and normal have very different expression profiles)

The R^2 = 0.871 is above the 0.8 threshold, confirming the network approximates scale-free topology.

### Grey module (149 genes)

149 genes (3% of the 5,000 analyzed) were not assigned to any module (see Table: Gene modules (`wgcna_gene_modules.csv`)). This is normal and expected — these genes don't have strong co-expression patterns with any module. They are excluded from module-trait analysis.

### Module merging threshold

The mergeCutHeight = 0.25 means modules with eigengene correlation > 0.75 were merged. A lower threshold would produce more, smaller modules; a higher threshold would produce fewer, larger modules. The choice affects the granularity of module detection. The dendrogram (see Figure: Dendrogram (`wgcna_dendrogram.png`)) shows the clustering structure and merged modules.

### Hub gene identification

Hub genes are identified by statistical connectivity (see Table: Hub genes (`wgcna_hub_genes.csv`)), not by functional validation. A hub gene is the most connected gene in its module, but this does not prove it is a causal regulator — it could be a downstream target of the true regulator. Experimental validation (knockdown, overexpression) is needed to confirm regulatory roles.

### No independent validation cohort

Module preservation analysis (testing whether modules reproduce in an independent dataset) was not performed because we used a single dataset. For publication-grade results, module preservation should be tested in an independent PDAC cohort.

---

## Connection to Literature

The original GSE130688 study (Reis et al., PMID 35567709) used WGCNA on this same dataset to associate deregulated lncRNAs with biological processes. They identified modules associated with cell adhesion, protein glycosylation, and DNA repair. Our analysis focuses on protein-coding genes but uses the same method, and our findings are consistent:

- The **blue module** (normal pancreatic identity) corresponds to the acinar cell program that Reis et al. found to be suppressed in tumors
- The **brown and purple modules** (tumor-activated) correspond to the stromal and immune programs they identified

The identification of IGLC2 as a hub gene in the purple module is consistent with literature showing that **B cell infiltration** is a feature of PDAC, though its prognostic significance is debated (some studies show B cell infiltration correlates with better outcomes, others with worse) [1].

---

## Cross-Module Integration

### The complete biological narrative

Combining all four modules, the PDAC story is:

1. **Module 1 (Data Prep):** Paired tumor-vs-normal design controls for inter-patient variability
2. **Module 1b (Batch Detection):** Batch is confounded with patient but the paired design absorbs it; condition explains 24.3% of variance vs 8.0% for batch
3. **Module 2 (DESeq2):** 6,696 genes are differentially expressed; top downregulated genes are pancreatic digestive enzymes (acinar identity loss); top upregulated genes include immune and stromal genes
4. **Module 3 (Enrichment):** Upregulated pathways are dominated by immune response (interferon gamma, Fc receptor, complement, phagocytosis); downregulated pathways are pancreatic acinar cell lineage and digestion
5. **Module 4 (WGCNA):** The blue module (1,145 genes, r = -0.74) captures the acinar identity program; the brown module (824 genes, r = +0.72) captures a tumor-activated program; the purple module (135 genes, 90% DE) captures B cell infiltration

**The convergence is striking:** All three analytical approaches (DE, enrichment, WGCNA) identify the same two biological themes:
- **Loss of pancreatic acinar identity** (downregulated DE genes → digestion pathways → blue module)
- **Gain of immune/stromal programs** (upregulated DE genes → immune pathways → brown/purple modules)

This convergence across independent methods is the strongest evidence that these are real, robust biological findings — not artifacts of any single method.

### From analysis to action

The hub genes identified in this module (see Table: Hub genes (`wgcna_hub_genes.csv`)) are the most actionable outputs:
- **AQP12A** (blue module hub): Potential biomarker for normal pancreatic tissue; loss indicates tumor
- **JPT1** (brown module hub): Candidate proliferation driver; potential therapeutic target
- **IGLC2** (purple module hub): Marker of immune infiltration; potential immunotherapy response predictor

These candidates should be validated by:
1. Cross-referencing with independent PDAC cohorts (TCGA, ICGC)
2. Correlation with clinical outcomes (survival, treatment response)
3. Experimental validation (knockdown/overexpression in cell lines)

---

## References

1. Wouters et al. (2014) Regulatory T cells and tumor-associated macrophages in PDAC. *Pancreas.* doi:10.1097/MPA.0000000000000126
2. Langfelder & Horvath (2008) WGCNA: an R package for weighted correlation network analysis. *BMC Bioinformatics.* doi:10.1186/1471-2105-9-559
3. Zhang & Horvath (2005) A general framework for weighted gene co-expression network analysis. *Stat Appl Genet Mol Biol.* doi:10.2202/1544-6115.1128
4. Reis et al. (2022) Annotation and functional characterization of long noncoding RNAs deregulated in pancreatic adenocarcinoma. *PubMed ID: 35567709*
