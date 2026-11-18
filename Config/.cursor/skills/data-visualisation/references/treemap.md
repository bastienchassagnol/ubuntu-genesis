# Treemaps

A treemap shows a hierarchy, or a composition where the reader needs both the
absolute count and the share of a parent. Area is the absolute count. The
label on a tile is the share. Fill is the group (lineage, region), not a
second encoding of the same proportion.

Flat lists of counts stay a ranked bar or lollipop (`caveats.md`, #12, #50).
Pies and doughnuts stay out (#13). Gallery: [r-graph-gallery treemap](https://r-graph-gallery.com/treemap).
The label hierarchy follows Loukas Theodosiou’s
[20251125_treemap.R](https://github.com/loukesio/tidytuesday/blob/main/2025/2025-11-25_SPIndicators/20251125_treemap.R)
(TidyTuesday, 25 November 2025): a strong parent border, parent labels large,
child labels only on large tiles. That script loads fonts with `showtext`;
this module does not.

## Cytometry and other compositions

One sample, or one summary, with a parent (lineage) and children (populations):

- `area` = cell count (absolute).
- `subgroup` = lineage.
- `label` = percent of the parent, printed only when the tile is large enough
  to read. Do not label every child.
- `fill` = lineage, qualitative (`colour-palettes.md`).

Comparing compositions across samples is small-multiple bars or an alluvial,
not one treemap. Area comparisons across distant tiles are hard; the printed
percent is what the reader should use for the share.

```r
ggplot(cells, aes(area = n_cells, fill = lineage, subgroup = lineage, label = share_label)) +
  treemapify::geom_treemap(colour = "white", size = 2) +
  treemapify::geom_treemap_subgroup_border(colour = "#1c2b24", size = 5) +
  treemapify::geom_treemap_subgroup_text(
    place = "centre", grow = FALSE, colour = "#1c2b24",
    fontface = "bold", size = 16, min.size = 8
  ) +
  treemapify::geom_treemap_text(
    place = "centre", grow = FALSE, colour = "white",
    size = 8, alpha = 0.9, min.size = 6
  ) +
  colorspace::scale_fill_discrete_qualitative(palette = "Dark 3") +
  labs(
    title = "CD8 cells are most of the T-cell compartment",
    subtitle = "Tile area is the cell count. The figure in a tile is the percent of its lineage."
  ) +
  theme_slide() +
  theme(legend.position = "bottom")
```

`share_label` is `""` for tiles below the size you can read at export, and a
rounded percent (`caveats.md`, #43) otherwise. State that cutoff in the caption.
