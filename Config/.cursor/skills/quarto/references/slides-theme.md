# Theme: fonts, colours, sizes

Merged from: theme-quickstart, theme-fonts, theme-colors, theme-sizes. Each section keeps its own references.


## The 10-minute theme

References:
- https://slidecrafting-book.com/10-minute
- https://quarto.org/docs/presentations/revealjs/themes.html

A complete, good-looking theme comes from three things: fonts, colors, sizes. Set them as Sass variables in `scss:defaults`. This gets you 90% of the way; escalate to `slides-theme-advanced.md` only when you outgrow variables.

### Setup

```yaml
format:
  revealjs:
    theme: [default, styles.scss]
```

```scss
/*-- scss:defaults --*/

/*-- scss:rules --*/
```

Variables go in `scss:defaults`; free-form CSS in `scss:rules`.

### Fonts (3 variables)

```scss
@import url('https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@100..700&family=Lato:wght@100;300;400;700&family=Space+Mono&display=swap');

$presentation-heading-font: "Josefin Sans", sans-serif;
$font-family-sans-serif:    "Lato", sans-serif;
$font-family-monospace:     "Space Mono", monospace;
```

`presentation-heading-font` falls back to `font-family-sans-serif` if unset. Detail: *Fonts* below.

### Colors (5 variables)

```scss
$body-bg:                    #1C1C2B;
$body-color:                 #bac2de;
$presentation-heading-color: #cba6f7;
$link-color:                 #fab387;   // also colors menu + progress bar
$code-color:                 #89b4fa;
```

Many other values (`$text-muted`, `$selection-bg`, `$border-color`) derive automatically from these. Detail: *Colors* below.

### Sizes (2-3 variables)

```scss
$presentation-font-size-root: 40px;   // scales almost everything
$presentation-h1-font-size:   80px;
$presentation-h2-font-size:   60px;
$code-block-font-size:        0.9em;
```

Most decks use text that is too small; size up. Detail: *Sizes* below.

### Gotchas

- `@import` for web fonts must come before the variables that use them, at the top of `scss:defaults`.
- If bold/italic don't render, you didn't request those weights/styles in the Google Fonts URL.
- When authoring a theme others will layer on, suffix variable definitions with `!default`.

## Fonts

References:
- https://slidecrafting-book.com/fonts
- https://fonts.google.com

### Finding fonts

Use [Google Fonts](https://fonts.google.com/); they're free and need no shipping. Look for a legible font that offers multiple weights and italics if you'll use them. [Font pairing](https://www.figma.com/google-fonts/) sites help choose a heading + body combo.

### Applying Google Fonts

Copy the `@import` from "Get embed code" into the top of `scss:defaults`, then set the variables:

```scss
/*-- scss:defaults --*/
@import url('https://fonts.googleapis.com/css2?family=IBM+Plex+Serif:ital,wght@0,400;0,600;1,400&display=swap');
@import url('https://fonts.googleapis.com/css2?family=Manrope:wght@200..800&display=swap');

$font-family-sans-serif:    'Manrope', sans-serif;
$presentation-heading-font: 'IBM Plex Serif', serif;
$font-family-monospace:     monospace;
```

Comma-separated names are fallbacks: if `Manrope` fails to load, the browser tries the next. Always end with a generic family (`sans-serif`, `serif`, `monospace`).

### Embedding local fonts

Use local fonts when you need offline decks, a non-web font, or faster load. Download `.woff`/`.woff2`, drop them beside the `.qmd`, and register with `@font-face`:

```scss
/*-- scss:defaults --*/
@font-face {
  font-family: 'FiraCode';
  src: url('../../../../../FiraCode-Regular.woff2') format('woff2'),
       url('../../../../../FiraCode-Regular.woff') format('woff');
}

$font-family-monospace: 'FiraCode';
```

Coding fonts with ligatures (like [FiraCode](https://github.com/tonsky/FiraCode)) render `!=`, `|>`, `->` as single glyphs.

### Gotchas

- **The `../../../../../` path is real.** Local `@font-face` URLs resolve from deep in the render tree; ~5 levels of `../` is typical when the font sits next to the `.qmd`. Adjust to your layout. ([quarto-cli#5712](https://github.com/quarto-dev/quarto-cli/issues/5712))
- Request every weight/style you use in the Google Fonts URL, or bold/italic silently won't work.
- `@import` lines must precede variable assignments.

## Colors

References:
- https://slidecrafting-book.com/colors
- https://quarto.org/docs/presentations/revealjs/themes.html#sass-variables

### Choosing a palette

Think in four roles: **background**, **text**, **highlight** (1-3 colors to draw the eye), **theme** (purely decorative). Aim for 3-6 colors total; be deliberate. Hunt palettes on Pinterest ("Pinterest color palettes" + a mood word like "sea", "pastel"), extract hexes with a picker like ColorSlurp.

### Contrast is the #1 rule

Background, text, and highlight colors must have **high contrast** with each other or the audience can't read the slides. Aim for a contrast ratio of ~12 (10 is acceptable). Check with <https://colourcontrast.cc/> or Coolors' contrast checker.

- Background and text end up quite dark and light as a result.
- Avoid pure black (`#000`) / pure white (`#fff`); they're harsh over time.
- Smaller/finer text needs even more contrast.
- Multiple highlight colors should be colorblind-safe with each other (e.g. avoid red/green pairs). The `prismatic::check_color_blindness()` R function helps.

### Applying colors

Set the three primaries and let derived values follow:

```scss
/*-- scss:defaults --*/
$body-bg:    #01364C;
$body-color: #F7F8F9;
$link-color: #99D9DD;   // also affects the menu button and progress bar
```

Better: name your palette as variables first, so intent is legible and edits are cheap:

```scss
/*-- scss:defaults --*/
$theme-darkblue: #01364C;
$theme-blue:     #99D9DD;
$theme-white:    #F7F8F9;
$theme-yellow:   #F4BA02;

$body-bg:    $theme-darkblue;
$body-color: $theme-white;
$link-color: $theme-blue;
```

Setting `$body-bg`, `$body-color`, `$link-color` auto-derives `$text-muted`, `$selection-bg`, `$border-color`, and more.

### Tweaking with Sass color functions

```scss
$presentation-heading-color: lighten($theme-yellow, 35%);
```

Iterate on the percentage until it pops the right amount.

### The full set

Five variables cover most needs: `$body-bg`, `$body-color`, `$presentation-heading-color`, `$link-color`, `$code-color`. For custom code token colors see `slides-code.md`; for storing a whole palette as a map see `slides-theme-advanced.md`.

### Gotchas

- `$link-color` also drives the hamburger menu and progress bar — pick one that reads on the background.
- Contrast is harder over images; use near-white on dark photos, near-black on light, and consider a text background/outline (`slides-layout-text.md`).

## Sizes

References:
- https://slidecrafting-book.com/sizes
- https://quarto.org/docs/presentations/revealjs/themes.html#sass-variables

Control sizing with Sass variables in `scss:defaults`. Most decks are too small — err large, especially for in-person audiences.

### The key variables

```scss
$presentation-font-size-root: 40px;   // base; nearly everything scales from this
$presentation-h1-font-size:   80px;
$presentation-h2-font-size:   60px;
$presentation-h3-font-size:   40px;
$presentation-h4-font-size:   32px;
$code-block-font-size:        0.9em;
```

- `$presentation-font-size-root` is the master dial: raise it and body, headings, and most spacing grow together.
- Heading variables set each level; most decks only need `h1`/`h2`.
- `$code-block-font-size` sizes code blocks and their output independently (use `em` so it tracks the root).

### Related

```scss
$presentation-line-height:         1.3;
$presentation-heading-line-height: 1.2;
$presentation-block-margin:        12px;
```

### Gotchas

- Because most sizes derive from the root, change it first and only override individual headings if the proportions feel off.
- Bigger code font can overflow — pair with `code-overflow: wrap` or `.scrollable` (`slides-overflow.md`).
- `em`-based sizes track the root; `px` sizes don't. Prefer `em` for things that should scale with the deck.
