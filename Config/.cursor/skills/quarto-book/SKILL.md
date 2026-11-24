---
name: "quarto-book"
description: "Quarto books (`project.type: book`): chapter order, `page-navigation`, split bibliographies, cross-references. For websites use quarto-website; for reveal.js use quarto-revealjs."
---

# Quarto book

Thin index for `type: book` projects. Slides and standalone websites have
dedicated skills; this file covers book-only YAML and navigation.

## `_quarto.yml` patterns

```yaml
project:
  type: book
  output-dir: _book

book:
  title: "Title"
  author: "Author"
  date: today
  chapters:
    - index.qmd
    - part: "Part title"
      chapters:
        - chapter01.qmd

bibliography:
  - bibliography/packages.bib
  - bibliography/REFERENCES.bib
link-citations: true
```

- Order `chapters` matches the pedagogical arc; one `.qmd` per chapter unless a
  part groups sections.
- Use `#sec-…`, `#fig-…`, `#tbl-…` labels; cite with `@sec-…` / `@fig-…`.
- `code-fold` under `format.html` like websites; slides are out of scope here.
- `page-navigation: true` when linear reading matters.

Official docs: https://quarto.org/docs/books/