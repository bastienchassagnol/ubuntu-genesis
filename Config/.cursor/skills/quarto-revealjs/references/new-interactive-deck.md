# New interactive Quarto deck

Checklist when adding a reveal.js `.qmd` with data figures.

1. Scaffold: `references/core-setup.md` + `styles.scss` with `theme: [default, styles.scss]`.
2. **Inspiration:** `data-visualisation/references/dataviz-inspiration.md` (even for one slide).
3. **Per slide:** static ggplot (`theme_slide()`, `ragg`) unless the slide must explore — then one OJS cell, not both redundant.
4. Choice of tool: `data-visualisation/references/libraries.md` (interactive ladder).
5. Animate: `animation-fragments.md` + `d3-animation-ojs.md` (D3 transitions on `slidechanged`, not a separate React app).
6. Export: `present-pdf-export.md` after HTML looks right.

Site-wide figures for a teaching repo live in the **quarto-website** skill (`interactive-embed.md`).