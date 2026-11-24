# D3 and statistical playgrounds in OJS (the default interactive route)

References:
- https://d3js.org/ and https://observablehq.com/@d3/gallery
- https://d3-graph-gallery.com/ (search here first for an example)
- https://www.react-graph-gallery.com/ (React rendering, D3 maths: port to OJS)
- Official reveal.js demo with OJS: https://github.com/quarto-dev/quarto-web/tree/main/docs/presentations/revealjs/demo
- Dashboards with OJS and Mosaic: https://github.com/cscheid/quarto-dashboard-ojs-examples

Read `ojs-basics.md` first. Reach for D3 when Plot cannot express the chart:
custom marks, drag, brush, zoom, force layouts, animated transitions.

## Porting a d3-graph-gallery example

Gallery code appends to a page element (`d3.select("#my_dataviz").append("svg")`)
and fetches CSV with `d3.csv(url).then(...)`. In OJS:

1. `d3 = require("d3@7")` once in the document.
2. Load data in its own cell: `data = d3.csv(url, d3.autoType)` (OJS awaits
   promises) or `ojs_define()` from R.
3. Build a detached SVG and return its node:

```js
chart = {
  const W = 640, H = 360, M = {t: 20, r: 20, b: 30, l: 40};
  const svg = d3.create("svg").attr("viewBox", [0, 0, W, H]);
  // ... gallery body, with `svg` in place of the selected element ...
  return svg.node();
}
```

4. Replace hard-coded parameters with `viewof` inputs; the cell re-runs on change.
5. Keep house colours (`#1d4e89`, `#c45c26`, `#7a8b99`) and the dataviz rule.

## Minimal slide: slider + D3 bars

````markdown
## Interactive D3 chart

```{ojs}
d3 = require("d3@7")
viewof threshold = Inputs.range([0, 20], {value: 12, step: 1, label: "Maximum value"})
```

```{ojs}
chart = {
  const data = [4, 9, 13, 7, 16].filter(d => d <= threshold);
  const svg = d3.create("svg").attr("viewBox", "0 0 550 250");
  svg.selectAll("rect").data(data).join("rect")
    .attr("x", (d, i) => i * 95 + 20).attr("y", d => 220 - d * 12)
    .attr("width", 70).attr("height", d => d * 12).attr("fill", "#1d4e89")
    .append("title").text(d => `Value: ${d}`);
  return svg.node();
}
```
````

## Worked playground: two-sample t-test

Modelled on react-graph-gallery's t-test playground: three sliders, jittered
groups, live p-value. Seeded, so the same settings give the same picture.
Tested in a reveal.js deck on 2026-11-15.

````markdown
```{ojs}
//| panel: sidebar
d3 = require("d3@7")
jStat = require("jstat@1.9.6")
viewof n = Inputs.range([5, 200], {value: 30, step: 1, label: "n per group"})
viewof effect = Inputs.range([0, 5], {value: 1, step: 0.1, label: "Effect"})
viewof sd = Inputs.range([0.5, 6], {value: 3, step: 0.1, label: "SD"})
```

```{ojs}
//| panel: fill
sim = {
  const rng = d3.randomNormal.source(d3.randomLcg(42));
  const a = Array.from({length: n}, rng(0, sd));
  const b = Array.from({length: n}, rng(effect, sd));
  const se = Math.sqrt(d3.variance(a) / n + d3.variance(b) / n);
  const t = (d3.mean(b) - d3.mean(a)) / se;
  const p = 2 * (1 - jStat.studentt.cdf(Math.abs(t), 2 * n - 2));
  return {a, b, t, p};
}
ttestChart = {
  const W = 640, H = 360, M = {t: 30, r: 20, b: 30, l: 50};
  const y = d3.scaleLinear([-15, 20], [H - M.b, M.t]);
  const x = d3.scaleBand(["A", "B"], [M.l, W - M.r]).padding(0.4);
  const svg = d3.create("svg").attr("viewBox", [0, 0, W, H]);
  const jit = d3.randomUniform.source(d3.randomLcg(7))(-1, 1);
  for (const [g, vals, col] of [["A", sim.a, "#7a8b99"], ["B", sim.b, "#1d4e89"]]) {
    svg.append("g").selectAll("circle").data(vals).join("circle")
      .attr("cx", () => x(g) + x.bandwidth() / 2 + jit() * x.bandwidth() / 3)
      .attr("cy", d => y(d)).attr("r", 3)
      .attr("fill", col).attr("fill-opacity", 0.6);
  }
  svg.append("g").attr("transform", `translate(${M.l},0)`).call(d3.axisLeft(y));
  svg.append("g").attr("transform", `translate(0,${H - M.b})`).call(d3.axisBottom(x));
  svg.append("text").attr("x", M.l).attr("y", 18).attr("font-size", 16)
    .text(`p = ${sim.p.toPrecision(2)} ${sim.p < 0.05 ? "(significant)" : "(not significant)"}`);
  return svg.node();
}
```
````

With equal group sizes this is Student's two-sample t-test (df = 2n − 2);
with unequal sizes, switch to Welch degrees of freedom. Teaching
points: with SD 3 and effect 1, p moves across 0.05 as n changes; effect size
does not.

## Second pattern: drag points, watch R²

react-graph-gallery's "Why R² alone fails": draggable points, live fit.
Structure in OJS:

- `mutable pts = initial` holds the points; a dataset picker
  (`Inputs.select(["Linear", "Curve", "Outlier", "Bad repartition"])`) resets it.
- The chart cell draws circles with `d3.drag()`; on `end`, assign
  `mutable pts = updated` so dependent cells (fit, R², residual plot) re-run.
- Fit: `b = Σ(x−x̄)(y−ȳ)/Σ(x−x̄)²`, `R² = Sxy²/(Sxx·Syy)`.

The lesson for the slide: identical R² on the four datasets, different shapes.

## Pattern from the official Quarto demo deck

```js
//| panel: sidebar
viewof talentWeight = Inputs.range([-2, 2], {value: 0.7, step: 0.01, label: "talent weight"})
```

```js
//| panel: fill
import { plotActors } from "./actors.js";
plotActors(actors, talentWeight, looksWeight, minimum)
```

with `ojs_define(actors = data.frame(...))` in an R cell. Keep chart code in a
local `.js` module when it is long; the slide holds only the call.

## Large data: Mosaic / vgplot

For hundreds of thousands to millions of rows, D3 over an in-memory array
stalls the browser. Mosaic (`@uwdata/vgplot`) pushes filtering and binning to
DuckDB-WASM and redraws linked views from SQL aggregates; see `flights.qmd`
(10 million flights) in cscheid/quarto-dashboard-ojs-examples. This lowers the
computing cost more than switching the rendering layer to React would.

## Carousels with live charts

`quarto add emilhvitfeldt/quarto-easycarousel`; then `filters: [easycarousel, quarto]`
and a `::: {.carousel}` div. OJS cells inside hydrate normally and, in
reveal.js, carousel items step as fragments (README, not tested here).

## Gotchas

- Pin versions in `require()` (`d3@7`, `jstat@1.9.6`).
- Seed random generators (`d3.randomLcg(seed)`) so slides are reproducible.
- Give every SVG a `viewBox` so it scales with the slide.
- `d3.select("body")` or ids leak across cells and slides; select inside your
  own `svg`.
