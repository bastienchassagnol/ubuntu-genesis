# Plots on slides: transparent backgrounds and sizing

Merged from: content-plot-background, content-plot-sizing. Each section keeps its own references.


## Transparent plot backgrounds

References:
- https://slidecrafting-book.com/elements

Most plotting libraries default to a white background that sticks out on a non-white slide. Make the plot background transparent (`#FFFFFF00`) so it blends into any slide background, solid or not.

### base R and ggplot2

No code change — set chunk options:

````markdown
```{r, dev = "png", dev.args=list(bg="transparent")}
library(ggplot2)
ggplot(mtcars, aes(disp, mpg, color = factor(am))) +
  geom_point() +
  theme_minimal()
```
````

Or globally in YAML:

```yaml
knitr:
  opts_chunk:
    dev: png
    dev.args: { bg: "transparent" }
```

### matplotlib

Set both the axes and figure facecolor:

```python
fig = plt.figure()
plt.axes().set_facecolor("#FFFFFF00")   # inside the plotting area
plt.scatter(x, y, c=colors)
fig.patch.set_facecolor("#FFFFFF00")    # outside the plotting area
```

### seaborn

```python
sns.set_style(rc={'axes.facecolor':'#FFFFFF00',
                  'figure.facecolor':'#FFFFFF00'})
```

### Gotchas

- Prefer transparent (`#FFFFFF00`) over matching the slide color: one value, works across differently-colored or non-solid backgrounds.
- Transparency needs a format that supports alpha (`png`, `svg`), not `jpeg`.
- For auto-animate figures that live inside a colored element, theme the plot panel to that element's color instead (`slides-auto-animate.md`).

## Sizing figures for slides

References:
- https://slidecrafting-book.com/elements
- https://quarto.org/docs/presentations/revealjs/advanced.html#stretch

Two size concepts: the file on disk (`out-width`/`out-height`) and the drawing dimensions (`fig-width`/`fig-height`/`fig-asp`). Defaults tend to make on-plot text too small for audiences.

### auto-stretch

Slides default to `auto-stretch: true`, shrinking figures to fit. Disable globally or per slide:

```yaml
format:
  revealjs:
    auto-stretch: false
```

```markdown
## Slide {.nostretch}
```

The difference shows most when a figure shares a slide with other content: `auto-stretch` shrinks the figure to make room; `.nostretch` shows natural size (may overflow).

### fig-width / fig-height (the ones you'll use most)

Defaults are roughly `fig-width: 9`, `fig-height: 5`, which renders small text. Reduce them to enlarge on-plot text relative to the plot:

````markdown
```{r}
#| fig-width: 6
#| fig-height: 3.5
```
````

### fig-asp (fix the ratio, tune one dimension)

Set the height/width ratio once, then adjust only `fig-width`:

````markdown
```{r}
#| fig-asp: 0.5
#| fig-width: 7
```
````

Too small? raise `fig-width`, keep `fig-asp`. No decimal juggling.

### out-width / out-height

Control the on-disk/rendered file size — use when you want a figure that deliberately doesn't fill the slide:

````markdown
```{r}
#| out-width: 6in
#| out-height: 3.5in
```
````

### fig-align and fig-dpi

- `fig-align`: `left` / `center` / `right` (figures that don't fill the slide default to left).
- `fig-dpi`: raise if a chart looks blurry; costs file size, so only when needed.

### In columns

Even with a global setting, columns need per-slide tuning — usually a smaller `fig-asp` so the figure fits the narrower width.

### Gotchas

- `fig-*` controls the drawing; `out-*` controls the displayed/file size. They're different levers.
- Optimal numbers shift with titles, other slide content, fonts, and aspect ratio — expect per-slide adjustment.
- Bumping `fig-dpi` inflates file size; reach for it only to fix visible blur.
