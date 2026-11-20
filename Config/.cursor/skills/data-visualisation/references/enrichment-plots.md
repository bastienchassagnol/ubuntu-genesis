# Enrichment (ORA, GSEA): default figures

Use this after a differential-expression analysis, to show which gene sets
the DE genes fall into. House theme `theme_slide()` and the checklist are
in the `data-visualisation` rule. Reference implementation:
`DeCovarT_reproducibility`, `R/02_05_stats_enrichment.R`,
`R/02_05_vis_enrichment.R`; earlier version in GastroDeconv2FateMap
`scripts/06_03_enrichment_analyses.R`.

## Analysis defaults (state them in the caption or methods)

- **ORA** on the confirmed genes of one contrast, with the **tested genes
  as universe** (never the whole genome); **GSEA** on all tested genes
  ranked by a signed statistic of the same contrast (a t or z, not a
  p-value alone).
- Databases: GO BP (`clusterProfiler::enrichGO()`, `gseGO()`), Reactome
  (`ReactomePA::enrichPathway()`, `gsePathway()`; it takes no `eps` or
  `seed`, so wrap it in `withr::with_seed()`), MSigDB Hallmark
  (`msigdbr(species, collection = "H")` + `enricher()`, `GSEA()`). Keep all
  terms (`pvalueCutoff = 1`) and apply BH 0.05 downstream; gene sets of 10
  to 500 genes.
- Redundancy of GO terms: `simplifyEnrichment::GO_similarity()` +
  `cluster_terms(method = "binary_cut")`; lower `control = list(cutoff = )`
  below 0.85 when the default gives only one or two clusters.
- A theme label written by a language model is a draft: keep it in a
  versioned table (`theme`, keys, `description_by`), check every term
  against the significant table, and say so in a callout.

| Question | Figure |
|---|---|
| What are the main themes across contrasts, methods and databases? | summary lollipop (one figure) |
| How strong is each term within one contrast? | Manhattan plot of ORA, one panel per contrast |
| Which sets move up or down along the ranking? | GSEA volcano: NES against -log10 adjusted p |
| How do the significant GO terms group? | semantic map (MDS of 1 - similarity), clusters coloured |
| Top terms of a few contrasts, side by side | decluttered dot plot |

## Rules

- **Summary lollipop.** One row per curated term, grouped by theme
  (`facet_grid(theme ~ ., scales = "free_y", space = "free_y",
  switch = "y")`), x = -log10 adjusted p, segment from 0, colour =
  database (GO BP `#1d4e89`, Reactome `#c45c26`, Hallmark `#5b8c5a`),
  shape = ORA (16) or GSEA (17), dashed line at 0.05; the contrast in the
  row label. Ordered by significance within a theme. This is the figure
  to show first; the others are supplementary.
- **Manhattan.** x = terms ordered by database then id, y = -log10 p,
  dashed line at the largest p passing BH in the panel, two labels per
  panel (`ggrepel`, wrapped at about 28 characters), free scales.
  `enrichplot::manhattanplot()` is an alternative but harder to theme.
- **GSEA volcano.** x = NES with a line at 0, y = -log10 adjusted p,
  non-significant terms grey `#d9d3c7`, three labels per panel.
- **Semantic map.** Point size by area = number of contrasts in which the
  term is significant (`scale_size_area()`); colour only the 8 largest
  clusters (qualitative HCL, `colorspace::qualitative_hcl(palette =
  "Dark 3")`), others grey; label each coloured cluster with its most
  frequent term (`geom_label_repel`, white fill); `coord_equal()`.
- **Dot plot, decluttered.** At most 5 terms per contrast after semantic
  reduction, labels wrapped, x = gene ratio, size = count, colour =
  -log10 adjusted p (sequential); never more than about 30 rows.
- Long term names: wrap (`strwrap`), do not shrink below 7 pt.
