---
name: "quarto-website"
description: "Quarto websites (`project.type: website`): `_quarto.yml`, navbar, `site-url`, render lists, full-width figures, margin content, folded session info, GitHub corner. For reveal.js decks use quarto-revealjs instead."
---

# Quarto website (HTML site)

Index for `type: website` projects. Slides (`format: revealjs`) → **quarto-revealjs**.

| Task | Reference |
|---|---|
| Full-width figures, margin notes, folded session info, GitHub corner | `references/web-layout.md` |
| New site: static ggplot, OJS embed, Sphinx static assets | `references/interactive-embed.md` |

## `_quarto.yml` checklist

- `project.type: website` and `output-dir` (e.g. `docs/` for GitHub Pages).
- `website.site-url`, `repo-url`, `navbar.left` hrefs match rendered `.qmd` files.
- `project.render` lists only sources that should publish (exclude drafts).
- `format.html`: `code-tools`, `toc`, theme — once per project; `code-fold`,
  bibliographies and session info per the `quarto-presentations` and
  `documentation-bibliography` rules.

Official docs: https://quarto.org/docs/websites/