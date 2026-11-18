# Choosing a colour palette

A repository palette wins. Otherwise classify the **mapped** variable, build
the palette in HCL with `colorspace`, look at the hex list on the matching
website, then walk the ten rules below. Details of the Holtz cards (#18–#27)
stay in `caveats.md`.

Source for the ten rules: Georges Hattab, Theresa-Marie Rhyne, and Dominik
Heider, “Ten simple rules to colorize biological data visualization”, *PLoS
Computational Biology* 16(10): e1008259, 2020.
<https://doi.org/10.1371/journal.pcbi.1008259>

## 1. Classify the mapped variable

| Mapped variable | Palette | Constructor |
|---|---|---|
| Nominal (species, lineage, response category) | Qualitative | `colorspace::qualitative_hcl()` |
| Ordinal, or interval/ratio with **no** meaningful centre (counts, marker intensity, a proportion from 0 to 1) | Sequential | `colorspace::sequential_hcl()` |
| Interval/ratio **after centring** at a pre-specified value (0, a baseline, a fold change of 1 on a log scale) | Diverging | `colorspace::diverging_hcl()` |

An ordered factor is sequential, not diverging, unless it has a neutral
category at the centre. Use `divergingx_hcl()` only when the two arms are
unequal (the centre is not halfway along the data range).

## 2. Build it in HCL

`colorspace` builds palettes in CIE LUV (HCL): hue, chroma, luminance. A step
in that space is closer to a perceived step than a step in RGB or HSV. Do not
build the scale with `rainbow()`, `heat.colors()`, or hand-picked pure red,
green, and blue.

```r
# nominal groups: hue varies, chroma and luminance stay flat
pal_group <- colorspace::qualitative_hcl(n, palette = "Dark 3")

# magnitude, no centre: luminance changes in one direction
pal_seq <- colorspace::sequential_hcl(n, palette = "Blues 3")
# or a multi-hue ramp that stays perceptually ordered:
pal_seq <- colorspace::sequential_hcl(n, palette = "Viridis")

# centred values: two hues, light neutral at the centre
pal_div <- colorspace::diverging_hcl(n, palette = "Blue-Red")
```

Named palettes are listed by `colorspace::hcl_palettes()`. On a ggplot, pass
the same name to the matching scale rather than interpolating the hex vector
yourself:

```r
scale_fill_discrete_qualitative(palette = "Dark 3")
scale_fill_continuous_sequential(palette = "Blues 3")
scale_fill_continuous_diverging(palette = "Blue-Red", mid = 0)
```

`scale_colour_*` has the same three suffixes. Set `mid` to the pre-specified
centre, not to whatever the sample mean happens to be, unless that mean is the
centre you declared.

Before trusting the legend, look at the palette in HCL:

```r
colorspace::hclplot(pal_group)   # qualitative hues should sit at one luminance
colorspace::specplot(pal_seq)   # sequential luminance should be monotone
colorspace::demoplot(pal_div, type = "heatmap")
```

## 3. Look at the hex list

After the constructor returns hex codes, open the site that matches the
palette class and compare. Say which site you used.

- Qualitative, especially when the default hues start to collide: [iWantHue](https://medialab.github.io/iwanthue/). It places colours in CIE Lab with distance, colour-blind, and softness constraints. Do not use it to invent a sequential ramp: it clusters hues, so the result has no luminance order.
- A named sequential, diverging, or qualitative catalogue: the [r-graph-gallery colour palette finder](https://r-graph-gallery.com/color-palette-finder). A palette taken from the finder still goes through `specplot()`. If its luminance is not monotone (sequential) or not peaked at a light centre (diverging), reject it and stay with the `colorspace` constructor.

## 4. Ten rules before the palette is final

Walk these in order. Stop and change the palette when one fails.

1. **Data type.** The class in the table above matches the mapped variable. A diverging palette on data that only runs from low to high invents a break.
2. **Colour space.** The palette was built in a perceptually uniform space (HCL / CIE Lab), not RGB or HSV.
3. **Palette class.** Qualitative hues do not suggest an order. A sequential palette uses one hue direction. A diverging palette uses two hues and a light neutral at the declared centre.
4. **Mapping.** On a light ground, higher values are darker. Qualitative sets stay at about six hues; more than that only when every extra category is also labelled directly. Missing cells are a neutral grey, not a hue from the scale.
5. **Context.** The same hex is checked on the background the figure will actually use (the white panel from `theme_slide()`, and paper white if it will be printed). A mark that disappears on white is the wrong colour, even if it was visible on a grey screen.
6. **Neighbours.** Adjacent hues must stay distinguishable. Do not put red text on a blue ground, and do not rely on a red/blue pair alone where the two meet along a long edge (simultaneous contrast). Annotations stay the dark guide colour from the rule (`#1c2b24`).
7. **Field convention.** A disciplinary convention (red for up-regulation, red/green for progressive disease and complete response) may be kept only if the legend spells the category in words. The convention does not replace the class in the table.
8. **Colour-vision deficiency.** Simulate the palette and reject a pair that collapses:

   ```r
   colorspace::swatchplot(
     original = pal_group,
     deutan = colorspace::deutan(pal_group),
     protan = colorspace::protan(pal_group),
     tritan = colorspace::tritan(pal_group)
   )
   ```

9. **Screen and print.** Marks and labels keep contrast on a white ground. Do not use pale yellow for a mark or for text on white. Do not assume an RGB hex will survive a CMYK conversion unchanged; check a print proof when the figure is for paper.
10. **Greyscale.** The finding is still readable with the colour removed. Sequential and diverging palettes already carry this in their luminance. A qualitative set does not: add a direct label, a shape, or a line type so a black-and-white copy still separates the groups.
