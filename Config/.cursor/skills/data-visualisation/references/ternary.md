# Ternary plots

Use a ternary plot only when **three** parts close: three cell-type fractions,
or any three metrics renormalised so they sum to 1. It replaces a radar or
spider chart for that case (`caveats.md` rejects radial bars, #14). Four or
more parts go to a treemap (`treemap.md`) or to stacked bars.

The layout follows Loukas Theodosiou’s
[20250401_pokemon.R](https://github.com/loukesio/tidytuesday/blob/main/2025/2025-04-01_Pokemon/20250401_pokemon.R)
(TidyTuesday, 1 April 2025): faint regions for which part dominates, points
coloured by that part, labels only on the extremes. Plot the proportions, not
the raw scores. The caption states the closure (each point sums to 1, so a
rise in one part is a fall in the others).

```r
parts <- c("cd4", "cd8", "other")
ternary <- transform(
  cells,
  total = cd4 + cd8 + other,
  cd4 = cd4 / total,
  cd8 = cd8 / total,
  other = other / total
)
ternary$dominant <- parts[max.col(ternary[parts], ties.method = "first")]

ggtern::ggtern(ternary, ggplot2::aes(x = cd4, y = cd8, z = other)) +
  ggplot2::geom_point(
    ggplot2::aes(colour = dominant),
    alpha = 0.7, size = 2.5
  ) +
  colorspace::scale_colour_discrete_qualitative(palette = "Dark 3") +
  ggplot2::labs(
    title = "Most samples are CD8-dominant among these three fractions",
    x = "CD4", y = "CD8", z = "Other",
    caption = "Each point is three fractions of one sample and sums to 1."
  ) +
  theme_slide()
```

Add a short label for the sample with the highest fraction on each axis
(`slice_max` on that proportion), in the guide colour `#1c2b24`. A faint
polygon behind each dominance region is optional; keep its alpha low enough
that the points remain the mark. Do not add a fourth axis, and do not size
the points by one of the three fractions already on the axes.
