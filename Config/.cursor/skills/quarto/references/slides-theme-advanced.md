# Advanced theming: SCSS, variants, menu button

Merged from: theme-scss-advanced, theme-variants, theme-menu-button. Each section keeps its own references.


## Advanced SCSS: maps, functions, @each, @mixin

References:
- https://slidecrafting-book.com/scss
- https://sass-lang.com/documentation

For themes that reuse colors, generate many utility classes, or repeat CSS. Start with `slides-theme.md`; come here when plain variables get unwieldy.

### CSS classes and the `.reveal .slide` prefix

Free-form rules go in `scss:rules`. Slide-content selectors need the `.reveal .slide` prefix to beat theme specificity:

```scss
/*-- scss:rules --*/
.reveal .slide a { text-decoration: underline; }
```

Utility text classes, applied inline with `[text]{.blue}` or to a block with `::: {.blue}`:

```scss
/*-- scss:rules --*/
.blue   { color: #219ea7; font-weight: bold; }
.yellow { color: #F4BA02; font-weight: bold; }
```

### Store the palette in a map

```scss
$colors: (
  "red":      #FA5F5C,
  "blue":     #394D85,
  "darkblue": #13234B,
  "yellow":   #FFF7C7,
  "white":    #FEFEFE
);
```

Quote the keys consistently (`"blue"`, not `blue`) — unquoted `yellow` etc. can be read as CSS color keywords.

### Pull values out with a function

```scss
@function theme-color($color) {
  @return map-get($colors, $color);
}

$body-bg:    theme-color("yellow");
$link-color: theme-color("blue");
$body-color: theme-color("darkblue");
```

### Generate classes with `@each` + interpolation

```scss
@each $name, $color in $colors {
  .text-#{$name} { color: $color; }
  .bg-#{$name}   { background-color: $color; }
}
```

Add a color to the map and every class set updates. Nested `@each` builds compound classes (only worth it for tightly-coupled pairs like gradients):

```scss
@each $n1, $c1 in $colors {
  @each $n2, $c2 in $colors {
    span.hl-#{$n1}-#{$n2}, .hl-#{$n1}-#{$n2} > h2 {
      background-image: linear-gradient(90deg, $c1, $c2);
      background-size: 100% 42%;
      background-repeat: no-repeat;
      background-position: 0 85%;
      width: fit-content;
    }
  }
}
```

### Avoid repetition with `@mixin` + `@for`

```scss
@mixin background-full {
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
}

@mixin theme-slide($number) {
  .theme-slide#{$number} {
    &:is(.slide-background) {
      background-image: url('../../../../../assets/slide#{$number}.svg');
      @include background-full;
    }
  }
}

@for $i from 1 through 3 { @include theme-slide($i); }
```

### Gotchas

- Maps aren't valid CSS on their own; they only do work through `map-get`/`@each`.
- Interpolation is `#{...}`; forgetting it means the literal variable name lands in the selector.
- Don't over-generate: skip compound classes like `.hl-green-bold` you'd never combine — make `.hl-green` and `.bold` separately.

## Theme variants and full slide themes

References:
- https://slidecrafting-book.com/theme
- https://sass-lang.com/documentation/style-rules#nesting

Two related ideas for consistent, low-effort decks: **variants** (a few restyled slide types) and **slide themes** (each slide picks a full pre-designed style).

### Variants

A variant is a reusable slide style you tag with a class. Classic example: an `inverse` dark slide for section breaks and quotes, alongside default slides. Also good for functional buckets (exercise/demo/results) or a red/yellow/green problem/solution/results arc.

Mark slides:

```markdown
## Slide

## Slide {.variant-one}

## Slide {.variant-two}
```

Style them in `scss:rules`, using nesting to keep it readable:

```scss
.variant-one {
  color: #d6d6d6;
  h1, h2, h3 { color: #f3f3f3; }
  a          { color: #00e0e0; }
  p code     { color: #ffd700; }
}

.variant-two {
  color: #a6a6d6;
  h1, h2, h3 { color: #222222; }
  a          { color: #f22341; }
  p code     { color: #ff00ff; }
}
```

Keep the un-tagged slide as the good default; only add `{.class}` when you want a different look. Worked examples: [quarto-revealjs-inverse](https://github.com/EmilHvitfeldt/quarto-revealjs-inverse), [quarto-revealjs-seasons](https://github.com/EmilHvitfeldt/quarto-revealjs-seasons).

### Full slide themes

Like a slide-layout dropdown in Google Slides: each slide class controls colors, sizes, backgrounds, even text position. Usage stays minimal:

```markdown
## Happy slides {.theme-title1 .center}

## Fancy Section {.theme-section3 .center}

## Funny title {.theme-slide1}

Content
```

Build each class up incrementally:

```scss
@mixin background-full {
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
}

.theme-slide1 {
  &:is(.slide-background) {
    background-image: url('../../../../../assets/slide1.svg');
    @include background-full;
  }
  h3 { color: $theme-blue; font-size: 2em; }
  // keep text off the background art:
  h2, h3, h4, h5, p, pre { margin-left: 100px; }
}
```

Backgrounds are typically SVGs but any image works. Worked examples: [earth](https://github.com/EmilHvitfeldt/quarto-revealjs-earth), [cinco-de-mayo](https://github.com/EmilHvitfeldt/quarto-revealjs-cinco-de-mayo). For behavior beyond CSS, a Lua extension can go further (e.g. Katie Masiello's PositConf 2023 theme).

### Gotchas

- Background-image on a slide goes through the `&:is(.slide-background)` selector, not the section itself.
- The `../../../../../assets/...` depth is real; adjust the number of `../` to your layout.
- Use `@mixin`/`@for` to avoid copy-pasting near-identical slide-class blocks.
- When background art occupies part of the slide, shift text regions with `margin-*` so they don't overlap.

## Restyling the slide menu button

References:
- https://slidecrafting-book.com/elements

The hamburger menu button (lower-left) takes its color from `$link-color`. To recolor it independently or swap the icon, override its background image in `scss:rules` — the color is hardcoded into the SVG.

### Recolor via inline SVG

The `fill="..."` inside the SVG sets the color:

```scss
.reveal .slide-menu-button .fa-bars::before {
  background-image: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="rgb(42, 118, 221)" viewBox="0 0 16 16"><path fill-rule="evenodd" d="M2.5 12a.5.5 0 0 1 .5-.5h10a.5.5 0 0 1 0 1H3a.5.5 0 0 1-.5-.5zm0-4a.5.5 0 0 1 .5-.5h10a.5.5 0 0 1 0 1H3a.5.5 0 0 1-.5-.5zm0-4a.5.5 0 0 1 .5-.5h10a.5.5 0 0 1 0 1H3a.5.5 0 0 1-.5-.5z"/></svg>') !important;
}
```

### Use any image

```scss
.reveal .slide-menu-button .fa-bars::before {
  background-image: url('https://.../icon.png') !important;
}
```

### Gotchas

- `!important` is required to override Quarto's default.
- For a simple recolor that matches links, just set `$link-color` and skip this entirely.
