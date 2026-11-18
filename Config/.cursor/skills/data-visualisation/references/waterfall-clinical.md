# Clinical waterfall plots

A waterfall plot for a response study is one horizontal position per patient,
sorted from greatest tumour growth on the left to deepest shrinkage on the
right. It answers “how much did each patient’s target lesions change?”, and
nothing about survival. Read it with the response table and the Kaplan–Meier
curves.

The reading rules below are those on the Oncoflash “How to Read a Waterfall
Plot” figure (Stat Saturday): one bar per patient, percent change from
baseline, colour as best overall response, and dashed RECIST 1.1 guides.

## Axes and order

- The vertical axis is the best percent change from baseline in the sum of
  target lesions. Zero is no change. Up is growth. Down is shrinkage.
- Sort patients by that percent, growth first.
- Put *n* on the horizontal axis (patients 1 to *n*), not a patient identifier,
  unless the figure is a listing.
- Dashed guides at the thresholds the footnote names. For RECIST 1.1 those are
  +20% (progressive disease on target lesions) and −30% (partial response).
  Confirm the criteria in the footnote; do not assume RECIST when the protocol
  used another set.

## Colour is the response, not the bar height

Colour encodes best overall response, as a qualitative palette
(`colour-palettes.md`), with the category names in the legend:

| Response | Usual RECIST 1.1 reading |
|---|---|
| Progressive disease (PD) | At least +20% in the target sum, or new lesions, or non-target progression |
| Stable disease (SD) | Neither PD nor PR |
| Partial response (PR) | At least 30% decrease |
| Complete response (CR) | Disappearance of target lesions |

The colour can disagree with the bar height. A new lesion can make the best
response PD while the target sum shrinks. Do not recolour the bar to match
its height.

A journal that expects red for PD and green for CR may keep that convention
only with the words in the legend and a second channel (a label on each
response, or a shape for CR). Red against green fails deuteranopia and
disappears in greyscale (Hattab rules 8 and 10 in `colour-palettes.md`).

## What the plot does not show

The waterfall is descriptive. It does not show median progression-free or
overall survival, a hazard ratio, or a confidence interval. Do not compute
those from the bar heights.

The caption, or a companion table, reports:

- objective response rate, (PR + CR) / evaluable
- disease control rate, (SD + PR + CR) / evaluable
- the range of best percent change
- the depth of response (the deepest shrinkage)
- the number of complete responses

## Footnote

State the target-lesion definition, the measurement method, how missing
assessments were treated, how many patients were not evaluable (and that they
are absent from the bars), and *n*.

```r
waterfall <- waterfall[order(-waterfall$pct_change), ]
waterfall$patient <- seq_len(nrow(waterfall))
waterfall$best_response <- factor(
  waterfall$best_response,
  levels = c("PD", "SD", "PR", "CR")
)

ggplot(waterfall, aes(patient, pct_change, fill = best_response)) +
  geom_col(width = 0.8) +
  geom_hline(yintercept = c(20, -30), linetype = "dashed", colour = "#1c2b24") +
  colorspace::scale_fill_discrete_qualitative(
    palette = "Dark 3",
    name = "Best overall response"
  ) +
  scale_x_continuous(breaks = c(1, nrow(waterfall)), expand = c(0.01, 0.01)) +
  labs(
    title = "Most evaluable patients had a partial response",
    x = sprintf("Patients (n = %d)", nrow(waterfall)),
    y = "Best % change in sum of target lesions",
    caption = "Dashed lines: RECIST 1.1, +20% and \u221230%. Colour is best overall response, not the bar height."
  ) +
  theme_slide()
```

The title above is an example of a finding. Replace it with the finding in
the data. The caption’s criteria string must match the footnote.
