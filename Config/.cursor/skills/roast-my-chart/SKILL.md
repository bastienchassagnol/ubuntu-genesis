---
name: roast-my-chart
description: >-
  Review a finished chart against the 55 Data to Viz caveats in the shared checklist and report what to fix.
  Use when the user roasts, critiques, audits or asks "what is wrong with my chart"
  before publishing. Image and/or ggplot2 code (R static figures in this bundle).
---

# Roast my chart

Review against every caveat in the shared checklist (nine sections, 55 caveats; map cards are not included) — do **not** duplicate the cards:

- Full text and ggplot2 snippets:
  `../data-visualisation/references/caveats.md`
- Publishing checklist: `data-visualisation` rule (`~/.cursor/rules/data-visualisation.mdc`)

Provenance: adapted from [holtzy/dataviz-skills/roast-my-chart](https://github.com/holtzy/dataviz-skills) (MIT).

## 1. Get the chart

- **Image:** read carefully (PNG, PDF, screenshot).
- **Code:** render if possible (`theme_slide()`, `ragg`/`svglite`); many caveats need the pixels (overplotting, contrast, labels).
- **Code only:** list caveats that need a render to verify.

Ask if the chart is cropped, data are missing, or the audience is unknown.

## 2. Describe the chart

Before judging, note chart type, channels (position, length, colour, size), groups, single vs small multiples, and the implied message from title/emphasis.

## 3. Check every caveat

Read **all** of `data-visualisation/references/caveats.md`. Walk the nine sections
(scales, bars, scatter, lines, colour, labels, typography and layout, several charts,
heatmaps). Each caveat is a bold name with a card number, a rule, and often an
`# avoid` / `# prefer` ggplot2 snippet:

- **Flag** when the chart or its code matches the `# avoid` pattern or breaks the stated rule and does not follow the `# prefer` pattern.
- **Skip** a section only with a reason (e.g. no heatmap in the figure).
- **Couldn't check:** missing data, n, or audience — list separately.
- Do not invent extra mistakes; one line at the end for serious issues outside the cards.

## 4. Write the roast

```markdown
## Roast

<One light line about the chart, not the author.>

**Verdict:** <single most important fix>.
Checked 55 caveats: <n> flagged, <n> N/A, <n> couldn't check.

## What to fix

### 🔴 <title>
**What I see:** <concrete: axis, bars, colours>
**Fix:** <applied fix; ggplot2 with theme_slide() if code shared>

### 🟠 …
## What works well
- …
## Couldn't check
- …
```

Order: 🔴 misleading → 🟠 hard to read → 🟡 polish. Keep "What I see" specific.

## 5. Offer to fix

When code was shared, fix in place with **`data-visualisation`** rule + `../data-visualisation/references/ggplot2-production.md`. Interactive Quarto fixes → **quarto-revealjs** (`ojs-d3.md`, `react-in-quarto.md`). Re-render and re-check flagged caveats.