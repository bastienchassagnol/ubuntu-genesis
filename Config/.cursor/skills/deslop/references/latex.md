# Deslop and LaTeX manuscripts

Apply deslop to **human-readable prose** in LaTeX sources. Do not rewrite
syntax the compiler needs.

## In scope

- `\section{}`, `\subsection{}`, `\paragraph{}` body text (outside maths)
- `abstract` environment narrative
- Figure and table `\caption{}` text (keep label keys unchanged)
- `\title{}`, author footnotes, cover-letter paragraphs in `.tex` or `.md`
- `article/main.tex` and included `\input{}` / `\include{}` chapter files

## Out of scope (never deslop)

- Preamble, package lines, `\newcommand`, `\newglossaryentry`, bib keys
- Maths: `$...$`, `\[...\]`, `equation`, `align`, `TikZ` node text that is notation
- `\cite{}`, `\ref{}`, `\label{}`, `\eqref{}`, cross-reference keys
- Table specs (`tabular`, `booktabs`), numeric results, column headers that are labels
- Comments starting with `%` unless the user asked to edit comment prose

## Workflow

1. Identify changed prose blocks in the diff or selection.
2. Deslop the English (British unless the manuscript is American).
3. Write back with **identical** LaTeX structure: same commands, cites, and labels.
4. If a sentence is awkward because of a required `\cite{}` mid-sentence, fix
   English around the cite — do not drop citations.

## Journal tone

For Nature/Springer-style methods articles: keep passive voice in Methods where
the journal expects it; deslop still removes AI tropes and filler. Do not
casualise statistical reporting (estimands, CIs, *P*-values stay precise).
