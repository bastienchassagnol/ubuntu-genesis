# quarto skill

One router skill for Quarto HTML outputs: reveal.js decks, websites and HTML
pages, and interactive Observable JS. `SKILL.md` is a thin index; the agent
reads it, then loads the single file in `references/` that fits the task.

Built on 2026-11-15 by merging three skills (backup:
`~/.claude/backups/2026-11-15-quarto-dataviz.tar.gz`):

- `quarto-revealjs` (44 references, distilled from
  [slidecrafting-book.com](https://slidecrafting-book.com)) → 20 `slides-*` files (two also absorb the skills below)
- `quarto-revealjs-fragment` → `slides-fragments-custom.md`
- `auto-animate-elements` → `slides-auto-animate.md`

## Layout

| Prefix | Content |
|---|---|
| `slides-*` | reveal.js setup, theme, layout, code, plots, motion, presenting, export, extensions |
| `web-*` | website and HTML page layout tricks |
| `ojs-*` | Observable JS cells, D3, statistical playgrounds, Mosaic |
| `react-in-quarto.md` | when and how to embed React components (advanced) |
| `assets/` | `github-corner.html`; `react-visx-bundle/` template |

## Provenance and licences

- Slide material: Emil Hvitfeldt, *Slidecrafting*; Quarto and reveal.js docs.
- Website tricks: Yan Holtz, [productive-r-workflow.com/quarto-tricks](https://www.productive-r-workflow.com/quarto-tricks).
- `assets/github-corner.html`: Tim Holman,
  [github-corners](https://github.com/tholman/github-corners), MIT.
- t-test and R² playgrounds: modelled on
  [react-graph-gallery.com](https://www.react-graph-gallery.com) examples,
  rewritten for OJS + D3.
- React routes tested on 2026-11-15 with Quarto 1.10.18, React 18.3.1,
  visx 4.0.0, esbuild 0.28.2 (prototype rendered in headless Chrome).

## Cursor

`~/.cursor/skills/quarto` is a symlink to this folder; edit here only.
