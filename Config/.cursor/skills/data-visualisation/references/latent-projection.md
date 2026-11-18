# Latent projections

Default linear projection: principal components of scaled columns. The layout
follows Loukas Theodosiou’s
[PCA_penguins.R](https://github.com/loukesio/tidytuesday/blob/main/2025/2025-04-15_Penguins/PCA_penguins.R)
(TidyTuesday, 15 April 2025): variance on the axes, dashed zero lines, a mark
around each known group. That script loads fonts with `showtext`; this module
does not.

## PCA

- Scale the columns that enter `prcomp()` (`scale = TRUE`, or `scale()` then
  `prcomp(..., scale. = FALSE)`). Say which columns were included.
- Axes are labelled with the percent of variance, from
  `summary(fit)$importance[2, ]`.
- Square coordinates. Dashed lines at zero.
- Colour is a known group, from `qualitative_hcl` (`colour-palettes.md`), not
  a continuous score, unless that score is the question.
- With a few groups, label each group directly and drop the legend. Use
  `ggforce::geom_mark_ellipse()` or `stat_ellipse()`.

```r
cols <- c("bill_length_mm", "bill_depth_mm", "flipper_length_mm", "body_mass_g")
penguins <- penguins[stats::complete.cases(penguins[cols]), ]
num <- scale(penguins[cols])
fit <- prcomp(num, center = TRUE, scale. = FALSE)
var <- summary(fit)$importance[2, 1:2] * 100
scores <- data.frame(fit$x[, 1:2], species = penguins$species)

ggplot(scores, aes(PC1, PC2, fill = species)) +
  geom_hline(yintercept = 0, linetype = "dashed", colour = "#1c2b24") +
  geom_vline(xintercept = 0, linetype = "dashed", colour = "#1c2b24") +
  geom_point(shape = 21, colour = "white", size = 3, alpha = 0.85) +
  ggforce::geom_mark_ellipse(aes(label = species), colour = NA) +
  colorspace::scale_fill_discrete_qualitative(palette = "Dark 3") +
  coord_equal(xlim = c(-4, 4), ylim = c(-4, 4)) +
  labs(
    title = "Gentoo separates from Adelie and chinstrap on size",
    x = sprintf("PC1 (%.1f%%)", var[1]),
    y = sprintf("PC2 (%.1f%%)", var[2])
  ) +
  theme_slide() +
  theme(legend.position = "none")
```

The limits above are an example. Set them from the scores so every point is
inside the panel.

## Other embeddings

UMAP, t-SNE, and similar maps are exploratory. The axis titles say the method
and the neighbour setting (or perplexity). Distances and areas on those axes
are not the original distances. Do not report a percent of variance for them.
A PCA panel remains the one that supports a claim about linear structure.
