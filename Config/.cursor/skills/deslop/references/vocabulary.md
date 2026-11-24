# Vocabulary: words and phrases to cut or replace

Scope: manuscripts and package documentation. Each entry gives the pattern, why
it reads as AI, and the fix. Domain terms ("weighted interval score",
"posterior predictive check") are precise language, not jargon.

## Throat-clearing and meta-commentary

- Looks like: "Here's the thing:", "It turns out", "The truth is", "Let me be
  clear", "It's worth noting", "It bears mentioning", "Notably", "At its core",
  "When it comes to", "In today's [field]".
- Why it reads as AI: it announces a point instead of making it, and carries no
  information.
- Fix: delete the opener and state the point. "It is worth noting that the
  estimator is biased" becomes "The estimator is biased".

## Section announcements

- Looks like: "In this section, we will explore...", "As we will see...",
  "The rest of this vignette walks you through...", "As shown above" with no
  reference, "In conclusion", "To sum up", "In summary".
- Why: the text narrates its own structure; headings already do that.
- Fix: delete. Where orientation helps, one sentence with a cross-reference
  (`\ref{sec:methods}`, `@sec-methods`) is enough. End a section on its last
  finding, not on a signposted summary.

## Pedagogical hand-holding

- Looks like: "Let's break this down", "Let's dive in", "Let's unpack", "Think of
  it as...", "Imagine a world where...".
- Why: assumes the reader needs a teacher and delays the content.
- Fix: state the fact. In a vignette, a worked example is fine; the lead-in is
  not ("The following example fits a model" beats "Let's dive into an example").

## Emphasis crutches and performative sincerity

- Looks like: "Full stop.", "Let that sink in.", "Make no mistake", "This
  matters because", "genuinely hard", "actually matters", "I promise".
- Why: asserts significance or sincerity instead of showing it.
- Fix: delete, or give the reason once with a number or consequence.

## Magic adverbs, intensifiers and hedges

- Looks like: "quietly", "really", "just", "simply", "actually", "truly",
  "deeply", "fundamentally", "inherently", "inevitably", "remarkably",
  "importantly", "crucially", "interestingly", "arguably".
- Why: they mark importance or caution without content. "Quietly" is a
  favourite of models for implying subtle significance.
- Fix: cut. Keep an adverb only when it changes the claim ("approximately 12%").
  Hedge once, where the evidence is uncertain, and say what is uncertain; do not
  stack hedges ("may potentially suggest").
- Also check "simply" and "just" in package documentation: they disparage a
  user who finds the step hard ("simply call `fit()`").

## AI vocabulary

Words overrepresented in model output. Replace with a plain term.

| Avoid | Use |
|-------|-----|
| delve (into) | examine, analyse |
| tapestry, landscape (for "field") | range, field, set of studies |
| nuanced | name the specific complexity |
| pivotal, crucial, vital | important, or state the consequence |
| showcase, underscore, highlight (verb) | show, report |
| foster, bolster | support, improve, increase |
| intricate, multifaceted | name the parts |
| comprehensive, holistic | state what is covered |
| certainly | delete |
| realm, arena | field |

## Business jargon

| Avoid | Use |
|-------|-----|
| leverage (verb), utilise, harness | use, apply |
| robust (when no robustness claim is tested) | state the property: "stable under outlier contamination" |
| streamline | simplify |
| paradigm, framework (generic) | approach, model, method |
| ecosystem | field, set of packages |
| navigate (challenges) | address, handle |
| deep dive, moving forward, circle back | analysis, next, return to |
| game-changer, cutting-edge, seamless | delete, or state the measured improvement |
| novel (empty) | state what is new, or delete |

"Robust" and "framework" are legitimate when they have a technical meaning
(robust standard errors; a modelling framework defined in the paper). Keep
those.

## The "serves as" dodge

- Looks like: "serves as", "stands as", "acts as", "marks", "represents",
  "functions as" where "is" would do.
- Why: pompous substitutes for the copula.
- Fix: "is" or "are". "The function serves as a wrapper for `lm()`" becomes "The
  function wraps `lm()`".

## Vague declaratives

- Looks like: "The implications are significant", "The reasons are structural",
  "The stakes are high", "This is the deepest problem".
- Why: announces importance without naming the thing.
- Fix: name the implication, reason or consequence, with a number if one exists.

## Vague attributions

- Looks like: "Experts argue...", "Studies have shown...", "It is widely
  believed...", "Researchers have noted".
- Why: no source behind the claim.
- Fix: cite the specific work (`[@key]`, `\cite{key}`) or drop the claim. Never
  invent a citation to replace the vagueness.

## Grandiose stakes inflation

- Looks like: "will fundamentally reshape how we think about", "opens new
  avenues", "paves the way", "a paradigm shift", "ushers in a new era".
- Why: scales every contribution to world-historical size.
- Fix: state the measured gain and its limits. "Reduces median error by 8% on
  the three benchmark data sets."

## "The truth is simple" and telling instead of showing

- Looks like: "The reality is simpler", "The data are clear", "History is
  unambiguous", "This is what rigorous analysis looks like".
- Why: asserts clarity or quality instead of demonstrating it.
- Fix: present the evidence; let the reader judge.

## False vulnerability

- Looks like: "And yes, we are aware of the limitation", "In the interest of
  honesty", "This is not a criticism; it is an observation".
- Why: simulated candour. In a Discussion, limitations are required, but they
  should be specific.
- Fix: state the limitation and its likely effect on the estimate ("Residual
  confounding by smoking is possible; the E-value is 1.8").

## Invented concept labels

- Looks like: "the calibration paradox", "the reproducibility trap", "the
  precision illusion" coined and used as if established.
- Why: a catchy noun phrase substitutes for an argument and is not defined.
- Fix: describe the phenomenon plainly, or define the term once with a
  citation if it exists in the literature.

## Peer-review response filler

- Looks like: "We sincerely thank the reviewer for this insightful and
  thought-provoking comment", "We appreciate this valuable feedback".
- Why: boilerplate praise repeated for every comment.
- Fix: one short thanks at the top of the letter; then answer each point with
  the change made and its location ("We added a sensitivity analysis
  (Section 3.4, Table 2)").

## Package-documentation filler

- Looks like: "powerful", "easy-to-use", "flexible", "state-of-the-art",
  "a wide range of", "unlock", "empower", "out of the box" without a claim.
- Why: marketing adjectives that a user cannot check.
- Fix: say what the package does and what input it takes. "`fit_mixture()`
  estimates a K-component Gaussian mixture by EM."

## Em dashes and decoration

- Looks like: "—" used for asides or emphasis; unicode arrows ("→") in running
  prose; emoji in headings.
- Why: heavy em-dash use is among the most recognisable tells.
- Fix: comma, full stop or parenthesis. Use an en dash only for ranges
  (`12--15` in LaTeX).
