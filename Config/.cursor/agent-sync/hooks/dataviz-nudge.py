#!/usr/bin/env python3
"""PreToolUse: nudge Claude to load data-visualisation (inspiration) before chart code.

Adapted from holtzy/dataviz-skills hooks/dataviz-nudge (MIT, commit 966772d).
R/ggplot2/ggdist only — no matplotlib/plotnine nudge in this bundle.

Opt out: DATAVIZ_NUDGE=off. Fail open on errors.
"""
from __future__ import annotations

import json
import os
import re
import sys
from pathlib import Path
from typing import Any

# Session must load the house skill (step 0 = dataviz-inspiration in references).
DESIGN_SKILLS = ("data-visualisation", "dataviz-inspiration", "inspiration")

PLOT_PATTERN = re.compile(
    r"""
    \bggplot\( | \bgeom_\w+\( | \bggdist:: | \bstat_\w+\( | \bscale_\w+\(
    | \bfacet_\w+\( | \btheme_slide\b | \bggsave\(
    | \bgeom_density|raincloud|halfeye
    | \bd3\.(select|scale|geo|axis|line|area|arc|pie|stack|forceSimulation)
    | \{ojs\} | quarto.*ojs
    """,
    re.IGNORECASE | re.VERBOSE,
)

LIBRARY_SKILLS: list[tuple[str, re.Pattern[str]]] = [
    (
        "data-visualisation",
        re.compile(r"\bggplot\(|\bgeom_\w+\(|\bggdist::", re.IGNORECASE),
    ),
    ("quarto-revealjs", re.compile(r"\bd3\.|\{ojs\}", re.IGNORECASE)),
]


def _text_of(tool_name: str, tool_input: dict[str, Any]) -> str:
    if tool_name == "Bash":
        return tool_input.get("command") or ""
    parts = [tool_input.get(k) or "" for k in ("content", "new_string", "new_source")]
    parts += [
        e.get("new_string") or ""
        for e in tool_input.get("edits") or []
        if isinstance(e, dict)
    ]
    return "\n".join(parts)


def _design_skill_loaded(transcript_path: str) -> bool:
    names = "|".join(re.escape(s) for s in DESIGN_SKILLS)
    by_tool = re.compile(
        r'"skill"\s*:\s*"(?:[\w.-]+:)?(?:' + names + r')"'
    )
    by_slash = re.compile(
        r"Base directory for this skill: \S*/(?:" + names + r")\b"
    )
    by_ref = re.compile(r"dataviz-inspiration\.md", re.IGNORECASE)
    try:
        with open(transcript_path, encoding="utf-8", errors="replace") as f:
            for line in f:
                if by_tool.search(line) or by_slash.search(line) or by_ref.search(
                    line
                ):
                    return True
    except OSError:
        pass
    return False


def _reason(code: str) -> str:
    skills = [
        "data-visualisation (read references/dataviz-inspiration.md — gallery search before code)"
    ]
    skills += [
        f"{name} (interactive/static routing)"
        for name, pat in LIBRARY_SKILLS
        if pat.search(code)
    ]
    return (
        "dataviz-nudge: this call writes chart code, and no dataviz design step "
        "has been loaded in this session. Before plotting: load the "
        "data-visualisation skill, run the inspiration workflow (3–5 references, "
        "then chart-chooser; use ggdist raincloud when shape matters). Skills: "
        + "; ".join(skills)
        + ". If this is a trivial tweak to an approved chart, retry once — "
        "this check fires only once per session."
    )


def _marker(session_id: str) -> Path:
    base = os.environ.get("DATAVIZ_NUDGE_CACHE") or str(
        Path.home() / ".cache" / "ubuntu-genesis-dataviz-nudge"
    )
    safe = re.sub(r"[^\w.-]", "_", session_id) or "unknown"
    return Path(base) / "nudge-sessions" / safe


def main() -> int:
    if os.environ.get("DATAVIZ_NUDGE", "").lower() in {"off", "0", "false", "no"}:
        return 0
    try:
        event = json.load(sys.stdin)
        code = _text_of(event.get("tool_name") or "", event.get("tool_input") or {})
        if not PLOT_PATTERN.search(code):
            return 0
        if _design_skill_loaded(event.get("transcript_path") or ""):
            return 0
        marker = _marker(str(event.get("session_id") or ""))
        if marker.exists():
            return 0
        marker.parent.mkdir(parents=True, exist_ok=True)
        marker.touch()
        out = {
            "hookSpecificOutput": {
                "hookEventName": "PreToolUse",
                "permissionDecision": "deny",
                "permissionDecisionReason": _reason(code),
            }
        }
    except Exception:
        return 0
    print(json.dumps(out))
    return 0


if __name__ == "__main__":
    sys.exit(main())