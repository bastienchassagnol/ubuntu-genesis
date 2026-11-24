# deslop

A Claude skill for removing AI writing patterns from scientific manuscripts and package documentation.

Vendored and adapted from [stephenturner/skill-deslop](https://github.com/stephenturner/skill-deslop) (MIT, see `LICENSE`).

## What it does

`deslop` identifies and removes predictable AI tells (filler phrases, formulaic
structures, false agency, vague declaratives, marketing adjectives) in two
genres only:

- scientific papers in LaTeX or Quarto (abstract, introduction, methods,
  results, discussion, captions, responses to reviewers);
- package documentation (R vignettes, README, pkgdown articles, function-doc
  prose).

It leaves maths, `\cite{}`, `\ref{}`, code chunks and tables untouched. Active
voice is the default; passive is acceptable in Methods when the actor is the
authors or irrelevant.

## Installation

**Option 1: Download ZIP**

Click the green **Code** button at the top of this repo, then **Download ZIP**. Extract the ZIP and add the folder to your Claude skills directory.

**Option 2: Releases**

Go to the [Releases](https://github.com/stephenturner/skill-deslop/releases) page and download the latest `.skill` file. Add it to your Claude skills in [customize/skills](https://claude.ai/customize/skills) on the web, or double-click it if you have Claude Desktop installed.

**Option 3: Build it yourself**

Build a `.skill` file from the source code, then add it to your Claude skills as described above.

```sh
git clone https://github.com/stephenturner/skill-deslop.git
cd skill-deslop
zip -r deslop.skill SKILL.md references/
```

## How to use it

The skill triggers when you ask Claude to "deslop", "de-AI" or "make it sound
human" for a manuscript or package documentation, and automatically when editing
LaTeX article sources or `vignettes/*.qmd|Rmd`, `README.(R)md`. You can also ask
for a review against the checklist or a score on the rubric.

## Scoring rubric

The skill includes a 1-10 scoring rubric across five dimensions:

| Dimension | Question |
|-----------|----------|
| Directness | Statements or announcements? |
| Rhythm | Varied or metronomic? |
| Trust | Respects reader intelligence? |
| Authenticity | Sounds like a specific human wrote it? |
| Density | Anything cuttable? |

Below 35/50: revise.

## Skill structure

```
deslop/
├── SKILL.md              # Scope, workflow, core rules, quick checks, scoring
├── README.md             # This file
├── LICENSE               # MIT (upstream)
└── references/
    ├── vocabulary.md     # Words and phrases to cut or replace
    ├── structures.md     # Sentence and paragraph patterns
    ├── examples.md       # Manuscript and vignette before/after pairs
    └── latex.md          # LaTeX and Quarto boundaries
```

## Acknowledgments

This skill was built in part by combining and synthesizing material from two open sources:

- **AI writing tropes catalog** from [tropes.fyi](https://tropes.fyi/) by [Ossama Hassanein](https://ossama.is). Its patterns are merged and deduplicated into `references/vocabulary.md` and `references/structures.md`.
- **stop-slop** from [github.com/hardikpandya/stop-slop](https://github.com/hardikpandya/stop-slop) by [Hardik Pandya](https://hvpandya.com). The phrase lists, structural patterns, before/after examples, scoring rubric, and quick checks draw from this project.

## License

MIT
