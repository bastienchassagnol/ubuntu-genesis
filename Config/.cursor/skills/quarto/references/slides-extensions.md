# Extensions: editable, codewindow

Merged from: extension-editable, extension-codewindow. Each section keeps its own references.


## Extension: editable (drag-to-reposition)

References:
- https://github.com/EmilHvitfeldt/quarto-revealjs-editable
- https://slidecrafting-book.com/layout

Reposition and resize elements directly in the browser while viewing slides, then copy the resulting CSS values back into your source. Invaluable for absolute positioning (`slides-layout-absolute.md`) and auto-animate layout (`slides-auto-animate.md`), where exact pixels are tedious by trial and error.

### Install

```bash
quarto add EmilHvitfeldt/quarto-revealjs-editable
```

```yaml
format:
  revealjs: default
revealjs-plugins:
  - editable
```

### Use

Click **Modify** in the deck menu (or mark elements `{.editable}`), drag/resize on the rendered slide; the extension outputs the coordinates to paste into the `.qmd`. Workflow: rough elements in, then nudge visually.

### Gotchas

- Still a little buggy — a prototyping aid, not a production feature.
- It reports values; you must paste them back into source to persist them.

## Extension: codewindow (IDE-window code blocks)

References:
- https://github.com/EmilHvitfeldt/quarto-revealjs-codewindow
- https://slidecrafting-book.com/codewindow

Wraps code blocks in a styled window frame with a file tab and language icon, like a modern editor.

### Install

```bash
quarto add emilhvitfeldt/quarto-revealjs-codewindow
```

```yaml
format: revealjs
revealjs-plugins:
  - codewindow
```

### Use

Wrap a code chunk in `::: {.codewindow}`; plain text above the chunk becomes the file-tab label:

````markdown
::: {.codewindow .r}
analysis.R

```r
mtcars |>
  dplyr::group_by(cyl) |>
  dplyr::summarize(mean_mpg = mean(mpg))
```
:::
````

Add a language class for the tab icon: `.r`, `.py`, `.js`, `.quarto`, `.html`, `.css`, `.sass`, `.julia`. Control width with `width`:

```markdown
::: {.codewindow .r width="80%"}
```

### Gotchas

- The file-tab label is the plain text line immediately inside the div, before the fence.
- Language icon comes from the class, not the code fence's language.
