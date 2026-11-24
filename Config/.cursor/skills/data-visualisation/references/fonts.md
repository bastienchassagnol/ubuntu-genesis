# Fonts

Three separate jobs. A font package is not a graphics device, and a device is
not an installer.

| Job | What it is | What to use |
|---|---|---|
| Installation | Font files the project can see | `.ttf` or `.otf` in the project `fonts/` directory |
| Discovery | Which file matches a family name | `systemfonts` |
| Rendering | Drawing the glyphs | `ragg` for raster, `svglite` for vector |

Shaping (kerning, ligatures, complex scripts) is `textshaping`. `ragg` and
`svglite` call it. It is not a second installer and not a second discovery step.

Do not discover or register fonts with `showtext`, `sysfonts`, or `extrafont`.
Do not add `ggtext` for new figures.

Reading: [systemfonts workflow](https://systemfonts.r-lib.org/articles/systemfonts.html),
[add_fonts()](https://systemfonts.r-lib.org/reference/add_fonts.html),
[changelog](https://systemfonts.r-lib.org/news/index.html) (variable fonts),
[marquefy_theme()](https://marquee.r-lib.org/reference/marquefy_theme.html),
[geom_marquee()](https://marquee.r-lib.org/reference/geom_marquee.html).

## Installation

Keep the files in `fonts/` at the project root and ship that directory with
the project. An install into the operating system is optional. Compiling
`systemfonts`, `textshaping`, `ragg`, and `svglite` is assumed.

```text
my-r-project/
├── fonts/
│   ├── Inter-Regular.otf
│   └── Inter-Bold.otf
└── R/
```

## Discovery

On load, `systemfonts` runs `scan_local_fonts()`, which adds font files from
`./fonts` and `~/fonts`. Call `add_fonts()` when the files sit somewhere else.
Matching order is the registry (`register_font()`, `register_variant()`), then
these local files, then fonts installed on the machine.

Confirm the family before it goes into the theme. `match_fonts()` returns the
file it resolved, and it always resolves something, falling back to a generic
sans if the requested family is missing. Name the family you actually pass
in. The keywords `"sans"`, `"serif"`, and `"mono"` can map to different files
in `textshaping` than in the device, so do not leave the theme on a keyword
when a named family is available.

```r
slide_family <- function(preferred = NULL) {
  fonts <- systemfonts::system_fonts()
  roots <- paste0(normalizePath(c("fonts", path.expand("~/fonts")), mustWork = FALSE), "/")
  path_n <- paste0(normalizePath(fonts$path, mustWork = FALSE), "/")
  local <- fonts[Reduce(`|`, lapply(roots, function(root) startsWith(path_n, root))), ]
  families <- unique(local$family)

  if (is.null(preferred)) {
    if (length(families) == 1) return(families)
    if (length(families) > 1) {
      message(
        "Several families in fonts/. Using '", families[1],
        "'. Pass base_family to choose."
      )
      return(families[1])
    }
    if ("Noto Sans" %in% fonts$family) return("Noto Sans")
  } else if (preferred %in% fonts$family) {
    return(preferred)
  }

  hit <- systemfonts::match_fonts("sans")
  fallback <- unique(fonts$family[fonts$path == hit$path[[1]]])[1]
  requested <- if (is.null(preferred)) "project fonts/" else preferred
  message("Font '", requested, "' was not found. Using '", fallback, "'.")
  fallback
}

family <- slide_family()          # the one family in fonts/, or a named fallback
systemfonts::match_fonts(family)  # confirm the file
```

If the message prints, the figure uses that named family, and the script says so.

Variable axes (`font_variation()`, `register_variant()`) are only for a weight
or width between the named faces. Plain and bold files in `fonts/` are the
default.

## Rendering

Raster, as in the rule:

```r
ggsave(
  "figure.png", plot = p, device = ragg::agg_png,
  width = 8, height = 5, units = "in", res = 300, bg = "white"
)
```

Vector is SVG. Name the resolved sans in `system_fonts` so Inkscape does not
substitute Arial when the theme used the `"sans"` keyword:

```r
family <- slide_family()
svg_device <- function(filename, ...) {
  svglite::svglite(filename, ..., system_fonts = list(sans = family))
}
ggsave(
  "figure.svg", plot = p, device = svg_device,
  width = 8, height = 5, units = "in", bg = "white"
)
```

Do not draw with a PDF device. If a venue or LaTeX wants PDF, convert the SVG
afterwards: `inkscape f.svg --export-text-to-path --export-type=pdf`. An SVG may name the font without embedding its
bytes. A later machine needs the same `fonts/` files, or a conversion that
outlines the text.

## Plot text

Ordinary titles, axes, and labels need no extra text package:

```r
theme_slide(base_family = family)
```

Markdown, mixed faces in one string, a text box, or a legend that needs
markup: `marquee` only.

```r
p + marquee::marquefy_theme(theme_slide(base_family = family))
```

`marquefy_theme()` takes a complete theme and turns every text element into
`element_marquee()`. For one element, use `element_marquee()`. For data
labels, `geom_marquee()` replaces `geom_text()` and `geom_label()`. For a
legend blurb, `guide_marquee()`.
