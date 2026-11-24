# ggplot2 production (idiomatic code)

Coding only — chart **choice** from `chart-chooser.md` and **`dataviz-inspiration.md`** first; pitfalls in `caveats.md`.

Provenance: [holtzy/dataviz-skills/ggplot2](https://github.com/holtzy/dataviz-skills) + Cédric Scherer; [ggplot2 AI skill](https://www.data-to-viz.com/ai-skills/ggplot2.html).

## House overrides (this bundle wins)

- Theme: **`theme_slide()`** (section below) — not raw `theme_minimal(14)` alone.
- Export: **`ragg::agg_png`** or **`svglite::svglite`** via `ggsave()`; explicit width, height, dpi.
- Colours: the colour roles below and `colour-palettes.md` before ad hoc scales.
- Distributions: **`ggdist`** raincloud / half-eye when shape matters (chart-chooser).

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

## House theme

`slide_family()` is defined in `fonts.md`.

```r
theme_slide <- function(base_family = NULL) {
  if (is.null(base_family)) base_family <- slide_family()
  ggplot2::theme_minimal(base_size = 18, base_family = base_family) +
    ggplot2::theme(
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major = ggplot2::element_line(colour = "#e6e1d8"),
      plot.title = ggplot2::element_text(face = "bold", colour = "#0e4d3a", size = 18),
      plot.subtitle = ggplot2::element_text(colour = "#3d4a42", size = 13),
      axis.title = ggplot2::element_text(colour = "#1c2b24"),
      strip.text = ggplot2::element_text(face = "bold", colour = "#0e4d3a"),
      legend.position = "bottom",
      plot.background = ggplot2::element_rect(fill = "white", colour = NA),
      panel.background = ggplot2::element_rect(fill = "white", colour = NA)
    )
}
```

### Colour roles

| Role | Colour |
|---|---|
| Series | `#1d4e89` |
| Second series or marked point | `#c45c26` |
| Histogram bars | `#d9d3c7` with white outlines |
| Guides and annotation | `#1c2b24` |

### Multi-panel type sizes

Titles about 15, subtitles about 11, axis titles about 12, axis text about 10.
Assemble panels with `grid::grid.layout()`.
