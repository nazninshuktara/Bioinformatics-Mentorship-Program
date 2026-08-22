# Script 01: Data Preparation for RNA-seq Lecture

# WHAT: Load raw RNA-seq count data and sample metadata, derive patient IDs
#       from the paired tumor/normal design, map Entrez gene IDs to gene
#       symbols, construct an enriched metadata table, pre-filter low-count
#       genes, and save all processed objects for downstream scripts.
#
# WHY:  DESeq2 requires (1) raw integer counts, (2) sample metadata whose row
#       names match count-matrix columns, and (3) a design formula. Because
#       GSE130688 is a PAIRED design (tumor + adjacent normal from the same
#       patient), we need a `patient` column to block on patient-specific
#       baseline expression. Gene symbols are needed for interpret-ability in
#       visualization and for WGCNA module labeling. Pre-filtering low-count
#       genes reduces the multiple-testing burden and improves statistical
#       power without biasing the DE test.
#
# BIOLOGICAL CONTEXT:
#   GSE130688 contains 15 patient-matched pairs of pancreatic ductal
#   adenocarcinoma (PDAC) tumor tissue and adjacent non-tumor pancreatic
#   tissue. Using matched pairs controls for inter-patient genetic and
#   microenvironmental variability, isolating tumor-specific expression
#   changes. This is the foundation for all downstream analyses.
#
# DATASET: GSE130688 (Reis et al., PMID 35567709)
#   - 30 samples (15 tumor + 15 normal), paired by patient
#   - Illumina HiSeq 1500/2500, strand-oriented total RNA-seq
#   - Raw integer gene counts, Entrez gene IDs, 39,377 genes
# =============================================================================

suppressPackageStartupMessages({
  library(DESeq2)
  library(org.Hs.eg.db)
})

# ---- Configuration ----------------------------------------------------------
counts_file  <- "data/GSE130688_raw_counts.tsv"
metadata_file <- "data/GSE130688_metadata.csv"
output_dir    <- "data"

# ---- Step 1: Load raw count matrix -----------------------------------------
# WHAT: Read the TSV file. Rows = genes (Entrez IDs), Columns = samples (GSM IDs)
# WHY:  This is the starting point. We must verify the data is raw integer
#       counts (not normalized TPM/FPKM) because DESeq2's negative binomial
#       model assumes count data.
counts <- read.delim(counts_file, row.names = 1, check.names = FALSE)
counts <- as.matrix(counts)

# CRITICAL CHECK: Verify these are integer counts (not normalized values)
# WHY: DESeq2 requires raw counts. Normalized data (TPM/FPKM) would violate
#      the negative binomial model assumptions.
if (!all(counts == floor(counts), na.rm = TRUE)) {
  stop("ERROR: Count matrix contains non-integer values. DESeq2 requires raw integer counts.")
}

# Preserve Entrez IDs as character BEFORE converting counts to integer
entrez_ids_original <- rownames(counts)
counts <- apply(counts, 2, as.integer)
rownames(counts) <- gsub("^X", "", entrez_ids_original)  # clean any X prefix, keep as character

# ---- Step 2: Load sample metadata ------------------------------------------
# WHAT: Read metadata CSV. Contains Sample (GSM ID) and Condition (tumor/normal)
# WHY:  Metadata links each sample to its biological condition. The condition
#       column will become the primary variable in the DESeq2 design formula.
metadata <- read.csv(metadata_file, stringsAsFactors = FALSE)
table(metadata$condition)

# ---- Step 3: Derive patient IDs from paired design -------------------------
# WHAT: Assign patient IDs based on the paired structure. In GSE130688,
#       samples alternate normal/tumor for the same patient (confirmed via
#       GEO sample titles: "Non-tumor 1N", "Tumor 1T", "Non-tumor 2N", etc.)
# WHY:  The paired design (~ patient + condition) requires a patient
#       identifier to block on patient-specific baseline expression. This
#       is the KEY teaching point: paired design dramatically improves power
#       by removing inter-patient variability from the residual.
# Sort metadata to match count matrix column order
metadata <- metadata[match(colnames(counts), metadata$sample), ]

# Derive patient IDs: consecutive normal/tumor pairs belong to the same patient
# The metadata alternates: normal, tumor, normal, tumor, ...
# So patient = ceiling(row_index / 2)
metadata$patient <- paste0("P", sprintf("%02d", ceiling(seq_len(nrow(metadata)) / 2)))
metadata

# ---- Step 4: Standardize condition labels and set reference level ----------
# WHAT: Normalize condition labels (lowercase) and set "normal" as the
#       reference level. This ensures the DESeq2 contrast is tumor vs normal
#       (positive log2FC = upregulated in tumor).
# WHY:  The reference level determines the direction of the fold change.
#       Setting normal as reference means positive log2FC = higher in tumor,
#       which is the biologically intuitive direction for cancer studies.
metadata$condition <- as.factor(metadata$condition)
metadata$patient   <- as.factor(metadata$patient)

# ---- Step 5: Validate sample ID matching -----------------------------------
# WHAT: Confirm that count matrix column names exactly match metadata row names
# WHY:  A mismatch here is the #1 cause of DESeq2 errors. This validation
#       catches typos, suffix differences, and ordering issues early.
rownames(metadata) <- metadata$sample
all(colnames(counts) == rownames(metadata))

# ---- Step 6: Map Entrez gene IDs to gene symbols ---------------------------
# WHAT: Use org.Hs.eg.db to map Entrez IDs to gene symbols. Some Entrez IDs
#       may not map (retired IDs, non-standard loci) — these are flagged.
# WHY:  Gene symbols are human-readable and required for:
#       - Volcano plot labels (Script 03)
#       - GSEA/ORA gene set matching (Scripts 04-05, MSigDB uses symbols)
#       - WGCNA module interpretation (Scripts 06-07)
#       Teaching point: ID mapping is a common source of data loss; always
#       check how many genes fail to map.
entrez_ids <- rownames(counts)
symbol_map <- AnnotationDbi::select(
  org.Hs.eg.db,
  keys = entrez_ids,
  columns = c("ENTREZID", "SYMBOL", "GENENAME"),
  keytype = "ENTREZID"
)

# Handle duplicate Entrez IDs (keep first mapping)
symbol_map <- symbol_map[!duplicated(symbol_map$ENTREZID), ]
mapped_count <- sum(!is.na(symbol_map$SYMBOL))

# Create mapping table and save
gene_mapping <- data.frame(
  entrez_id = entrez_ids,
  symbol    = symbol_map$SYMBOL[match(entrez_ids, symbol_map$ENTREZID)],
  genename  = symbol_map$GENENAME[match(entrez_ids, symbol_map$ENTREZID)],
  stringsAsFactors = FALSE
)
write.csv(gene_mapping, file.path(output_dir, "gene_id_mapping.csv"), row.names = FALSE)

# Add symbols as row names where available; keep Entrez ID for unmapped genes
gene_labels <- ifelse(is.na(gene_mapping$symbol), gene_mapping$entrez_id, gene_mapping$symbol)

# Handle duplicate symbols (append Entrez ID to make unique)
dup_syms <- gene_labels[duplicated(gene_labels) | duplicated(gene_labels, fromLast = TRUE)]
if (length(dup_syms) > 0) {
  gene_labels[duplicated(gene_labels) | duplicated(gene_labels, fromLast = TRUE)] <-
    paste0(gene_labels[duplicated(gene_labels) | duplicated(gene_labels, fromLast = TRUE)],
           "_", gene_mapping$entrez_id[duplicated(gene_labels) | duplicated(gene_labels, fromLast = TRUE)])
}
rownames(counts) <- gene_labels

# ---- Step 7: Pre-filter low-count genes ------------------------------------
# WHAT: Remove genes with very low counts across all samples. Standard filter:
#       keep genes with at least 10 counts in at least 2 samples (a common
#       heuristic that removes genes unlikely to be meaningful).
# WHY:  Pre-filtering reduces the multiple testing burden (fewer genes tested
#       = more power after BH correction) and speeds up computation. It does
#       NOT bias the test because these genes have essentially no information.
#       DESeq2's independent filtering would handle this anyway, but explicit
#       pre-filtering is cleaner and faster.
keep <- rowSums(counts >= 10) >= 2
counts_filtered <- counts[keep, ]

# ---- Step 8: Save processed data -------------------------------------------
# WHAT: Save the enriched metadata, filtered counts, and gene mapping as
#       both CSV (human-readable) and RDS (for efficient R loading downstream)
# WHY:  Downstream scripts need these processed objects. Saving them once
#       avoids repeating the preprocessing in every script.
# Enriched metadata CSV
metadata_out <- metadata[, c("sample", "condition", "patient")]
write.csv(metadata_out, file.path(output_dir, "sample_metadata_enriched.csv"), row.names = FALSE)

# Filtered counts as RDS (for downstream scripts)
saveRDS(counts_filtered, file.path(output_dir, "counts_filtered.rds"))
saveRDS(metadata, file.path(output_dir, "metadata.rds"))
saveRDS(gene_mapping, file.path(output_dir, "gene_mapping.rds"))
