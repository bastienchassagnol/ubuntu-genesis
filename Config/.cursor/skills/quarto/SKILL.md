---
name: "quarto"
description: "Build Quarto HTML outputs: reveal.js slide decks (setup, SCSS themes, layout, code, plots, fragments and custom fragment JS, auto-animate persistent elements, speaker view, PDF export), websites and HTML pages (full-width figures, margin content, folded session info, GitHub corner), and interactive Observable JS (OJS) with Plot and D3, including statistical playgrounds and, only when justified, React components. Use for any `.qmd` with `format: revealjs` or `html`, a `_quarto.yml` website, or an `{ojs}` cell. Routes to focused files in references/."
---

# Quarto: slides, websites, interactive OJS

This file is an index. Pick the row that matches the task and read only that
reference. Each reference is self-contained and ends with gotchas.

Sources: https://slidecrafting-book.com, https://quarto.org/docs/presentations/revealjs/,
https://quarto.org/docs/interactive/ojs/, https://revealjs.com.

## Quick start

Deck (`deck.qmd` + `styles.scss`):

```yaml
---
title: "My talk"
format:
  revealjs:
    theme: [default, styles.scss]
execute:
  echo: false
---
```

```scss
/*-- scss:defaults --*/
/*-- scss:rules --*/
```

`##` starts a slide, `#` a section divider; `::: {.class}` and `[text]{.class}`
attach classes; slide attributes go on the heading
(`## Title {.center background-color="#222"}`). Preview with
`quarto preview deck.qmd`; render with `quarto render deck.qmd`.

## Slides: structure and theme

| Task | Reference |
|---|---|
| New deck, YAML scaffold, slide syntax, lists, callouts, tabsets | `references/slides-setup.md` |
| Title slide, footer, logo, banners | `references/slides-title-footer.md` |
| Backgrounds (colour, image, video, iframe) | `references/slides-backgrounds.md` |
| Content too long (`.smaller`, `.scrollable`) | `references/slides-overflow.md` |
| Theme in 10 minutes: fonts, colours, sizes | `references/slides-theme.md` |
| SCSS maps/mixins, theme variants, menu button | `references/slides-theme-advanced.md` |

## Slides: layout and content

| Task | Reference |
|---|---|
| Columns, side by side | `references/slides-layout-columns.md` |
| Absolute positioning, images | `references/slides-layout-absolute.md` |
| `r-fit-text`, `.spread`, readable text over photos | `references/slides-layout-text.md` |
| Floating paper-card slides | `references/slides-layout-paper-card.md` |
| Code: line highlights, unexecuted, hand-styled, syntax colours | `references/slides-code.md` |
| Terminal recordings (asciicast) | `references/slides-code-asciicast.md` |
| Plots: transparent background, sizing | `references/slides-plots.md` |

## Slides: motion and presenting

| Task | Reference |
|---|---|
| Built-in fragments, incremental lists, slide transitions | `references/slides-fragments.md` |
| Custom fragment effects (CSS states, JS events, reversal) | `references/slides-fragments-custom.md` |
| Persistent elements across slides (auto-animate) | `references/slides-auto-animate.md` |
| Speaker notes, speaker view, navigation, slide numbers | `references/slides-presenting.md` |
| PDF export, chalkboard, multiplex | `references/slides-export-live.md` |
| Extensions: `editable` (drag to place), `codewindow` | `references/slides-extensions.md` |
| Hide slides, includes, editor snippets | `references/slides-misc.md` |

## Websites and HTML pages

| Task | Reference |
|---|---|
| Full-width figures, margin notes, folded `sessionInfo()`, GitHub corner | `references/web-layout.md` |

## Interactive (OJS, D3, React)

Default to OJS + Plot, then OJS + D3. React only for a feature or a
canvas/WebGL speed-up that D3 lacks.

| Task | Reference |
|---|---|
| `{ojs}` cells, Inputs, `ojs_define()` from R, OJS in reveal.js | `references/ojs-basics.md` |
| D3 charts, porting gallery examples, t-test and R² playgrounds, Mosaic for big data | `references/ojs-d3.md` |
| React (visx, Recharts, force graphs) inside Quarto: when and how | `references/react-in-quarto.md` |

Chart choice, house theme and caveats: the `data-visualisation` skill and rule.

## Assets

- `assets/github-corner.html`: corner snippet (MIT), see `web-layout.md`.
- `assets/react-visx-bundle/`: tested React + visx → ES module template, see
  `react-in-quarto.md`.

## Rules of thumb

- One headline claim per slide; title → content → detail → attribution.
- Preview after every edit; overflow is the commonest failure.
- Most decks use text that is too small: size up. Dense decks: diagram labels
  18–20 px, section headers 14–16 px, body 12–13 px, metadata 10–11 px; below
  10 px, split the slide.
- Contrast between background, text and highlight colours matters more than
  any other choice.
- `theme: [default, styles.scss]`; Sass variables in `scss:defaults`, CSS in
  `scss:rules`; prefix slide CSS with `.reveal .slides section`.
- `echo: false` unless teaching code; keep citations when converting decks.
- Mermaid theme `sandstone` unless the deck sets another.
- Every custom fragment handles both directions (`fragmentshown` and
  `fragmenthidden`).
- Auto-animate: enough slides share the cast to feel intentional, not all.
- Native Quarto features before custom JS.
