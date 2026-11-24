# React in Quarto (advanced, not the default)

References:
- D3 with React: https://d3js.org/getting-started#d3-in-react
- visx: https://visx.airbnb.tech (MIT) · Recharts: https://recharts.github.io (MIT)
- Catalogue: https://awesomedataviz.com/categories/react/
- qreacto: https://github.com/clearmatics/qreacto (MIT)
- quarto-svelte: https://github.com/jimjam-slam/quarto-svelte (MIT)

Tool choice: `data-visualisation/references/libraries.md`. D3 and Plot run
natively in Quarto pages and reveal.js decks; React needs an integration
layer. Most react-graph-gallery examples use React only to render and D3
modules (`d3-scale`, `d3-shape`, `d3-array`) for the maths, so they port to
OJS + D3 directly.

## When React is worth it

| Situation | Use |
|---|---|
| Standard or custom statistical chart, sliders, tooltips, brushing | OJS + Plot / D3 |
| Millions of rows, linked views | OJS + Mosaic/vgplot (DuckDB-WASM) |
| Large network (thousands of nodes) needing canvas/WebGL | React: `react-force-graph`; or `force-graph` / Sigma.js without React |
| Composable scientific figure from typed primitives (axes, glyphs, brushes, annotations) reused across many pages | React: visx |
| Quick standard charts inside an existing React component library | React: Recharts |
| A full app (routing, URL state, auth) rather than a page or deck | Dedicated React/Next app — not this skill |

React does not make the maths faster. It pays off when a library supplies a
feature (WebGL network layout, visx primitives) or when you reuse components
that already exist.

## Route 1 (recommended): prebuilt ES module + OJS props

Tested on 2026-11-15 in a reveal.js deck (Quarto 1.10, React 18.3.1, visx
4.0.0, esbuild 0.28.2): 60 points and the R² label rendered, and the slider
re-rendered without remounting. Template:
`assets/react-visx-bundle/` (`src/qviz.jsx`, `package.json`).

```bash
cp -r ~/.claude/skills/quarto-revealjs/assets/react-visx-bundle viz && cd viz
npm install && npm run build            # writes qviz.js next to package.json
cp qviz.js ../                           # next to the .qmd
```

The module exports `mount(el)` returning `{render(props), unmount()}`. In the
`.qmd`:

```js
import { mount } from "./qviz.js"        // static import: path from the .qmd

viewof noise = Inputs.range([0, 5], {value: 1, step: 0.1, label: "Noise"})

points = {
  const rng = d3.randomNormal.source(d3.randomLcg(1))(0, 1);
  return d3.range(60).map(i => ({x: i / 6, y: 1 + i / 6 + noise * rng()}));
}

vizBox = {                               // mounted once
  const el = html`<div></div>`;
  el.viz = mount(el);
  invalidation.then(() => el.viz.unmount());
  return el;
}

{ vizBox.viz.render({points}); return md``; }   // re-renders on every input change
```

- Mount in one cell and render in another, so React keeps its state while OJS
  values flow in as props.
- `import("./qviz.js")` (dynamic) fails: it resolves against Quarto's
  `libs/quarto-ojs/` folder. Use the static `import ... from`.
- Websites: add `qviz.js` to `resources:` in `_quarto.yml`.
- Inside the component, follow D3's rule: use d3-scale/d3-array/d3-shape (or
  visx, which wraps them) in JSX; touch the DOM with d3-selection, d3-axis or
  d3-transition only through a `useRef` + `useEffect`.

## Route 2: esm.sh + htm inside OJS (prototypes)

No build step, no JSX (`htm` tagged templates). Tested on 2026-11-15; needs a
network at view time.

```js
React = import("https://esm.sh/react@18.3.1")
ReactDOMClient = import("https://esm.sh/react-dom@18.3.1/client?deps=react@18.3.1")
htm = (await import("https://esm.sh/htm@3.1.1")).default
visxScale = import("https://esm.sh/@visx/scale@4.0.0?deps=react@18.3.1")
h = htm.bind(React.createElement)

esmBox = {
  const el = html`<div></div>`;
  el.root = ReactDOMClient.createRoot(el);
  invalidation.then(() => el.root.unmount());
  return el;
}

{
  const x = visxScale.scaleLinear({domain: [0, 10], range: [20, 620]});
  esmBox.root.render(h`<svg width="640" height="80">
    ${points.map((p, i) => h`<circle key=${i} cx=${x(p.x)} cy="40" r="4" fill="#c45c26" />`)}
  </svg>`);
  return md``;
}
```

Pin every version and pass `?deps=react@…` so all packages share one React.

## Route 3: qreacto shortcode (not tested here)

`quarto add clearmatics/qreacto`; put `Hello.jsx` in `_components/` and write
`{{< react Hello >}}`. From its README and source: Babel compiles JSX in the
browser (babel.min.js is 2.9 MB), it mounts with the legacy `ReactDOM.render`, there is no
binding to OJS values, arrow functions and named imports are unsupported,
external modules must be CDN ES modules, and reveal.js is not mentioned. Use it
only for a self-contained widget; prefer route 1.

## Other architectures

- Svelte instead of React: `quarto-svelte` binds compiled components to OJS
  (`myCircles.data = newData`), the cleanest component↔OJS bridge available.
  Install with `quarto use template jimjam-slam/quarto-svelte` + `npm install`.
- React-first projects: Observable Framework supports JSX pages (separate from
  Quarto OJS; cells do not port unchanged); reveal.js can be driven from React
  outside Quarto. Both leave the Quarto workflow, so use them only when the
  output is an application.

## Gotchas

- One React per page: mixing a bundle and esm.sh copies breaks hooks.
- Unmount on `invalidation`, or roots leak each time a cell re-runs.
- In reveal.js all cells run on load; mount heavy WebGL views behind a button
  or pause them on `slidechanged`.
- `embed-resources: true` was not tested with these routes; esm.sh imports need a network either way.
