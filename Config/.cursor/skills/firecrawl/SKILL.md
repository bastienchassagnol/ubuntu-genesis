---
name: firecrawl
description: >-
  Web search, scrape, crawl, and document parsing via Firecrawl. Install skills
  from the official GitHub repo rather than vendoring dozens of sub-skills in
  teaching_material. Use for literature checks, docs mirroring, and QA — not for
  inventing citations.
---

# Firecrawl (install from upstream)

This teaching bundle **does not** ship the full Firecrawl skill family (30+
`firecrawl-*` folders). Install from the official repositories when you need
live-web tooling.

## Recommended setup

1. **CLI and MCP** — [Firecrawl](https://github.com/firecrawl/firecrawl):
   follow the README for API key (`FIRECRAWL_API_KEY` in user environment,
   never in Git).

2. **Cursor Agent skills** — [firecrawl/skills](https://github.com/firecrawl/skills):

   ```bash
   npx skills add firecrawl/skills -g -y -a cursor
   ```

   Reload the Cursor window. Skills land under `~/.cursor/skills/` (router:
   `firecrawl`, plus `firecrawl-scrape`, `firecrawl-search`,
   `firecrawl-research-papers`, `firecrawl-parse`, and others).

3. **Cursor MCP** (optional) — add the Firecrawl MCP server in
   **Settings → Customize → MCPs** if you prefer tool calls over CLI skills.

## Usage principles (teaching / research)

- **Search** when you lack a URL; **scrape** when you have one; **map** then
  scrape for large doc sites; **parse** for local PDF/DOCX (not URLs).
- Biomedical papers: prefer **`firecrawl-research-index`** / research skills
  over hand-scraping publisher HTML.
- Library/API questions: **`firecrawl-developer-index`** (GitHub issues, docs).
- Verify claims in primary sources; social posts and summaries are leads only.
- Set HTTP timeouts; do not exfiltrate credentials or patient identifiers.

## When not to use Firecrawl

- Bibliography metadata → **Zotero** export (see
  `rules/documentation-bibliography.mdc`).
- Codebase structure → **graphify** or repository search.
- Tasks your repo already solves with `httpx`, `rvest`, or pinned datasets.

## Further reading

- Skills tree: https://github.com/firecrawl/skills/tree/main/skills
- Firecrawl docs: https://docs.firecrawl.dev/
