---
name: "peer-review"
description: "Set up a keyless peer review of a manuscript with Open ScholarPeer (OSP) in the paper's folder, for Cursor. Use when the user wants to review, critique or peer-review a paper (PDF, DOCX, .tex, .md) or asks how to install or run Open ScholarPeer. Installs OSP into the given folder, then hands over to OSP's slash commands."
---

# Peer review with Open ScholarPeer

OSP (https://github.com/amirkiarafiei/open-scholar-peer, MIT) runs the
7-step ScholarPeer review protocol inside the paper's folder, searching open
databases with no API key. A clone lives at `~/tools/open-scholar-peer`.

## Install in a paper folder

Ask for the folder holding the manuscript if not given, then run:

```bash
test -d ~/tools/open-scholar-peer || \
  git clone https://github.com/amirkiarafiei/open-scholar-peer ~/tools/open-scholar-peer
bash ~/tools/open-scholar-peer/install.sh --dir /path/to/paper --tool cursor \
  --sources arxiv,semantic_scholar,google_scholar,europepmc,openalex
```

Needs `python3` with venv. If the installer reports it missing, ask the user
to run `sudo apt install python3.X-venv` (X from `python3 --version`).

Check the result: `.cursor/mcp.json` (servers `osp`, `markitdown`),
`.cursor/commands/` (8 commands), `.open-scholar-peer/mcp/.venv`, `.brain/`.
The installer adds `.brain/`, `.open-scholar-peer/` and `.env` to `.gitignore`.

## Run the review (user, in Cursor)

1. Reload the window (Ctrl+Shift+P → "Reload Window").
2. Allow the `osp` and `markitdown` MCP servers if asked.
3. Type `/open-scholar-peer`; it names the next step:
   `/0-osp-onboarding` (venue, guidelines) → `/1-osp-summary` →
   `/2-osp-literature` → `/3-osp-historian` → `/4-osp-baseline-scout` →
   `/5-osp-qa` → `/6-osp-review`.
4. Draft review: `.brain/review/`. Every claim traces to a file in `.brain/`;
   it is a draft for the reviewer to edit.

## Databases without keys (tested 2026-11-15)

| Source | Status |
|---|---|
| arXiv, Europe PMC, OpenAlex | work (OpenAlex ≈100 calls/day) |
| Semantic Scholar | often HTTP 429; a free key in `.env` fixes it |
| Google Scholar | scraping, often blocked (returns nothing) |

Search from a terminal without an MCP client:
`.open-scholar-peer/mcp/.venv/bin/python .open-scholar-peer/mcp/osp_cli.py list`
then `... call search_openalex '{"query":"...","limit":5}'` (argument names
differ per tool: `osp_cli.py schema <tool>`).

## Rules

- Cite only papers the searches returned; never invent references.
- Do not send identifiable patient data to search tools.
- If hits repeatedly name a manuscript author, flag a possible conflict of
  interest.
- Update OSP: `git -C ~/tools/open-scholar-peer pull`, then rerun the installer
  in the paper folder.

Optional keyless add-ons for Cursor: cyanheads/crossref-mcp-server (DOI,
retraction checks), cyanheads/pubmed-mcp-server (MeSH, citation metrics).
