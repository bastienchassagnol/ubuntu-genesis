# Line chart makeover, step by step

Source of the steps: React Graph Gallery, *Line chart design improvement*
(https://www.react-graph-gallery.com/example/line-chart-design-improvement).
The ggplot2 version below uses real data (`datasets::EuStockMarkets`) and the
house theme; it was run with R 4.6 and ggplot2 + ggrepel on 2026-11-15.

## The twelve steps

| # | Change | Why |
|---|---|---|
| 1 | Start from the default chart | baseline |
| 2 | Drop the legend; label each line at its end | no back-and-forth between legend and lines (#41, #42) |
| 3 | Drop the surrounding box (spine) | clutter, no information (#30) |
| 4 | Thin the grid | the gallery removes horizontal lines; the house style keeps a few light horizontal lines for reading values and drops vertical ones |
| 5 | No y title; put the unit on the ticks (`%`) | same information, less ink |
| 6 | Only meaningful x ticks (years); no x title | the axis is obviously time (#59) |
| 7 | Move the credit to a caption | it competed with the data in a corner |
| 8 | Title states the finding; subtitle says what is plotted | the reader gets the point first (#33) |
| 9 | Align title, subtitle, caption on one left edge | hierarchy and order (#28) |
| 10 | Add margins and breathing room | the chart stands out |
| 11 | Nudge overlapping end labels apart | labels stay readable (`ggrepel`, `direction = "y"`) |
| 12 | Grey the context, colour the one or two series that carry the story | guides the eye (#53) |

## ggplot2 code (before and after)

```r
library(ggplot2)

# theme_slide(): copy from the data-visualisation rule.

# Data: datasets::EuStockMarkets, daily closes 1991-1998, indexed to the first day.
x <- EuStockMarkets
d <- data.frame(
  time = rep(as.numeric(time(x)), ncol(x)),
  index = rep(c("DAX", "SMI", "CAC", "FTSE"), each = nrow(x)),
  change = as.vector(sweep(x, 2, x[1, ], "/") - 1) * 100
)

# Before: legend, box, dense grid, axis titles, generic title, credit in a corner.
before <- ggplot(d, aes(time, change, colour = index)) +
  geom_line() +
  annotate("text", x = 1998, y = 380, label = "Source: R datasets") +
  labs(title = "European stock indices", x = "Year", y = "Change") +
  theme_bw()

# After: the twelve steps.
hi <- c(SMI = "#c45c26", DAX = "#1d4e89")
d$hi <- d$index %in% names(hi)
last <- d[d$time == max(d$time), ]
after <- ggplot(d, aes(time, change, group = index)) +
  geom_hline(yintercept = 0, colour = "#1c2b24", linewidth = 0.3) +
  geom_line(data = d[!d$hi, ], colour = "grey75", linewidth = 0.6) +   # 12 context in grey
  geom_line(data = d[d$hi, ], aes(colour = index), linewidth = 0.9) +  # 12 two series carry the story
  ggrepel::geom_text_repel(                                            # 2 + 11 direct labels, nudged
    data = last, aes(label = index, colour = ifelse(hi, index, "other")),
    hjust = 0, nudge_x = 0.15, direction = "y", segment.colour = NA, size = 5
  ) +
  scale_colour_manual(values = c(hi, other = "grey55"), guide = "none") +  # 2 no legend
  scale_y_continuous(labels = function(v) paste0(v, "%"),                  # 5 % on ticks
                     breaks = seq(0, 400, 100)) +
  scale_x_continuous(breaks = 1992:1998, expand = expansion(mult = c(0, 0.08))) + # 6 meaningful ticks
  coord_cartesian(clip = "off") +
  labs(
    title = "Swiss and German shares outgrew Paris and London",      # 8 the title states the finding
    subtitle = "Change in daily closing index since mid-1991",
    caption = "Data: R datasets::EuStockMarkets",                    # 7 credit as a caption
    x = NULL, y = NULL                                               # 5, 6 no axis titles
  ) +
  theme_slide() +
  theme(
    panel.grid.major.x = element_blank(),                            # 3, 4 no spine, light grid
    plot.title.position = "plot", plot.caption.position = "plot",   # 9 one left edge
    plot.caption = element_text(colour = "grey45", size = 11, hjust = 0),
    plot.margin = margin(15, 40, 10, 15)                             # 10 breathing room
  )

ggsave("before.png", before, width = 9, height = 5, dpi = 150, device = ragg::agg_png)
ggsave("after.png", after, width = 9, height = 5, dpi = 150, device = ragg::agg_png)
```

Comments in the code give the step numbers. Adapt: compute the numbers that
justify the title (here SMI +357 %, DAX +236 %, CAC +125 %, FTSE +123 %) before
writing it.

## Interactive version

Same steps in OJS + D3: `quarto-revealjs/references/ojs-d3.md` (direct labels with
`svg.append("text")` at the last point, `d3.axisLeft(y).tickFormat(d => d + "%")`,
grey context lines drawn first, highlight series on top, hover to bring a grey
series forward).
