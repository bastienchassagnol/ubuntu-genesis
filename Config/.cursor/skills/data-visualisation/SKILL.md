---
name: "data-visualisation"
description: "Choose and design charts in R, Python, Quarto, LaTeX or slides: pick the chart from the data type (data-to-viz decision tree), apply the dataviz caveats with ggplot2 before/after snippets, follow a step-by-step line-chart makeover, build HCL palettes with colorspace, set project fonts with systemfonts, ragg, svglite, and marquee, and pick the right library level (ggplot2, ggiraph, Observable Plot, D3, Mosaic, React). Use with the data-visualisation rule, which holds the house theme and checklist. Routes to focused files in references/."
---

# Data visualisation: references

The `data-visualisation` rule (`~/.claude/rules/data-visualisation.md`) holds
the house theme `theme_slide()`, colour roles, export settings and the
checklist. This skill holds the long material; read only the file you need.

| Task | Reference |
|---|---|
| Which chart for this data? (numeric, categoric, mixed, relational, map, time series) | `references/chart-chooser.md` |
| Caveats with ggplot2 `# avoid` / `# prefer` code (scales, bars, scatter, lines, colour, labels, layout, panels, heatmaps) | `references/caveats.md` |
| Redesign a line chart step by step (direct labels, story title, highlight) | `references/line-chart-makeover.md` |
| Which library: static, ggiraph, Plot, D3, Mosaic, React; galleries to search | `references/libraries.md` |
| Qualitative, sequential, or diverging palette in HCL, then the ten colour rules | `references/colour-palettes.md` |
| Project fonts: install, discover with systemfonts, render with ragg or svglite | `references/fonts.md` |
| Scatter split by a threshold, with a few labels | `references/annotated-scatter.md` |
| PCA and other latent projections | `references/latent-projection.md` |
| Treemap for a count and its share of a parent | `references/treemap.md` |
| Ternary plot for exactly three closed parts | `references/ternary.md` |
| Waterfall of tumour response in a clinical study | `references/waterfall-clinical.md` |
| Differential expression: null calibration, p-value histograms, gate, volcano, heatmap, UpSet, bimodality | `references/differential-expression.md` |
| Enrichment (ORA, GSEA): summary lollipop, Manhattan, GSEA volcano, semantic map, dot plot | `references/enrichment-plots.md` |
| Mathematical notation in a figure (`latex2exp::TeX()`) | `references/differential-expression.md` |

Interactive implementation (OJS, D3, React in Quarto): the `quarto` skill,
`references/ojs-*.md` and `references/react-in-quarto.md`.

## Workflow

1. Write the question the figure answers; it becomes the title's finding.
2. Identify the data type and purpose; pick candidates in `chart-chooser.md`.
3. Classify the mapped variable and build the palette (`colour-palettes.md`) before writing scales.
4. Resolve the font family (`fonts.md`). Ordinary text uses `theme_slide(base_family = ...)`. Rich text uses `marquee`.
5. Draw it in `ggplot2` with `theme_slide()`. Raster with `ragg`, vector with `svglite`.
6. Check the relevant caveats, then run the rule's checklist.
7. Only if the reader must explore, climb the ladder in `libraries.md`.
