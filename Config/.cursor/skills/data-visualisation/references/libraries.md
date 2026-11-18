# Libraries and galleries: the escalation ladder

Climb only as far as the figure needs. Each step costs more to build,
maintain and load than the one before.

| Step | Tool | Use when |
|---|---|---|
| 1 | `ggplot2` + `theme_slide()`, exported with `ragg` | every static figure (paper, slide, report) |
| 2 | `ggiraph` | hover, tooltips or linked hover on a ggplot in an HTML page; keep the static version |
| 3 | OJS + Observable Plot | reactive statistical graphics driven by sliders or selects, in pages and decks |
| 4 | OJS + D3 | custom marks, drag, brush, zoom, force layouts, teaching playgrounds |
| 5 | OJS + Mosaic/vgplot (DuckDB-WASM) | hundreds of thousands to millions of rows, linked views |
| 6 | React library inside Quarto (visx, Recharts, react-force-graph) | a feature or a canvas/WebGL speed-up that D3/Plot lack, or reuse of existing components |
| 7 | React/Next.js application | the output is an app (routing, URL state, auth), not a page or deck |

How-to for steps 3–6: the `quarto` skill (`references/ojs-basics.md`,
`ojs-d3.md`, `react-in-quarto.md`). Step 7: the
`react-and-nextjs-data-visualization` skill (OpenAI build-web-data-visualization
plugin, MIT), with `testing-data-visualizations` for test strategy. Never
start at 6 or 7.

## React libraries worth knowing

From https://awesomedataviz.com/categories/react/ (18 listed). Picks for
scientific figures and networks:

| Library | What it is | Use for | Licence |
|---|---|---|---|
| visx (`@visx/visx`) | low-level React primitives over D3 (scales, axes, shapes, glyphs, brushes), Airbnb | custom scientific figures you compose yourself | MIT |
| Recharts (`recharts`) | declarative chart components over D3 | standard line/bar/area charts fast | MIT |
| react-force-graph | 2D/3D/VR force-directed graphs on canvas/WebGL | large interactive networks | MIT |
| Semiotic | charts, network graphs, streaming data | mixed chart + network views | Apache-2.0 |
| react-plotly.js | React wrapper for Plotly.js | 3D surfaces, scientific chart types already in Plotly | MIT |
| nivo | rich prebuilt components, server rendering | dashboards | MIT |

Non-React equivalents to consider first for networks: `force-graph` (vanilla
version of react-force-graph), Sigma.js, Cytoscape.js; all load in OJS with
`require()` or `import`.

## Galleries to search first

- https://d3-graph-gallery.com: D3 by chart family (distribution,
  correlation, ranking, part of a whole, evolution, map, flow); ports to OJS.
- https://www.react-graph-gallery.com: React + D3, with design walk-throughs
  (line-chart makeover) and statistical playgrounds (t-test, R²).
- https://r-graph-gallery.com: ggplot2 equivalents.
- https://observablehq.com/@d3/gallery: official D3 examples.
- https://www.data-to-viz.com: decision tree and caveats behind
  `chart-chooser.md` and `caveats.md`.
