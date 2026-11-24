# Observable JS (OJS) in Quarto: basics

References:
- https://quarto.org/docs/interactive/ojs/
- https://quarto.org/docs/interactive/ojs/ojs-cells.html
- https://quarto.org/docs/interactive/ojs/libraries.html
- https://quarto.org/docs/interactive/ojs/data-sources.html

OJS cells run in the browser with no server. They work in `format: html`,
websites, dashboards and `format: revealjs` (checked on 2026-11-15 with Quarto
1.10: Inputs, Plot, D3 and `ojs_define()` from R all rendered in a deck).

## Cells and options

````markdown
```{ojs}
//| echo: false
//| panel: sidebar
viewof n = Inputs.range([5, 200], {value: 30, step: 1, label: "n per group"})
```
````

- Options use `//|`. `echo`, `output` (`false`, `all`), `panel` (`sidebar`,
  `input`, `fill`, `center`), `code-fold`, `label` + `fig-cap` for a
  cross-referenced figure.
- `execute: echo: false` in the YAML also hides OJS source (Quarto keeps it in
  the HTML with class `hidden`).
- Cells may appear in any order: the runtime sorts them by the names they
  reference. A slider declared on slide 3 can drive a chart on slide 5.
- `viewof x = Inputs.*(...)` declares an input; other cells read `x`. Inputs:
  `range`, `select`, `radio`, `checkbox`, `toggle`, `text`, `search`, `table`,
  `button`.
- A block cell `name = { ...; return value; }` re-runs whenever a referenced
  name changes. `invalidation` is a promise that resolves just before the cell
  re-runs: release timers, listeners, React roots there.
- Tabs: put `{ojs}` cells under headings inside `::: {.panel-tabset}`.

## Libraries

Built in: the Observable standard library (`html`, `svg`, `md`, `width`,
`transpose`, `FileAttachment`), `Inputs`, `Plot`. Everything else is loaded:

```js
d3 = require("d3@7")                       // npm via jsDelivr, pin the version
jStat = require("jstat@1.9.6")             // UMD packages work with require()
import { aq, op } from "@uwdata/arquero"   // ES module by npm name
Plot2 = import("https://cdn.jsdelivr.net/npm/@observablehq/plot/+esm")
import { plotActors } from "./actors.js"   // local module, path from the .qmd
```

Local modules: use the static `import { f } from "./file.js"` form. A dynamic
`import("./file.js")` resolves against Quarto's `libs/quarto-ojs/` folder and
fails (seen in the 2026-11-15 prototype). In a website, list the file under
`resources:` so it is copied to `_site/`.

## Data from R or Python

````markdown
```{r}
ojs_define(cars = mtcars[, c("wt", "mpg")])
```

```{ojs}
Plot.plot({
  marks: [Plot.dot(transpose(cars), {x: "wt", y: "mpg"})],
  width: 600, height: 350
})
```
````

`ojs_define()` sends data frames column-wise; `transpose()` turns them into the
array of rows that Plot and D3 expect. Python: `ojs_define(data = df)` the same
way. Large data: write Parquet/CSV and load with `FileAttachment` or DuckDB
(`ojs-d3.md`, Mosaic section) rather than inlining it in the HTML.

## OJS in reveal.js

- All cells evaluate on load, not when their slide appears. Keep heavy
  simulations behind an input or a button.
- `width` follows the page, which in reveal.js is the scaled slide; set an
  explicit width/height (or `viewBox` for D3) so a chart fits the slide.
- `//| panel: sidebar` puts inputs beside the chart (the official Quarto demo
  deck does this). For a slider above a full-width chart, use two cells.
- Charts are SVG/HTML, so they scale with the slide; text inside a D3 `viewBox`
  scales too, so size fonts for the 1050×700 default canvas.
- `embed-resources: true` cannot inline libraries loaded at runtime by
  `require()`/`import` from a CDN; the deck still needs a network.

## Gotchas

- A name can be defined only once across the whole document.
- `viewof` is needed to read the value; without it you get the DOM element.
- Plot/D3 output must be returned (`return svg.node()`), not appended to a
  selector such as `#my_dataviz`.
- Errors show inline in red; check the browser console for the cell name.
