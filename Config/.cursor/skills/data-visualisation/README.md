# data-visualisation skill

Holds the long dataviz material so the path-loaded rule
`~/.claude/rules/data-visualisation.md` stays short. Created 2026-11-15
(backup of the previous rule: `~/.claude/backups/2026-11-15-quarto-dataviz.tar.gz`).

| File | Content | Source |
|---|---|---|
| `references/chart-chooser.md` | decision tree by data type, with house overrides | Holtz & Healy, *From Data to Viz* poster (2018), data-to-viz.com |
| `references/caveats.md` | nine caveat themes with ggplot2 snippets, moved verbatim from the rule | Holtz, *61 dataviz caveats* |
| `references/line-chart-makeover.md` | twelve-step makeover, tested ggplot2 code on `EuStockMarkets` | react-graph-gallery.com line-chart design improvement |
| `references/libraries.md` | escalation ladder, React libraries, galleries | awesomedataviz.com, d3/react/r graph galleries |
| `references/colour-palettes.md` | HCL qualitative, sequential, and diverging palettes, then ten colour rules | `colorspace`; Hattab, Rhyne, and Heider, PLoS Comput Biol, 2020, doi:10.1371/journal.pcbi.1008259; iwanthue; r-graph-gallery colour palette finder |
| `references/fonts.md` | project `fonts/`, systemfonts discovery, ragg and svglite rendering, marquee for rich text | systemfonts, textshaping, ragg, svglite, marquee |
| `references/annotated-scatter.md` | threshold guides and a few labels on a scatter | Theodosiou, `medical_quadrant.R` (TidyTuesday 2025-04-08) |
| `references/latent-projection.md` | scaled PCA; nonlinear embeddings labelled as such | Theodosiou, `PCA_penguins.R` (TidyTuesday 2025-04-15) |
| `references/treemap.md` | area = absolute count, label = share of parent | Theodosiou, `20251125_treemap.R`; r-graph-gallery treemap |
| `references/ternary.md` | exactly three parts that sum to 1 | Theodosiou, `20250401_pokemon.R` (TidyTuesday 2025-04-01) |
| `references/waterfall-clinical.md` | best percent change per patient, coloured by best overall response | Oncoflash, “How to Read a Waterfall Plot” (Stat Saturday) |

Related: **quarto-revealjs** (OJS, D3, React in decks); chart testing under
`references/testing/`.
(`~/.agents/vendor/openai-build-web-data-visualization/`, MIT).

`~/.cursor/skills/data-visualisation` is a symlink to this folder.
