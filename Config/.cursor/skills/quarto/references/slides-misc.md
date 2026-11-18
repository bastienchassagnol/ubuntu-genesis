# Hiding slides, includes, editor snippets

Merged from: misc-hiding-slides, misc-includes, misc-snippets. Each section keeps its own references.


## Hiding slides

References:
- https://slidecrafting-book.com/miscellaneous
- https://quarto.org/docs/presentations/revealjs/advanced.html#slide-visibility

Skip a slide during presentation without deleting it, via the heading attribute:

```markdown
## Slide Title {visibility="hidden"}
```

Useful for disclaimers or seasonal slides you toggle between deliveries: flip the attribute instead of cutting and re-pasting content.

Related: `visibility="uncounted"` keeps a slide in the deck but excludes it from slide numbering/count.

### Gotchas

- `hidden` slides are still in the HTML source (searchable, in the DOM); this is presentation-skipping, not access control.
- `uncounted` shows the slide but leaves it out of the total in `slide-number` (`slides-presenting.md`).

## Reusing content with includes

References:
- https://slidecrafting-book.com/miscellaneous
- https://quarto.org/docs/authoring/includes.html

Pull shared content into multiple decks with the include shortcode:

```markdown
{{< include _content.qmd >}}
```

It splices the file's content in place (copy-paste style) before rendering. Handy for intro/outro slides, a standard disclaimer, or a shared appendix across several talks. Works with `.qmd`, and also HTML and SVG files.

### Gotchas

- Convention: prefix included partials with `_` (e.g. `_intro.qmd`) so Quarto doesn't render them as standalone outputs.
- Includes happen before render, so the included file shares the parent's YAML/engine context — don't put a competing YAML header in the partial.

## VS Code / Positron Sass-variable snippets

References:
- https://slidecrafting-book.com/miscellaneous
- https://code.visualstudio.com/docs/editing/userdefinedsnippets

The reveal.js Sass variables are hard to remember. Project-scoped editor snippets surface them (with default values) as you type `$` inside `.scss` files.

Create `.vscode/<name>.code-snippets` at the project root. Each snippet triggers on the variable name and inserts the assignment with its default as a placeholder:

```json
{
  "colors - background": {
    "scope": "scss",
    "prefix": "$body-bg",
    "body": ["\\$body-bg: ${1:#fff};"]
  },
  "headings - h1 font size": {
    "scope": "scss",
    "prefix": "$presentation-h1-font-size",
    "body": ["\\$presentation-h1-font-size: ${1:2.5em};"]
  }
}
```

The book's miscellaneous chapter ships a full snippets file covering every compatible reveal.js Sass variable (colors, fonts, headings, code blocks, layout, callouts) — copy it wholesale from <https://slidecrafting-book.com/miscellaneous>.

### Gotchas

- Escape the leading `$` as `\\$` in JSON snippet bodies.
- `"scope": "scss"` limits them to SCSS files; they trigger once you type `$`.
- Keep them project-scoped (`.vscode/`) since they're presentation-specific.
