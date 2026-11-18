# Absolute positioning and images

Merged from: layout-absolute, layout-images. Each section keeps its own references.


## Absolute positioning

References:
- https://slidecrafting-book.com/layout
- https://quarto.org/docs/presentations/revealjs/advanced.html#absolute-position

The `.absolute` class places any element at exact coordinates, independent of content flow. Works on images **and** text.

### Attributes

| Attribute | Meaning |
|---|---|
| `width` / `height` | element size |
| `top` / `bottom` | distance from top / bottom edge |
| `left` / `right` | distance from left / right edge |

Use one of `top`/`bottom` and one of `left`/`right`. All accept any CSS length (`px`, `%`, `in`). Setting just one of `width`/`height` avoids distorting images.

### Images

```markdown
![](photo.jpg){.absolute top=0 right=0 height="100%"}
```

### Text

```markdown
[python is great]{.absolute bottom="45%" left="20%"}

[and so is R]{.absolute bottom="0%" right="0%"}
```

Or a whole block:

```markdown
::: {.absolute left="55%" top="55%" style="font-size:1.8em;"}
Be Brave
:::
```

### Bleeding past the slide edge

Reveal.js caps media at `max-width: 95%; max-height: 95%`. To exceed the frame, unset those and use negative offsets:

```markdown
![](photo.jpg){.absolute top="-10%" right="-10%" height="120%" style="max-height: unset; max-width: unset;"}
```

### Gotchas

- `0` is inside the slide; use negative values to overflow the edge.
- A perfect bleed is nearly impossible across all aspect ratios — make it work for the ratio you present at and move on.
- Pixel-tuning coordinates is tedious; use the `editable` extension to drag/resize in-browser (`slides-extensions.md`).

## Images

References:
- https://slidecrafting-book.com/layout
- https://quarto.org/docs/authoring/figures.html

Three ways to add images, in increasing control. For style images (reinforcing, not carrying content), prefer absolute or background.

### Basic figure

```markdown
![](photo.jpg){fig-align="right"}
```

Added as content: respects margins and pushes other content around. Fine for real figures, less so for decorative images.

### Absolute

Most control over position and size. See *Absolute positioning* above for the full attribute set and bleed technique.

```markdown
![](photo.jpg){.absolute top=0 right=0 height="100%"}
```

### Background

Simplest full-bleed option; set on the slide heading:

```markdown
## Slide Title {background-image="photo.jpg"}
```

Often best with an empty title and absolutely-positioned content:

```markdown
## {background-image="photo.jpg"}

[always explore]{.absolute left="50%" top="20%" style="rotate: -10deg;"}
```

More background options (size, position, video, iframe): `slides-backgrounds.md`.

### Gotchas

- Basic figures obey `max-width/height: 95%`; unset those for larger absolute images.
- Text placement over a background image changes the slide's whole feel — use it deliberately.
- For readable captions/text over a photo, add an overlay box (`slides-layout-text.md`).
