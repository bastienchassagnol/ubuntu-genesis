# Choosing a chart from the data type

Source: Yan Holtz and Conor Healy, *From Data to Viz* decision tree
(https://www.data-to-viz.com, 2018 poster). Transcribed as text; the poster
image is not copied. House overrides from the `data-visualisation` rule are
marked **→**.

## Step 1: what is the data?

| Data | Go to |
|---|---|
| Only numeric variables | Numeric |
| Only categorical variables | Categoric |
| Categorical and numeric variables | Categoric and numeric |
| Links between entities, or a hierarchy | Relational |
| Geographic units or coordinates | Map |
| Values indexed by time | Time series |

## Step 2: what do you want to show?

The poster colours each chart by its purpose: **distribution**,
**correlation**, **ranking**, **part of a whole**, **evolution**, **map**,
**flow**. State the purpose in the title (rule: "the title says the finding").

## Numeric

| Shape | Candidates |
|---|---|
| One variable | histogram, density **→ raincloud (`ggdist`) when shape matters; try several bin widths (#51)** |
| Two, not ordered, few points | boxplot, histogram, scatter **→ scatter, square panel (#58); dashed guides and a few labels when a threshold split is the question (`annotated-scatter.md`)** |
| Two, not ordered, many points | violin, density, 2D density, marginal distribution **→ 2D density or hexbin for overplotting (#61)** |
| Two, ordered (one is like time) | connected scatter, area, line |
| Three, not ordered | boxplot, violin, bubble, 3D scatter/surface **→ bubble sized by area (#52); no 3D (#06). Three parts that sum to 1: ternary (`ternary.md`), not a radar chart** |
| Three or more, ordered | area, line, stacked area, streamgraph **→ lines or small multiples; stacked charts are hard to read (#57)** |
| Several, not ordered | boxplot, violin, ridgeline, correlogram, heatmap, PCA, dendrogram **→ heatmap rows clustered (#60); PCA as in `latent-projection.md`** |

## Categoric

| Shape | Candidates |
|---|---|
| One variable (counts) | waffle, barplot, lollipop, word cloud, circular packing, doughnut, pie, treemap **→ ranked barplot or lollipop (#12, #50); no pie or doughnut (#13). Treemap only for a hierarchy or for count and share together (`treemap.md`)** |
| Two or more, two independent lists | Venn diagram **→ UpSet beyond three sets (#56)** |
| Two or more, nested | barplot, circular packing, dendrogram, sunburst, treemap **→ treemap: area is the count, the label is the share (`treemap.md`)** |
| Two or more, subgroups | grouped scatter, heatmap, lollipop, parallel plot, spider plot, grouped barplot, stacked barplot, Sankey **→ dumbbell for two groups (#16); no spider plot. Exactly three closed parts: ternary (`ternary.md`)** |
| Two or more, adjacency | arc, chord, network, Sankey, heatmap |

## Categoric and numeric

| Shape | Candidates |
|---|---|
| One num + one cat, one value per group | waffle, barplot, lollipop, word cloud, circular packing, doughnut, pie, treemap **→ ranked lollipop; no pie (#13). Treemap when the number is a count inside a hierarchy (`treemap.md`)** |
| One num + one cat, several values per group | boxplot, violin, ridgeline, density, histogram **→ show the points: raincloud or box + jitter (#02)** |
| One cat + several num, no order | boxplot, violin, grouped scatter, 2D density, PCA, correlogram **→ PCA as in `latent-projection.md`** |
| One cat + several num, one num ordered | connected scatter, area, line, stacked area, streamgraph **→ highlight 1–2 series, grey the rest (#53)** |
| One cat + several num, one value per group | grouped scatter, heatmap, lollipop, parallel plot, spider plot, grouped/stacked barplot, Sankey **→ no spider plot. Exactly three numbers that close: ternary (`ternary.md`)** |
| Several cat + one num, subgroups | one value per group: as the row above; several values: boxplot, violin |
| Several cat + one num, nested | one value per group: barplot, circular packing, dendrogram, sunburst, treemap **→ treemap (`treemap.md`)**; several values: boxplot, violin |
| Several cat + one num, adjacency | heatmap, arc, chord, network, Sankey |

## Relational

| Shape | Candidates |
|---|---|
| Network (edges between nodes) | heatmap (adjacency matrix), hive, arc, chord, network, Sankey **→ adjacency heatmap past ~100 nodes; WebGL layout for thousands (`quarto-revealjs/references/react-in-quarto.md`)** |
| Hierarchy, no value or value on leaves | circular packing, dendrogram, sunburst, treemap, Sankey **→ treemap when the leaf value is a count (`treemap.md`)** |
| Hierarchy, value on edges | dendrogram, chord, Sankey |
| Hierarchy + extra connections | edge bundling |

## Map

Bubble map, choropleth, connection map, background map, hexbin map. Maps are
outside the house caveat list; normalise choropleth values by area or
population.

## Time series

| Shape | Candidates |
|---|---|
| One series | boxplot, violin, ridgeline (by period), area, line, barplot, lollipop **→ line on a true time scale (#09); readable date ticks (#59)** |
| Several series | boxplot, violin, ridgeline, heatmap, line, stacked area, streamgraph **→ line with direct labels (#41) or small multiples; see `line-chart-makeover.md`** |

## Clinical response

A waterfall of best percent change in target lesions, one bar per patient, is
not a branch of the tree above. Use it for a response listing
(`waterfall-clinical.md`). It is descriptive: survival stays on a Kaplan–Meier
curve.

## Gallery examples

Search https://d3-graph-gallery.com/<slug>.html (D3, ports to OJS),
https://www.react-graph-gallery.com (React + D3) and https://r-graph-gallery.com
(ggplot2). Checked D3 slugs: `histogram`, `density`, `boxplot`, `violin`,
`ridgeline`, `scatter`, `bubble`, `connectedscatter`, `density2d`, `heatmap`,
`correlogram`, `barplot`, `lollipop`, `spider`, `parallel`, `wordcloud`,
`treemap`, `dendrogram`, `circularpacking`, `line`, `area`, `stackedarea`,
`streamgraph`, `chord`, `network`, `sankey`, `arc`, `choropleth`, `bubblemap`,
`hexbinmap`, `connectionmap`, `backgroundmap`.
