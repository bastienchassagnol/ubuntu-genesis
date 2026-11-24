---
name: deslop
description: >-
  Removes AI writing patterns (deslop, de-AI, make it sound human) from two
  genres: scientific manuscripts (LaTeX or Quarto: abstract, introduction,
  methods, results, discussion, captions, responses to reviewers) and package
  documentation (R vignettes, README, pkgdown articles, function-doc prose).
  **Auto-apply when editing LaTeX article source** (article/*.tex, manuscript
  .tex, sn-jnl drafts) and **vignettes** (vignettes/*.qmd, vignettes/*.Rmd,
  README.md, README.Rmd): rewrite prose only; leave macros, maths, \cite{},
  \ref{}, code chunks and tables untouched. Upstream: stephenturner/skill-deslop.
disable-model-invocation: false
---

# Deslop: remove AI writing patterns

Adapted from [stephenturner/skill-deslop](https://github.com/stephenturner/skill-deslop)
(MIT, see `LICENSE`). Section order, figure integrity and venue limits belong to
the `scientific-writing` rule; this skill is the executable prose-cleaning
procedure. Use British English unless the venue or repository requires American.

## Scope

1. Scientific papers: abstract, introduction, methods, results, discussion,
   captions, peer-review responses to reviewers of the paper.
2. Package documentation: vignettes, README, pkgdown articles, function-doc
   prose (roxygen descriptions, details, value sections).

Other genres (grants, blogs, memos, emails, cover letters, marketing) are out of
scope; do not apply the rules there.

## Auto-apply

- LaTeX articles (`article/*.tex`, manuscript `.tex`): deslop new or changed
  prose before finishing the edit; see [references/latex.md](references/latex.md).
- Vignettes and READMEs (`vignettes/*.qmd`, `vignettes/*.Rmd`, `README.md`,
  `README.Rmd`): deslop prose only; leave code chunks, YAML, chunk options,
  `@fig-`/`@tbl-` keys, links and output untouched.

## Workflow

1. **Detect.** Mark prose blocks that carry patterns from the catalogues:
   [references/vocabulary.md](references/vocabulary.md) (words and phrases) and
   [references/structures.md](references/structures.md) (sentence and paragraph
   patterns).
2. **Rewrite.** Replace each pattern with the specific content: the number,
   the actor, the source, the reason. If the specific content is not in the text,
   ask the author or leave a `[CHECK]` marker; never invent facts, numbers or
   citations. Keep meaning, claims, uncertainty and statistical wording
   (estimands, intervals, *P*-values) intact. See
   [references/examples.md](references/examples.md) for before/after pairs.
3. **Check.** Run the quick checks below and the scoring table; then confirm
   that maths, cites, labels, code and tables are byte-identical.

## Core rules

- Cut filler openers, announcements and emphasis crutches.
- Say the point directly; avoid "not X, but Y" contrasts unless X is a real,
  cited alternative.
- Be specific: name the quantity, method or source. Domain terms are fine;
  business buzzwords and AI vocabulary are not.
- Active voice by default, with "we" for the authors' own work and the
  package or function as subject in documentation. Passive is acceptable in
  Methods when the actor is the authors or is irrelevant.
- Cite named work; no "studies have shown" without a key.
- Vary sentence length; no em dashes; no bold-first bullets; no unicode arrows.
- State each point once; no signposted summaries ("In conclusion").
- Do not anthropomorphise models or data; do not casualise statistical
  reporting.

## Quick checks

- Adverbs or intensifiers doing no work? Cut them.
- Passive voice? Name the actor unless it is Methods and the actor is the
  authors or irrelevant.
- Inanimate thing with a human verb ("the data tell us")? Name the actor or
  restate.
- Throat-clearing ("It is worth noting", "Here's the thing")? Cut.
- "Not X, it is Y", or a self-posed question answered at once? State Y.
- Three similar sentences or exactly three items? Merge or use the true count.
- Vague declarative ("The implications are significant")? Name the implication.
- Meta-joiners ("In this section we will...")? Delete.
- Same claim made in several places? Keep one.
- Marketing adjectives in documentation ("powerful", "seamless")? Say what the
  function does.

## Scoring

Rate 1 to 10 on each; below 35/50, revise.

| Dimension | Question |
|-----------|----------|
| Directness | Statements or announcements? |
| Rhythm | Varied or metronomic? |
| Trust | Respects the reader's expertise? |
| Authenticity | Sounds like a specific author wrote it? |
| Density | Anything cuttable? |

## Reference files

- [references/vocabulary.md](references/vocabulary.md): words and phrases to cut or replace
- [references/structures.md](references/structures.md): sentence and paragraph patterns
- [references/examples.md](references/examples.md): manuscript and vignette before/after pairs
- [references/latex.md](references/latex.md): LaTeX and Quarto boundaries
