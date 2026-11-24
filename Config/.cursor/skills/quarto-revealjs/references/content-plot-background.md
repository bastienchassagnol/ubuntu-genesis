# Plot backgrounds on slides

References:
- https://slidecrafting-book.com/elements
- `data-visualisation/references/ggplot2-production.md` (`theme_slide()`)

Static R figures use `ragg` (raster) on a white background, or `svglite` (vector), with `theme_slide()`. Do not use base `dev = "png"` with a transparent background: its anti-aliasing leaves halos on coloured slides.

## ggplot2

```yaml
knitr:
  opts_chunk:
    dev: ragg_png
    dev.args: { bg: "white" }
```

````markdown
```{r}
#| echo: false
library(ggplot2)
ggplot(mtcars, aes(disp, mpg, colour = factor(am))) +
  geom_point() +
  theme_slide()
```
````

Vector alternative: `dev: svglite`.

## Gotchas

- On a non-white slide, set the slide background to white for that slide (`{background-color="white"}`) or put the figure in a white card, rather than making the plot transparent.
- For auto-animate figures that live inside a coloured element, theme the plot panel to that element's colour instead (`animation-auto-animate.md`).
