---
name: latex-modern-audit
description: >-
  Audit LaTeX sources for modern LuaLaTeX practice (fontspec, equation env,
  floats, minted, tcolorbox, cleveref). Use when the user asks to check LaTeX
  compliance, modernise a preamble, or invokes /latex-audit or "latex modern
  guidelines" on .tex files.
disable-model-invocation: false
---

# LaTeX modern guidelines audit

Review `.tex` (and shared `preamble/*.tex`) against house rules in
`~/.cursor/rules/latex-scientific.mdc`. Produce a short, actionable report.

## When to run

- User runs `/latex-modern-audit`, asks for "modern LaTeX" or "LuaLaTeX compliance".
- After large preamble or float/math edits in `article/` or thesis trees.
- Before submission builds.

## Audit procedure

1. Read the main file and any `\input`/`\include` preamble snippets.
2. Confirm **LuaLaTeX** (or XeLaTeX): `fontspec` present; no `inputenc`/`fontenc`
   unless pdfLaTeX is intentional (flag as error).
3. **Maths:** no `eqnarray`; display maths uses `equation`/`align` with labels;
   flag bare `$$ ... $$` in `.tex` (not Quarto exports).
4. **Floats:** prefer `[tbp]`; figures/tables use `\centering`; flag `[H]` overuse.
5. **References:** `cleveref` (or `zref-clever`) preferred over manual `Eq.~\ref`.
6. **Code:** prefer `minted` + `-shell-escape`; if `listings`, check UTF-8
   `literate` or flag accent risk.
7. **Graphics:** TikZ/pgfplots for in-document vector art; external plots should
   be PDF/SVG not low-res PNG when text/lines matter.
8. **Packages:** `siunitx` for units; `booktabs` for tables; `microtype` optional;
   `tcolorbox[most]` for callouts with `enhanced` + `attach boxed title` if used.
9. **Bibliography:** citekeys resolvable; no invented `\cite{}`; `.bib` hygiene.
10. Optional: suggest [TeXtidote](http://kohm.de.tf/markus/texidate.html) or
    `chktex` if installed — do not require them.

## Output format

```markdown
## LaTeX modern audit — <main.tex>

### Pass
- …

### Should fix (methodology / portability)
- [file:line] issue → recommended change

### Optional polish
- …

### Build notes
- Engine: LuaLaTeX; shell-escape for minted; …
```

Prioritise issues that break compilation, portability, or journal semantic markup.
Do not rewrite prose unless the user also asked for editing; mention **deslop** for
narrative-only passes.

## Cross-links

- Global rule: `~/.cursor/rules/latex-scientific.mdc`
- Prose de-AI: `~/.cursor/skills/deslop/SKILL.md`
- Zotero/bib: `~/.cursor/rules/documentation-bibliography.mdc`
