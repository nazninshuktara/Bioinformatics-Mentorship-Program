# Module 3: Functional Enrichment Analysis — Interpretation

## Figures and Tables Referenced

**Figures:**
- `enrichment_gsea_dotplot.png` — GSEA dotplot of top significant gene sets (by NES)
- `enrichment_gsea_running_score.png` — GSEA running enrichment score plot for top pathways
- `enrichment_ora_up_barplot.png` — ORA barplot of top pathways enriched in upregulated genes
- `enrichment_ora_down_barplot.png` — ORA barplot of top pathways enriched in downregulated genes

**Tables:**
- `enrichment_gsea_results.csv` — Full GSEA results (all tested gene sets)
- `enrichment_ora_up_results.csv` — ORA results for upregulated genes
- `enrichment_ora_down_results.csv` — ORA results for downregulated genes
- `enrichment_ranked_genes.rds` — Ranked gene list used as GSEA input

---

## Results Summary

| Method | Input | Significant Results |
|--------|-------|---------------------|
| **GSEA** | 22,489 ranked genes | 384 gene sets (padj < 0.05) |
| GSEA - Activated (NES > 0, up in tumor) | — | 360 |
| GSEA - Suppressed (NES < 0, down in tumor) | — | 24 |
| **ORA - Upregulated** | 2,030 up genes | 205 pathways (padj < 0.05) |
| **ORA - Downregulated** | 1,631 down genes | 34 pathways (padj < 0.05) |

The full GSEA results are in see Table: GSEA results (`enrichment_gsea_results.csv`); ORA results for up and down genes are in see Table: ORA up results (`enrichment_ora_up_results.csv`) and see Table: ORA down results (`enrichment_ora_down_results.csv`).

---

## Biological Significance

### Upregulated pathways: The immune/stromal tumor microenvironment

The top GSEA and ORA results for upregulated genes converge on a clear biological theme: **immune cell infiltration and stromal activation** in the PDAC tumor microenvironment (see Figure: GSEA dotplot (`enrichment_gsea_dotplot.png`); see Figure: ORA up barplot (`enrichment_ora_up_barplot.png`)).

**Top upregulated pathways (GSEA, by NES):**

| Pathway | NES | padj | Interpretation |
|---------|-----|------|----------------|
| HALLMARK_INTERFERON_GAMMA_RESPONSE | 2.76 | 0.012 | Immune activation in tumor |
| REACTOME_CELL_SURFACE_INTERACTIONS_AT_VASCULAR_WALL | 2.70 | 0.012 | Immune cell trafficking |
| REACTOME_IMMUNOREGULATORY_INTERACTIONS | 2.68 | 0.012 | Immune cell communication |
| REACTOME_FCGR_ACTIVATION | 2.68 | 0.012 | Fc gamma receptor signaling (macrophage/immune) |
| REACTOME_FCGAMMA_RECEPTOR_PHAGOCYTOSIS | 2.67 | 0.012 | Phagocytosis by immune cells |
| REACTOME_INITIAL_TRIGGERING_OF_COMPLEMENT | 2.65 | 0.012 | Complement activation |

**Top upregulated pathways (ORA, by p.adjust):**

| Pathway | Count | padj | Interpretation |
|---------|-------|------|----------------|
| REACTOME_IMMUNOREGULATORY_INTERACTIONS | 93 | 1.5e-40 | Lymphoid-non-lymphoid cell communication |
| REACTOME_CD22_MEDIATED_BCR_REGULATION | 53 | 5.7e-40 | B cell receptor signaling |
| REACTOME_FCGR_ACTIVATION | 56 | 5.4e-39 | Fc gamma receptor (macrophage activation) |
| REACTOME_CREATION_OF_C4_AND_C2_ACTIVATORS | 53 | 8.7e-35 | Complement cascade |
| REACTOME_SCAVENGING_OF_HEME_FROM_PLASMA | 53 | 8.7e-35 | Scavenger receptor function |

**Biological interpretation:** The upregulated immune pathways reflect the dense immune infiltrate characteristic of PDAC. However, in PDAC, this immune infiltration is typically **immunosuppressive** — dominated by M2 macrophages, regulatory T cells, and myeloid-derived suppressor cells that suppress anti-tumor immunity. The interferon gamma response and Fc receptor activation signatures likely reflect both pro- and anti-inflammatory immune programs operating simultaneously in the tumor microenvironment. The GSEA running score plot (see Figure: GSEA running score (`enrichment_gsea_running_score.png`)) shows how these immune gene sets accumulate at the top of the ranked gene list (upregulated in tumor).

### Downregulated pathways: Loss of pancreatic identity

The downregulated pathways confirm the loss of normal pancreatic function seen in the DE results (Module 2) (see Figure: ORA down barplot (`enrichment_ora_down_barplot.png`)):

**Top downregulated pathways (ORA):**

| Pathway | Count | padj | Interpretation |
|---------|-------|------|----------------|
| REACTOME_DEVELOPMENTAL_LINEAGE_OF_PANCREATIC_ACINAR_CELLS | 30 | 2.4e-31 | Loss of acinar cell identity |
| REACTOME_DEVELOPMENTAL_CELL_LINEAGES_OF_EXOCRINE_PANCREAS | 41 | 1.9e-25 | Loss of exocrine pancreas lineage |
| REACTOME_DEVELOPMENTAL_CELL_LINEAGES | 43 | 4.7e-17 | Loss of developmental lineage programs |
| REACTOME_NEURONAL_SYSTEM | 52 | 5.6e-07 | Loss of neuronal-related markers |
| REACTOME_DIGESTION | 10 | 1.0e-05 | Loss of digestive function |

**Top downregulated pathways (GSEA, by NES):**

| Pathway | NES | padj | Interpretation |
|---------|-----|------|----------------|
| REACTOME_DEVELOPMENTAL_LINEAGE_OF_PANCREATIC_ACINAR_CELLS | -2.48 | 0.012 | Loss of acinar cell identity |
| REACTOME_DIGESTION | -2.28 | 0.012 | Loss of digestive function |
| REACTOME_DEVELOPMENTAL_CELL_LINEAGES_OF_EXOCRINE_PANCREAS | -2.26 | 0.012 | Loss of exocrine pancreas lineage |
| REACTOME_DIGESTION_AND_ABSORPTION | -2.25 | 0.012 | Loss of digestive/absorptive function |
| REACTOME_DEVELOPMENTAL_CELL_LINEAGES | -2.10 | 0.012 | Loss of lineage programs |

**Biological interpretation:** The downregulation of pancreatic acinar cell lineage and digestion pathways is the pathway-level confirmation of the individual gene findings (Module 2). The tumor has lost the transcriptional programs that define normal pancreatic function. Both GSEA and ORA independently identify the same top downregulated pathways, strengthening this conclusion.

### GSEA vs. ORA agreement

The strong agreement between GSEA and ORA for the top immune/stromal pathways (both methods identify immunoregulatory interactions, Fc gamma receptor activation, complement, and phagocytosis as top hits — compare see Figure: GSEA dotplot (`enrichment_gsea_dotplot.png`) with see Figure: ORA up barplot (`enrichment_ora_up_barplot.png`)) indicates these are **robust findings** driven by both coordinated shifts (GSEA) and strong individual gene changes (ORA).

The 360 activated vs. 24 suppressed GSEA gene sets reflects the fact that PDAC tumors activate many more pathways (immune, stromal, proliferation) than they suppress. The suppressed pathways are fewer but highly specific (pancreatic function).

---

## Key Findings

### Finding 1: The PDAC tumor microenvironment is immunologically active

Both GSEA and ORA identify immune pathways as the most strongly upregulated in PDAC tumors (see Figure: GSEA dotplot (`enrichment_gsea_dotplot.png`); see Table: GSEA results (`enrichment_gsea_results.csv`)). This reflects the dense immune infiltrate in PDAC, though the functional consequence (tumor-promoting vs. anti-tumor immunity) requires further investigation.

### Finding 2: Loss of pancreatic identity is the dominant downregulated program

The most significantly downregulated pathways are specifically related to pancreatic acinar cell development and digestive function (see Figure: ORA down barplot (`enrichment_ora_down_barplot.png`); see Table: ORA down results (`enrichment_ora_down_results.csv`)). This is not a generic "loss of cell identity" — it is specifically the loss of the pancreatic lineage program.

### Finding 3: GSEA detects more activated than suppressed pathways

The asymmetry (360 activated vs. 24 suppressed GSEA gene sets) reflects the biological reality of PDAC: the tumor acquires many new capabilities (proliferation, immune modulation, stromal remodeling, EMT) while losing a more focused set of normal functions (pancreatic digestion).

---

## Caveats and Limitations

### GSEA permutation count

We used 1,000 permutations, the minimum recommended. With more permutations (e.g., 10,000), p-values would be more stable, but the ranking of top pathways is unlikely to change substantially.

### Gene set redundancy

Reactome pathways have hierarchical relationships — a parent pathway (e.g., "Immune System") contains many child pathways (e.g., "FcGR Activation", "Complement Cascade"). This means the 384 significant GSEA results (see Table: GSEA results (`enrichment_gsea_results.csv`)) include many related pathways, not 384 independent findings. The Hallmark gene sets (50 total) are non-redundant and provide a cleaner overview.

### ORA is sensitive to the cutoff choice

ORA results depend on the padj < 0.05 and |log2FC| >= 1 thresholds. A more relaxed cutoff (e.g., |log2FC| >= 0.5) would include more genes and potentially identify additional pathways. A more stringent cutoff would reduce the gene list and may miss pathways driven by modest but consistent changes. GSEA is not subject to this limitation.

### Entrez ID mapping loss

Of the 23,235 tested genes, 22,489 had Entrez IDs (96.8%). The 746 genes without Entrez IDs were excluded from enrichment analysis. These are mostly non-coding RNAs or genes with retired Entrez IDs.

### Background/universe definition in ORA

We used all 22,489 tested genes as the ORA universe. Using all ~20,000 human protein-coding genes would be incorrect — it would inflate p-values by including genes that were never tested (e.g., not expressed in pancreas).

---

## Connection to Literature

The immune-dominated upregulated pathways are consistent with the known immunobiology of PDAC:

- PDAC is characterized by a **dense, immunosuppressive microenvironment** with abundant M2 macrophages, myeloid-derived suppressor cells, and regulatory T cells [1]
- **Complement activation** in the tumor microenvironment can promote both inflammation and immune evasion [2]
- **Fc gamma receptor signaling** on macrophages reflects the active immune trafficking and phagocytic activity in the tumor stroma [3]

The downregulation of pancreatic acinar cell lineage pathways is consistent with the acinar-to-ductal metaplasia (ADM) model of PDAC development, where acinar cells lose their identity and acquire ductal-like properties during tumorigenesis [4].

---

## Cross-Module Integration

### Connection to Module 1b (Batch Detection)

The enrichment analysis uses DESeq2 results, which are already batch-controlled via the paired design (see `02_batch_correction_interpretation.md`). The variance partition confirmed that condition (24.3% variance) dominates batch (8.0%), so the enrichment results reflect biology, not technical artifacts.

### Connection to Module 2 (DESeq2)

The enrichment results are directly derived from the DE results:
- GSEA uses the full ranked list from DESeq2 (all genes, no cutoff) — see Table: Ranked genes (`enrichment_ranked_genes.rds`)
- ORA uses the significant gene list (padj < 0.05, |log2FC| >= 1) from see Table: Significant DE genes (`deseq2_significant_genes.csv`)

The pathway-level findings provide biological context for the individual DE genes. For example, the downregulation of CTRB1, CPA1, PNLIP (Module 2) is explained by the suppression of the "Digestion" and "Pancreatic Acinar Cell Lineage" pathways (Module 3).

### Connection to Module 4 (WGCNA)

The enrichment results can be compared with WGCNA module-trait correlations:
- A WGCNA module correlated with tumor status should be enriched for the same pathways identified here
- For example, if a "brown" module is positively correlated with tumor, we expect it to be enriched for immune/stromal pathways (matching the GSEA/ORA upregulated results)
- If a "blue" module is negatively correlated with tumor, we expect it to be enriched for pancreatic acinar function (matching the downregulated results)

This cross-validation between enrichment (gene-list-based) and WGCNA (network-based) provides the strongest evidence for biological relevance.

---

## References

1. Joyce & Fearon (2015) Cancer cell-intrinsic mechanisms and the immune microenvironment. *Science.* doi:10.1126/science.aaa6201
2. Afshar-Kharghan (2017) Complement as a risk factor in cancer. *Semin Immunol.* doi:10.1016/j.smim.2017.02.001
3. Brahmer et al. (2015) Society for Immunotherapy of Cancer consensus statement. *J Immunother Cancer.* doi:10.1186/s40425-015-0082-9
4. Storz et al. (2017) Acinar-to-ductal metaplasia and pancreatic cancer development. *Pancreas.* doi:10.1097/MPA.0000000000000776
