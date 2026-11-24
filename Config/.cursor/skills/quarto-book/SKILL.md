---
name: "quarto-book"
description: "Quarto books (`project.type: book`): chapter order, `page-navigation`, cross-references. For websites use quarto-website; for reveal.js use quarto-revealjs."
---

# Quarto book

Book-only YAML and navigation. Labels, `code-fold` and split bibliographies
follow the `quarto-presentations` and `documentation-bibliography` rules.

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
```

- Order `chapters` by the pedagogical arc; one `.qmd` per chapter unless a
  part groups sections.
- Cross-reference with `@sec-…`, `@fig-…`, `@tbl-…`.
- `page-navigation: true` when linear reading matters.

Official docs: https://quarto.org/docs/books/
