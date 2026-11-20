# Differential expression: default figures

Use this for any differential-expression (DE) or marker analysis: bulk or
single cell, an omnibus test across groups, or post hoc contrasts. Each
figure answers one question; draw them in this order and stop when the
question is answered. House theme `theme_slide()`, colour roles and export
are in the `data-visualisation` rule. Reference implementation:
`DeCovarT_reproducibility`, `R/02_02_vis_cross_cell.R` and
`R/02_04_vis_deg.R`.

| Question | Figure | Package |
|---|---|---|
| Is each test calibrated under the null? | QQ plot of null p-values (permuted labels) | `qqplotr` |
| What do the raw p-values look like before any adjustment? | p-value histogram, 0.05 bins, line at pi0 m / 20 | `ggplot2`, `qvalue::pi0est()` |
| Where is the power? | the same histogram split by mean-expression tertile | `ggplot2` |
| Which genes pass, and how large is their effect? | effect size against -log10 p, classes coloured | `ggplot2` |
| Does detection depend on expression? | effect size (or log2FC) against mean, log x (MA-type) | `ggplot2` |
| Which genes, in which group, by how much? | volcano per contrast | `ggplot2` + `ggrepel` |
| Is the fold-change distribution unimodal? | half-eye densities per contrast | `ggdist` |
| Do the DEG sets overlap? | UpSet (more than three sets) | `ComplexUpset` |
| Do methods agree? | confirmed counts per group: dots, colour = test, facet = design | `ggplot2` |
| What do the top genes look like in cells? | heatmap, rows split by group, cells subsampled | `ComplexHeatmap` |
| Is a marker bimodal within its group? | within-group histograms + bimodality coefficient, dip test | `ggplot2`, `diptest` |

## Rules

- **Null calibration.** Under the null `-log10 p` is exponential with rate
  `log(10)`, so `qqplotr` can draw the QQ plot on the tail-friendly scale:
  `stat_qq_point()`, `stat_qq_line(identity = TRUE)` and `stat_qq_band()`
  with `distribution = "exp", dparams = list(rate = log(10))`. Use
  `bandType = "pointwise"`; `"ks"` is simultaneous but very wide in the
  tail; `"ts"` exists only for the normal. State that the band assumes
  independent genes. Facet test x condition; square panels.
- **p-value histogram.** Unadjusted p, `breaks = seq(0, 1, 0.05)`, bars
  `#d9d3c7` with white outlines, dashed line at `pi0 * m / 20` with the
  value printed. Read: peak at 0 over a flat rest = signal; rise towards 1
  = conservative or discrete; spikes = discrete (permutation `k/(B+1)`);
  bump in the middle = wrong reference law (Breheny et al. 2018).
- **Gate figure.** x = -log10 p, y = effect size (sqrt scale for shares of
  deviance). Classes in at most three colours (fails grey `#9a9286`,
  passes `#c45c26`, stricter tier `#1d4e89`); dashed line at the largest
  passing p, dotted line at the permutation floor `1/(B+1)`; write the
  p-value formula with `latex2exp::TeX(..., output = "character")` and
  `geom_text(parse = TRUE)`. Jitter a discrete permutation p and say so.
- **Volcano.** x = log2FC of the contrast actually tested (state the
  reference: control, average of the others, ...), y = -log10 of a
  continuous p-value (a permutation p has a floor; use the parametric p
  for the axis and the calibrated decision for the colour, and say so).
  Cap y and say so. Colour = decision classes, not a raw p threshold.
  Label 5 to 10 genes per panel with `ggrepel` (italic gene symbols,
  `max.overlaps = Inf`). One panel per contrast, free scales. Do not use
  `EnhancedVolcano` defaults (red/green, legend inside); if used, apply
  `theme_slide()` and the house colours.
- **Heatmap.** `ComplexHeatmap::Heatmap()` on z-scored `log1p(x / s)`,
  clipped at +-3, diverging `#1d4e89`-white-`#c45c26`
  (`circlize::colorRamp2`); `row_split` = group the gene is confirmed in,
  `column_split` = group of the cell, `cluster_*_slices = FALSE`,
  subsample cells per group with a seed, top annotation with group and
  batch colours, `use_raster = TRUE`, italic row names. Save with
  `cairo_pdf()` and `ragg::agg_png()` around `draw()`, and save the gene
  list as `.rds`.
- **UpSet.** `ComplexUpset::upset(min_size = 5, n_intersections = 25)`;
  a Venn only for two or three sets.
- **Bimodality.** Report the bimodality coefficient (> 5/9 suggests two
  modes) and the dip test, and the share of zeros: a zero spike alone
  makes both look bimodal. Show only genes with fewer than half the cells
  at zero. Label the result as a candidate sub-state, not a test.
- **Counts across methods.** One dot per group x test, facet the design
  (flat BH, stage-wise Holm, graphical); never map two metrics to colour
  and size.

## Minimal code

```r
# Null calibration with qqplotr on the -log10 scale
dp <- list(rate = log(10))
ggplot(d, aes(sample = mlog_p)) +
  qqplotr::stat_qq_band(distribution = "exp", dparams = dp,
                        bandType = "pointwise", fill = "#d9d3c7") +
  qqplotr::stat_qq_line(distribution = "exp", dparams = dp, identity = TRUE) +
  qqplotr::stat_qq_point(distribution = "exp", dparams = dp, size = 0.4) +
  facet_grid(condition ~ test) +
  coord_equal() +
  theme_slide()

# p-value histogram with the pi0 line
pi0 <- qvalue::pi0est(p)$pi0
ggplot(data.frame(p), aes(p)) +
  geom_histogram(breaks = seq(0, 1, 0.05), fill = "#d9d3c7", colour = "white") +
  geom_hline(yintercept = pi0 * length(p) / 20, linetype = "dashed") +
  theme_slide()
```
