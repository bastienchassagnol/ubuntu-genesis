# Text layout: fit text, spread, overlay boxes

Merged from: layout-fit-text, layout-spread, layout-overlay-textbox. Each section keeps its own references.


## Big text with r-fit-text

References:
- https://slidecrafting-book.com/layout
- https://quarto.org/docs/presentations/revealjs/advanced.html#fit-text

`r-fit-text` scales text to fill the slide's horizontal space.

```markdown
::: {.r-fit-text}
Big Text
:::
```

Center it vertically too by combining with the `.center` slide class:

```markdown
## {.center}

::: {.r-fit-text}
This fits perfectly!
:::
```

### Multiple lines

One `r-fit-text` block sizes all its lines to the same (smaller) size set by the longest line:

```markdown
::: {.r-fit-text}
This fits perfectly!

On two lines
:::
```

For each line to independently fill the width, use one block per line:

```markdown
::: {.r-fit-text}
This fits perfectly!
:::

::: {.r-fit-text}
On two lines
:::
```

### Gotchas

- Within a single block, all text gets the same size (bounded by the longest line) — split into blocks for per-line scaling.

## Distributing bullets evenly (.spread)

References:
- https://slidecrafting-book.com/layout

A few short bullets clump at the top of a slide. `.spread` distributes them down the full vertical space with flexbox.

### SCSS

```scss
/*-- scss:rules --*/
.spread {
  --spread-padding: 0.5em;
  padding-top: var(--spread-padding);
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  align-items: flex-start;
}
.spread-evenly { justify-content: space-evenly; }
.spread-around { justify-content: space-around; }
```

### JavaScript (measures remaining height)

`spread-script.html`:

```html
<script type="text/javascript">
function updateSpreads() {
  document.querySelectorAll('.spread').forEach(el => {
    const section = el.closest('section');
    const paddingTop = parseFloat(getComputedStyle(el).paddingTop);
    el.style.height = (section.offsetHeight - el.offsetTop - paddingTop) + 'px';
  });
}
Reveal.on('ready', updateSpreads);
Reveal.on('slidechanged', updateSpreads);
</script>
```

```yaml
format:
  revealjs:
    include-after-body: spread-script.html
```

### Usage

```markdown
::: {.spread}
Think about how models work

Very valid for count data

We rarely care whether a predictor is normal
:::
```

Default `space-between` pins first to top, last to bottom. Use `.spread-evenly` for equal gaps including the edges.

### Gotchas

- `.spread` should be the **last** element on a slide — its JS-set height fills to the slide bottom, pushing later content off-screen.
- Override with an inline height for less than full space: `::: {.spread style="height:60%;"}`.
- Needs the `include-after-body` script; without it the flexbox has no height to distribute within.

## Readable text over busy photos

References:
- https://slidecrafting-book.com/layout

Text placed directly on a busy or high-contrast background image is often unreadable. Fix it with a semi-transparent box behind the text.

### Build it up

Start with absolute text (readable problem visible):

```markdown
## {background-image="photo.jpg"}

::: {.absolute left="55%" top="55%" style="font-size:1.8em;"}
Be Brave

Take Risks
:::
```

Add a translucent background and padding:

```markdown
::: {.absolute left="55%" top="55%" style="font-size:1.8em; padding: 0.5em 1em; background-color: rgba(255, 255, 255, .5);"}
Be Brave

Take Risks
:::
```

Polish into a frosted-glass card:

```markdown
::: {.absolute left="55%" top="55%" style="font-size:1.8em; padding: 0.5em 1em; background-color: rgba(255, 255, 255, .5); backdrop-filter: blur(5px); box-shadow: 0 0 1rem 0 rgba(0, 0, 0, .5); border-radius: 5px;"}
Be Brave

Take Risks
:::
```

- `background-color: rgba(...)` — translucency lets the image show through.
- `padding` — so the box is bigger than the text.
- `backdrop-filter: blur(5px)` — glass effect.
- `box-shadow` — depth.
- `border-radius` — softens corners.

### Gotchas

- This is CSS-heavy; move repeated overlays into a reusable class in `scss:rules`.
- On very light images use a dark rgba fill (`rgba(0,0,0,.5)`) with light text instead.
- Don't rely on `backdrop-filter` for print/PDF export — it may not render; keep the solid rgba fill as the fallback.
