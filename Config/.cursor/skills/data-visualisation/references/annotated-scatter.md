# Annotated scatter

Use this when a scatter’s question is a split of the plane: a clinical cut-off,
or a median that is labelled as exploratory. The geometry is the quadrant
scatter in Loukas Theodosiou’s
[medical_quadrant.R](https://github.com/loukesio/tidytuesday/blob/main/2025/2025-04-08_TimelyEffectiveCare/medical_quadrant.R)
(TidyTuesday, 8 April 2025). That script loads fonts with `showtext`; this
module does not. Text uses `theme_slide()` (`fonts.md`).

## What to draw

- Dashed guides at the pre-specified splits. Name each region in words (what
  is high or low on each axis), not `Q1`–`Q4` alone.
- `ggrepel::geom_text_repel()` on a few extremes, not on every point. Set
  `seed` so the labels do not move between runs.
- Points as shape 21 with a white stroke, so neighbours stay separable.
- Size encodes a third variable only. Do not map the x or y variable to size
  as well.
- The title states the finding. A smoother is drawn only when the relationship,
  not the regions, is the question. Do not add a polynomial for decoration.
- When neither axis is time, keep the panel square (#58).

Region colour is qualitative (`colour-palettes.md`).

```r
split_x <- 200   # pre-specified, or median() and say so in the subtitle
split_y <- 70000

ggplot(plot_data, aes(wait_min, income)) +
  geom_vline(xintercept = split_x, linetype = "dashed", colour = "#1c2b24") +
  geom_hline(yintercept = split_y, linetype = "dashed", colour = "#1c2b24") +
  geom_point(aes(fill = region), shape = 21, colour = "white", size = 3) +
  ggrepel::geom_text_repel(
    data = extremes,
    aes(label = state),
    seed = 42,
    size = 3.5,
    colour = "#1c2b24",
    min.segment.length = 0
  ) +
  colorspace::scale_fill_discrete_qualitative(palette = "Dark 3") +
  labs(
    title = "Longer waits sit in both high- and low-income states",
    x = "Average wait (minutes)",
    y = "Median income"
  ) +
  theme_slide() +
  theme(legend.position = "bottom")
```

`extremes` is a small table: a couple of points at the edge of each region,
chosen by a stated rule (highest x, lowest y), not by which labels look tidy.
