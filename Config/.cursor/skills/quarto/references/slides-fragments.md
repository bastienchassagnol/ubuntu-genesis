# Fragments and transitions

Merged from: animation-fragments, animation-transitions. Each section keeps its own references.


## Built-in fragments and incremental reveals

References:
- https://slidecrafting-book.com/fragments
- https://quarto.org/docs/presentations/revealjs/advanced.html#fragments
- https://revealjs.com/fragments/

A fragment is content that appears/animates on the forward key and reverses on back.

### Incremental lists

```markdown
::: {.incremental}
- thing 1
- thing 2
:::
```

Highlight only the current item by adding a class and styling `.current-fragment`:

```markdown
::: {.incremental .highlight-last}
- thing 1
- thing 2
:::
```

```scss
.highlight-last {
  color: grey;
  .current-fragment { color: #5500ff; }
}
```

### Built-in fragment effects

Add `.fragment` plus an effect class to any span or div:

```markdown
::: {.fragment .fade-in}
Appears on next press
:::

[highlighted]{.fragment .highlight-red}
```

Effect classes: `fade-in`, `fade-out`, `fade-up`/`down`/`left`/`right`, `fade-in-then-out`, `fade-in-then-semi-out`, `grow`, `shrink`, `strike`, `highlight-red`/`green`/`blue`, `highlight-current-red` (and current variants).

### Ordering

Control reveal order with `fragment-index`:

```markdown
[first]{.fragment fragment-index=2}
[second]{.fragment fragment-index=1}
```

### The three CSS stages

Custom CSS fragments hinge on three states, listed in this order (they cascade):

```scss
.reveal .slides section .fragment.my-name { }                   // always (pre-trigger look)
.reveal .slides section .fragment.my-name.visible { }           // once triggered
.reveal .slides section .fragment.my-name.current-fragment { }  // exactly when current
```

The default `before` style is `opacity: 0; visibility: hidden;`. To keep content visible before it fires, set both to `unset` in the first rule.

### Gotchas

- List the three rules in the order above — `.visible` and `.current-fragment` trigger together, so order controls the cascade.
- Avoid animating position/size in fragments; it causes jitter as elements reflow.
- Always handle the reverse direction (presenters go backward). For CSS transitions that's automatic; for JS fragments it isn't — see `slides-fragments-custom.md`.

## Slide and fragment transitions

References:
- https://quarto.org/docs/presentations/revealjs/advanced.html#slide-transitions

### Global transitions

```yaml
format:
  revealjs:
    transition: slide          # none, fade, slide, convex, concave, zoom
    transition-speed: default  # default, fast, slow
    background-transition: fade
```

### Per-slide transition

Override on the heading:

```markdown
## Slide {transition="zoom" transition-speed="fast"}
```

### Gotchas

- `none` or `fade` read as more professional for content-heavy talks; `zoom`/`convex` can feel gimmicky if overused.
- `background-transition` animates slide backgrounds independently of content.
- For elements that move/morph *between* slides rather than a whole-slide swap, use auto-animate (`slides-auto-animate.md`), not a transition.
