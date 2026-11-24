# Quarto website: figures and interactivity

Adapted from the *new dataviz project* idea ([data-to-viz](https://www.data-to-viz.com/ai-skills/new-dataviz-project.html)) for **R + Quarto**, not a React starter.

## Default stack

1. **Static R** in each `.qmd`: `ggplot2` + `theme_slide()` (`ragg`/`svglite`), `echo: false`, `fig-width` / `fig-height`, `fig-cap:` with a finding.
2. **Publish:** `project.type: website`, `output-dir: docs` (GitHub Pages). See `web-layout.md` for full-width and margins.
3. **Reuse:** pre-rendered SVG/PNG under `figures/` when build time or cache matters.

## When to add OJS

Tool choice follows the interactive ladder in `data-visualisation/references/libraries.md`.
OJS how-to lives in the quarto-revealjs skill (`ojs-basics.md`, `ojs-d3.md`, `react-in-quarto.md`).

For **websites**, add JS bundles to `resources:` in `_quarto.yml` when not co-located with the `.qmd`.

## Sphinx (Python docs)

Embed **pre-rendered** R figures (or other assets) in `docs/_static/` and reference with `.. image::` or HTML. Keep one ggplot archival figure per claim.

## New site checklist

- `_quarto.yml`: `render:` list; bibliography and session info per the `documentation-bibliography` and `quarto-presentations` rules.
- Inspiration pass (`dataviz-inspiration.md`) before first figure chunk.
- Roast before publish: **roast-my-chart** skill.