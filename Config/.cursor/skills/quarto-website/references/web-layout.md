# Website and HTML page tricks: full-width figures, margin, session info, GitHub corner

References:
- https://www.productive-r-workflow.com/quarto-tricks (source of these tricks)
- https://quarto.org/docs/authoring/article-layout.html
- https://quarto.org/docs/authoring/callouts.html#collapse

Applies to `format: html` and websites (not reveal.js, whose canvas is fixed).

## Full-width figures

```{r}
#| column: screen
#| out-width: 100%
#| fig-width: 12
#| fig-height: 4
ggplot(...) + theme_slide()
```

Column options, narrowest to widest: `body` (default), `body-outset`, `page`,
`page-inset`, `screen-inset`, `screen`. `-left`/`-right` variants exist
(`screen-inset-right`). The same classes work on divs for anything else:

```markdown
::: {.column-screen-inset}
![](figures/map.png)
:::
```

- Raise `fig-width` with the column, or the figure is upscaled and blurry.
- `column: screen` fits wide maps, heatmaps and OJS dashboards;
  `page` fits most wide plots.
- OJS cells take the same `//| column: page` option.

## Margin content

````markdown
```{r}
#| column: margin
tinytable::tt(mtcars[1:3, 1:3])
```

::: {.column-margin}
A side note next to the paragraph it explains.
:::
````

Also `fig-cap-location: margin`, `reference-location: margin`,
`citation-location: margin` in the YAML.

## Session info, folded

Policy is in the `quarto-presentations` rule; the folded block (native callout,
not a Bootstrap accordion):

````markdown
::: {.callout-note collapse="true" appearance="minimal"}
## Session information

```{r}
#| echo: false
sessionInfo()
```
:::
````

For a website, put this block in an include file (`_session-info.qmd`) and
add `{{< include _session-info.qmd >}}` at the end of each page.

## GitHub corner

An animated octocat linking to the repository, top-right of every page.
Asset: `assets/github-corner.html` in this skill (Tim Holman's
github-corners, MIT). Copy it next to `_quarto.yml`, replace `OWNER/REPO`, and
change `fill:#69b3a2` to the site colour.

```yaml
format:
  html:
    include-in-header:
      - file: github-corner.html
```

- On a website with a navbar, the corner can sit over the navbar's right
  edge; add `z-index: 2000` (and `position: fixed` to keep it while
  scrolling) to the `<svg>` style if it hides behind.
- Skip it on reveal.js decks: use the footer or a closing slide link.

## Gotchas

- Rendered and checked on 2026-11-15 (Quarto 1.10): screen-width figure,
  margin note, folded session info and corner on a page with a right TOC.
- Margin content collapses below the body on narrow screens; do not rely on it
  for essential information.
