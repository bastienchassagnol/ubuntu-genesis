# Team teaching material

Teaching resources for Anaïs Baudot’s team, published as a
[Quarto](https://quarto.org) website.

- **Site:** <https://bastienchassagnol.github.io/ubuntu-genesis/>
- **Repository:** <https://github.com/bastienchassagnol/ubuntu-genesis>

## Pages

| Page | Path |
|------|------|
| Welcome | [`index.qmd`](index.qmd) |
| Ubuntu general guidelines | [`ubuntu.qmd`](ubuntu.qmd) |
| Software to install | [`software.qmd`](software.qmd) |
| Network / Wi-Fi | [`network.qmd`](network.qmd) |
| OneDrive | [`onedrive.qmd`](onedrive.qmd) |
| R package guidelines | [`r.qmd`](r.qmd) |
| Git and GitHub | [`git.qmd`](git.qmd) |
| Modern LaTeX | [`latex.qmd`](latex.qmd) |

Figures, scripts, and PDFs live under [`assets/`](assets/). Shared Cursor, shell, and R configs stay in [`Config/`](Config/).

Build locally with `quarto render` (HTML lands in `docs/`, which is not committed). GitHub Actions publishes that output to GitHub Pages.
