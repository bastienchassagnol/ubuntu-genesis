---
name: peer-review-assistant
description: >-
  Structured critical peer review of a manuscript (PDF, DOCX, or pasted text).
  Runs targeted literature checks, missing-citation scan, and methods currency
  assessment. Use when the user asks to review, critique, or peer-review their
  paper or an uploaded PDF — formal or informal. **Do not** use for open-ended
  systematic literature reviews or topic surveys (use firecrawl-research-papers
  or firecrawl-research-index instead). Adapted from stephenturner/skill-peer-review-assistant
  for Cursor with Firecrawl Research MCP when available.
disable-model-invocation: false
---

# Peer Review Assistant (Cursor)

Produces a **structured review report** grounded in literature the agent can
verify in-session. It supports the reviewer; it does not replace domain expertise.

**Upstream:** [stephenturner/skill-peer-review-assistant](https://github.com/stephenturner/skill-peer-review-assistant).

## When to use / when not to

| Use | Do not use |
|-----|------------|
| "Review this manuscript", "critique my paper", "peer review this PDF" | "Literature review of X", "systematic review", "survey all papers on Y" |
| Check missing citations, methods currency, intro claims | Grant finder, research-question brainstorming only |
| PDF or DOCX the user supplies | Generic web search with no manuscript |

## Data integrity

- **Only cite papers returned by Firecrawl Research** (`firecrawl_research_*` MCP)
  or another search tool invoked in this session. Tag anything from model memory
  as `[Not from search — verify]` and exclude from citation counts.
- Confirm each search completed before relying on it. Log failures; never
  invent references.
- If a search returns zero hits, report sparse coverage — not proof the authors
  are correct.
- Note plan or result caps when the tool truncates results.

## Phase 1 — Parse the manuscript

Read the file (PDF/DOCX via `firecrawl_parse` MCP, `convert-documents-to-markdown`
skill, or user-pasted text). Extract:

- Title and authors
- Research question or hypothesis
- **2–4 load-bearing background claims** from the introduction
- Methods (design, data, models, metrics)
- Main findings and conclusions

If only an abstract is available, state **abstract-only** limits (especially
Methods).

Flag intro claims without citations as candidates for verification searches.

## Phase 2 — Literature searches (4–6, sequential)

Use **Firecrawl Research** MCP when `user-firecrawl` is enabled and
`FIRECRAWL_API_KEY` is set. Otherwise use `firecrawl_research_search_papers` /
CLI equivalents. **One search at a time**; pause ~1 s between calls.

| # | Purpose | Query pattern |
|---|---------|----------------|
| 1 | Field consensus on central question | Core topic as an academic question |
| 2 | Verify one key intro claim | Specific claim; recent years if dated |
| 3 | Citation completeness | Topic + method; last ~3 years |
| 4 | Methods currency | Method name + domain; last ~3 years |
| 5 | Optional second claim or controversy | If intro has another unsupported claim |
| 6 | Optional adjacent field | AI×bio, stats×ML, etc., if one side seems thin |

On failure: wait 3 s, retry once; after three consecutive failures, stop and
deliver partial report with `[Search failed]` markers.

## Phase 3 — Synthesize

**Tone:** constructive if the core is sound; direct if a flaw threatens
conclusions; note if out of scope for the target venue.

**Triage:**

- **Major (1–4):** validity, wrong test, contradicted central claim, missing
  seminal work that changes interpretation
- **Minor (2–6):** presentation, non-critical cites, terminology

Acknowledge strengths when searches support accurate framing or current methods.

## Phase 4 — Report (Markdown default)

Write `output/peer-review-<short-slug>.md` (or path the user gives) with:

1. **Summary** — what the paper does, main impression (2–3 sentences)
2. **Background and claims** — each checked claim: verbatim quote, search
   result, verdict (Accurate / Partial / Contradicted / Unverifiable)
3. **Missing citations** — only genuinely relevant papers from searches; link
   DOI or Firecrawl URL when available
4. **Methods assessment** — standard vs superseded; known limitations; metrics
5. **Major concerns** (numbered, specific remediation)
6. **Minor concerns** (numbered)
7. **Recommendation** — Accept / Minor revision / Major revision / Reject (+ one
   sentence justification)
8. **Audit log** — table of queries, filters, result counts, failures

Optional: export to DOCX with `pandoc` if the user requests Word.

Header note: literature checks used Firecrawl Research (or named tool) in this
session; audit log lists every query.

## Phase 5 — Deliver

Short chat summary: recommendation, count of major concerns, top missing cite
(if any), methods one-liner, path to the report file.

## Cursor-specific notes

- Manuscripts in this user's repos often live under `article/` (LaTeX). Pair with
  **deslop** if the user also wants prose de-AI'd in the source `.tex`.
- Do not upload identifiable patient data to web search tools; use redacted or
  public summaries only.
- **Conflict of interest:** if search hits repeatedly name an author on the
  manuscript, mention it so the user can disclose.
