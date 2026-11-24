# ggplot2 production (idiomatic code)

Coding only — chart **choice** from `chart-chooser.md` and **`dataviz-inspiration.md`** first; pitfalls in `caveats.md`.

Provenance: [holtzy/dataviz-skills/ggplot2](https://github.com/holtzy/dataviz-skills) + Cédric Scherer; [ggplot2 AI skill](https://www.data-to-viz.com/ai-skills/ggplot2.html).

## House overrides (this bundle wins)

- Theme: **`theme_slide()`** from the `data-visualisation` rule — not raw `theme_minimal(14)` alone.
- Export: **`ragg::agg_png`** or **`svglite::svglite`** via `ggsave()`; explicit width, height, dpi.
- Colours: rule roles (`#1d4e89`, `#c45c26`, …) and `colour-palettes.md` before ad hoc scales.
- Distributions: **`ggdist`** raincloud / half-eye when shape matters (rule + chart-chooser).

## Conventions

- Tidyverse pipe `|>`; `snake_case` columns.
- One component per line; named `ggplot(data = , mapping = aes())` when teaching.
- `geom_col()` for given heights; `geom_bar()` only for counts.

## Scales and axes

- Zoom: `coord_cartesian()`; `scale_*_continuous(limits=)` **filters** data.
- Labels: `scales::label_comma()`, `label_percent()`, etc.
- Legend: `theme(legend.position = "bottom")` unless direct labels (`line-chart-makeover.md`).

## Facets

- `facet_wrap(vars())`, `facet_grid()`; `scales = "free_y"` only when panels need different ranges.

## Pitfalls

No `geom_bar(stat = "identity")` — use `geom_col()`. Constants **outside** `aes()`. `factor()` categoricals. Do not size from the RStudio pane — export and inspect.

Interactive HTML: `libraries.md` → **quarto-revealjs** for OJS/D3; keep a static archival ggplot export.