# D3 maths in OJS (animations)

Aligned with [D3 + React AI skill](https://www.data-to-viz.com/ai-skills/d3.html): **D3 does scales, shapes and transitions; rendering stays in OJS SVG** (or React bundle only when necessary — `react-in-quarto.md`).

## Routing

Tool choice (static, OJS, D3, React): `data-visualisation/references/libraries.md`. Here: motion only.

| Goal | Where |
|---|---|
| Motion / enter-update-exit | This note + fragment replay |
| Custom marks, brush, drag | `ojs-d3.md` |
| WebGL / huge networks | React visx bundle in OJS (`react-in-quarto.md`) |

## Animation in OJS

```js
d3 = require("d3@7")
// Build with d3.create("svg"), bind data, then:
selection.transition().duration(600).attr("y", d => y(d.value))
return svg.node()
```

On **reveal.js**, expensive cells run at load — defer heavy work behind a button, or pause on `Reveal.on('slidechanged', …)` (see `ojs-d3.md` gotchas).

Pair with **fragments** (`animation-fragments.md`): reveal data in steps, then run a short transition on the last fragment.

## React compromise

Port [react-graph-gallery](https://www.react-graph-gallery.com/) **maths** to OJS first. Use the prebuilt ES module path only when OJS cannot hold state (WebGL, large component trees). D3 in `useEffect` + React DOM is for that bundle route, not the default Quarto page.

House colours: `#1d4e89`, `#c45c26`, `#7a8b99` (`data-visualisation` rule).