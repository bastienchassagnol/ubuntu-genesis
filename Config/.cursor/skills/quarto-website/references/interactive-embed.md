# Quarto website: figures and interactivity

Adapted from the *new dataviz project* idea ([data-to-viz](https://www.data-to-viz.com/ai-skills/new-dataviz-project.html)) for **R + Quarto**, not a React starter.

## Default stack

1. **Static R** in each `.qmd`: `ggplot2` + `theme_slide()`, `echo: false`, `fig-width` / `fig-height`, `fig-cap:` with a finding.
2. **Publish:** `project.type: website`, `output-dir: docs` (GitHub Pages). See `web-layout.md` for full-width and margins.
3. **Reuse:** pre-rendered SVG/PNG under `figures/` when build time or cache matters.

## When to add OJS

Climb `data-visualisation/references/libraries.md`:

| Need | Mechanism |
|---|---|
| Hover on static-like chart | `ggiraph` in HTML |
| Sliders, brushing, live filters | `{ojs}` cells; start `quarto-revealjs/references/ojs-basics.md` |
| Custom D3 or animation | `ojs-d3.md`, `d3-animation-ojs.md` |
| React widget | Prebuilt bundle + OJS props (`react-in-quarto.md`) |

For **websites**, add JS bundles to `resources:` in `_quarto.yml` when not co-located with the `.qmd`.

## Sphinx (Python docs)

No in-doc plotting in this bundle. Embed **pre-rendered** R figures (or other assets) in `docs/_static/` and reference with `.. image::` or HTML. Keep one ggplot archival figure per claim.

## New site checklist

- `_quarto.yml`: `render:` list, `bibliography` split if needed (`documentation-bibliography` rule).
- Session block: folded `sessionInfo()` per `web-layout.md`.
- Inspiration pass (`dataviz-inspiration.md`) before first figure chunk.
- Roast before publish: **roast-my-chart** skill.