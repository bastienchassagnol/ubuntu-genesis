---
name: "quarto-website"
description: "Quarto websites (`project.type: website`): `_quarto.yml`, navbar, `site-url`, render lists, full-width figures, margin content, folded session info, GitHub corner. For reveal.js decks use quarto-revealjs instead."
---

# Quarto website (HTML site)

Index for `type: website` projects. Slides (`format: revealjs`) → **quarto-revealjs**.

| Task | Reference |
|---|---|
| Full-width figures, margin notes, folded `sessionInfo()`, GitHub corner | `references/web-layout.md` |
| New site: static ggplot, OJS embed, Sphinx static assets | `references/interactive-embed.md` |

## `_quarto.yml` checklist

- `project.type: website` and `output-dir` (e.g. `docs/` for GitHub Pages).
- `website.site-url`, `repo-url`, `navbar.left` hrefs match rendered `.qmd` files.
- `project.render` lists only sources that should publish (exclude drafts).
- `format.html`: `code-fold`, `code-tools`, `toc`, theme — once per project.
- Split bibliographies when literature and software keys are separate
  (`documentation-bibliography` rule).

Official docs: https://quarto.org/docs/websites/