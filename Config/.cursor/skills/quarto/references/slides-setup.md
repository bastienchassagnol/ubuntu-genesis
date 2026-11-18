# Deck setup and slide syntax

Merged from: core-setup, core-syntax. Each section keeps its own references.


## New deck setup

References:
- https://quarto.org/docs/presentations/revealjs/
- https://slidecrafting-book.com/10-minute

### Minimal deck

A deck is a single `.qmd`:

```yaml
---
title: "My talk"
author: "Your Name"
format: revealjs
---

## First slide

- point one
- point two

## Second slide

Content.
```

Render: `quarto render deck.qmd`. Live preview with reload: `quarto preview deck.qmd`.

### Recommended scaffold (with a theme)

Pair the deck with an SCSS file so styling has a home from the start:

```yaml
---
title: "My talk"
format:
  revealjs:
    theme: [default, styles.scss]
    slide-number: true
---
```

```scss
/*-- scss:defaults --*/
// Sass variables go here (fonts, colors, sizes)

/*-- scss:rules --*/
// Plain CSS / SCSS rules go here
```

`theme` takes a list: an optional built-in theme (`default`, `dark`, `solarized`, ...) followed by one or more stylesheets that layer on top. `theme: styles.scss` alone is also valid. See `slides-theme.md` to fill in the SCSS.

### Sensible defaults worth setting

```yaml
format:
  revealjs:
    theme: [default, styles.scss]
    slide-number: true
    incremental: false        # opt into incremental per-list instead
    code-line-numbers: true
    code-overflow: wrap
    fig-align: center
```

Bump font sizes early (most decks are too small) — see `slides-theme.md`.

### Sharing a single file

For a deck you email or upload as one file, add `embed-resources: true` (formerly `self-contained: true`) to inline all assets:

```yaml
format:
  revealjs:
    embed-resources: true
```

### Gotchas

- `embed-resources: true` suits a single deck shared as one file. Skip it when several decks in one project share a `libs/` folder, and note that it cannot inline OJS modules loaded at runtime from a CDN (`require()`/`import`), which still need a network connection.
- A `#` heading makes a section divider slide; `##` makes a content slide. Mixing them structures the deck.
- The title slide is auto-generated from YAML metadata; see `slides-title-footer.md` to customize or disable it.

## Slide syntax, lists, callouts, tabsets

References:
- https://quarto.org/docs/presentations/revealjs/
- https://quarto.org/docs/authoring/markdown-basics.html

### Slides from headings

- `## Title` starts a content slide.
- `# Title` starts a section-divider slide.
- Content is standard Markdown between headings.

Slide-level attributes live on the heading in `{}`:

```markdown
## My slide {.center background-color="#1C1C2B"}
```

### Fenced divs and spans

Attach classes/attributes to a block with a fenced div, to a run of text with a span:

```markdown
::: {.callout-note}
A block with a class.
:::

This is [important]{.highlight} text.
```

### Incremental lists

Reveal list items one at a time:

```markdown
::: {.incremental}
- first
- second
- third
:::
```

Or flip the default globally with `incremental: true` in YAML and use `::: {.nonincremental}` to opt individual lists out. To style the currently-revealed item, see `slides-fragments.md` (`.highlight-last`).

### Callouts

```markdown
::: {.callout-tip}
## Optional title
Body text.
:::
```

Types: `note`, `tip`, `important`, `caution`, `warning`. Colors are themeable via `$callout-color-*` Sass variables (see `slides-misc.md`).

### Tabsets

```markdown
::: {.panel-tabset}
## Tab A
Content A

## Tab B
Content B
:::
```

Advancing tabs with fragments is possible; see `slides-fragments.md`.

### Columns

Quick form (full detail in `slides-layout-columns.md`):

```markdown
::: {.columns}
::: {.column width="40%"}
Left
:::
::: {.column width="60%"}
Right
:::
:::
```

### Content overflow

- `## Title {.smaller}` shrinks text on a crowded slide.
- `## Title {.scrollable}` adds a scrollbar instead of overflowing.

### Gotchas

- Fenced divs need opening and closing `:::` on their own lines.
- `.column` divs must be nested inside a `.columns` div.
- Don't hand-position with absolute placement when a column or default flow will do; reach for `slides-layout-absolute.md` only when you need it.
