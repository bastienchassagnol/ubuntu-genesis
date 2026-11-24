---
name: "data-visualisation"
description: "Choose and design charts in R, Quarto, LaTeX or slides: dataviz-inspiration gallery search before code, data-to-viz chart chooser, ggplot2-production idioms, caveats, house theme, colours, fonts, ggdist rainclouds, interactive ladder to quarto-revealjs. Pair with roast-my-chart before publish. Routes to references/."
---

# Data visualisation: references

The `data-visualisation` rule (`~/.claude/rules/data-visualisation.md`) holds
the house theme `theme_slide()`, colour roles, export settings and the
checklist. This skill holds the long material; read only the file you need.

| Task | Reference |
|---|---|
| Before any plot: search 3–5 gallery references (bilingual query, `--family`) | `references/dataviz-inspiration.md` (`scripts/search_viz.py`) |
| Which chart for this data? (numeric, categoric, mixed, relational, map, time series) | `references/chart-chooser.md` |
| Idiomatic ggplot2 code (scales, facets, export) — after house theme | `references/ggplot2-production.md` |
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
| Test strategy for charts and dashboards (regression, mocks, E2E, brittle tests) | `references/testing/` (see table below) |

### Testing charts (`references/testing/`)

| Task | File |
|---|---|
| Choose unit vs component vs E2E | `testing/test-level-selection.md` |
| Visual regression and screenshots | `testing/visual-regression-and-image-testing.md` |
| Mocked or synthetic chart data | `testing/data-mocking-and-fixtures.md` |
| Component and unit tests | `testing/unit-and-component-tests.md` |
| Dashboard QA and exports | `testing/e2e-dashboard-and-export-strategies.md` |
| Trim overgrown suites | `testing/avoiding-brittle-over-testing.md` |

Interactive slides (OJS, D3, React in reveal.js): **quarto-revealjs** skill.

## Workflow

0. **Inspiration:** run `scripts/search_viz.py`; cite 3–5 references (`dataviz-inspiration.md`).
1. Write the question the figure answers; it becomes the title's finding.
2. Identify the data type and purpose; pick candidates in `chart-chooser.md`.
3. Classify the mapped variable and build the palette (`colour-palettes.md`) before writing scales.
4. Resolve the font family (`fonts.md`). Ordinary text uses `theme_slide(base_family = ...)`. Rich text uses `marquee`.
5. Draw it in `ggplot2` with `theme_slide()`. Raster with `ragg`, vector with `svglite`.
6. Check the relevant caveats, then run the rule's checklist.
7. Only if the reader must explore, climb the ladder in `libraries.md`.
8. Before publish, run **roast-my-chart** on the render or code.
