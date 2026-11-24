---
name: peer-review
description: >-
  Peer-review a manuscript (PDF, DOCX, .tex, .md). **Path A:** Open ScholarPeer
  in the paper folder (default). **Path B:** Firecrawl Research report only if
  Path A is insufficient. Not for systematic literature reviews.
---

# Peer review (tiered)

| Use | Do not use |
|-----|------------|
| Review, critique, or peer-review a supplied manuscript | Systematic reviews, topic surveys, grant brainstorming |
| Missing citations, methods currency, intro claims | Generic web search with no manuscript |

Shared rules: cite only papers returned by searches in the session; never invent
references; no identifiable patient data to web tools; flag author-name conflicts.

---

## Path A — Open ScholarPeer (do this first)

OSP ([open-scholar-peer](https://github.com/amirkiarafiei/open-scholar-peer), MIT)
runs the 7-step ScholarPeer protocol in the paper folder with keyless open
databases. Clone at `~/tools/open-scholar-peer`.

### Install in a paper folder

```bash
test -d ~/tools/open-scholar-peer || \
  git clone https://github.com/amirkiarafiei/open-scholar-peer ~/tools/open-scholar-peer
bash ~/tools/open-scholar-peer/install.sh --dir /path/to/paper --tool cursor \
  --sources arxiv,semantic_scholar,google_scholar,europepmc,openalex
```

Needs `python3` with venv (`sudo apt install python3.X-venv` if missing).

Expect: `.cursor/mcp.json` (`osp`, `markitdown`), `.cursor/commands/`, `.brain/`
(gitignored).

### Run (user in Cursor)

1. Reload window; allow MCP servers.
2. `/open-scholar-peer` → `/0-osp-onboarding` … `/6-osp-review`.
3. Draft in `.brain/review/` (traceable to `.brain/` sources).

| Source | Status |
|--------|--------|
| arXiv, Europe PMC, OpenAlex | usually works |
| Semantic Scholar | often 429 without free key in `.env` |
| Google Scholar | often blocked |

CLI: `.open-scholar-peer/mcp/.venv/bin/python .open-scholar-peer/mcp/osp_cli.py`

Update: `git -C ~/tools/open-scholar-peer pull`, rerun installer.

**Stop here** if OSP literature and review steps meet the user's goal.

---

## Path B — Firecrawl assistant (second tier only)

Use **only when**:

- Path A finished but literature is too sparse or blocked, **or**
- The user explicitly wants one Markdown report with Firecrawl Research checks.

Requires `user-firecrawl` MCP and `FIRECRAWL_API_KEY` when using cloud search.

### Phase 1 — Parse

Read PDF/DOCX via `firecrawl_parse`, **document-extraction** rule (anydoc → md),
or pasted text. Extract title, question, 2–4 load-bearing intro claims, methods,
findings. Flag **abstract-only** limits.

### Phase 2 — Literature (4–6 sequential searches)

`firecrawl_research_*` one at a time; ~1 s between calls. On failure: retry once;
after three failures, partial report with `[Search failed]`.

| # | Purpose |
|---|---------|
| 1 | Field consensus on central question |
| 2 | Verify one key intro claim |
| 3 | Citation completeness (recent years) |
| 4 | Methods currency |
| 5–6 | Optional extra claim or adjacent field |

**Integrity:** only cite papers from tool output; tag model memory as
`[Not from search — verify]`; zero hits = sparse coverage, not author vindication.

### Phase 3–4 — Report

Write `output/peer-review-<slug>.md`:

1. Summary  
2. Background and claims (quote, search, verdict)  
3. Missing citations (from searches only)  
4. Methods assessment  
5. Major / minor concerns  
6. Recommendation (Accept / Minor / Major / Reject)  
7. Audit log (queries, counts, failures)

Optional `pandoc` → DOCX. Pair **deslop** for `.tex` prose edits if asked.

### Phase 5 — Deliver

Short chat summary + path to report.

**Upstream for Path B:**
[stephenturner/skill-peer-review-assistant](https://github.com/stephenturner/skill-peer-review-assistant).