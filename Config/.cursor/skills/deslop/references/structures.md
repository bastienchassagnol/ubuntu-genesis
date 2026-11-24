# Structures: sentence and paragraph patterns

Scope: manuscripts and package documentation. One entry per pattern: what it
looks like, why it reads as AI, fix.

## Negative parallelism ("Not X. Y.")

- Looks like: "This is not a bug; it is a design choice." "It is not just
  about accuracy, but about calibration." Also the stacked form: "Not a
  benchmark. Not a replacement. A diagnostic."
- Why: manufactured contrast, usually against a position nobody holds.
- Fix: state Y. Keep the contrast only if X is a real, cited alternative.

## Self-posed rhetorical questions

- Looks like: "The result? A 30% drop in variance." "So what does this mean?"
- Why: staged suspense.
- Fix: fold into a statement: "Variance dropped by 30%."
- In vignettes, a question as a section heading ("How do I fit a model?") is
  fine; questions inside paragraphs that the next sentence answers are not.

## Dramatic fragmentation

- Looks like: "Speed. That is the trade-off." "Three seeds. Ten thousand
  draws. One answer."
- Why: manufactured emphasis through short fragments; a run of them is
  metronomic.
- Fix: one full sentence with the numbers: "We ran 10 000 draws from each of
  three seeds."

## Anaphora and tricolon abuse

- Looks like: three or more consecutive sentences with the same opening ("The
  method handles X. The method handles Y. The method handles Z."); lists of
  exactly three abstractions ("faster, simpler, more reliable").
- Why: rhythmic padding that sounds like oratory; models default to groups of
  three.
- Fix: merge into one sentence, or use the number of items the content has. Two
  items or four are fine when they are the real count.

## False ranges

- Looks like: "from preprocessing to deployment", "from small data sets to
  large-scale genomics", where no scale links the endpoints.
- Why: a range-shaped phrase that lists two items without implying anything
  between them.
- Fix: list the items, or give the actual range ("n between 20 and 4 000").

## Superficial participle analyses

- Looks like: a clause ending ", highlighting its importance", ", underscoring
  the need for", ", reflecting broader trends", ", demonstrating the value of".
- Why: tacks on empty interpretation; the "-ing" clause makes no testable
  claim.
- Fix: delete, or replace with the specific implication in its own sentence.

## "Despite these challenges..." formula

- Looks like: a paragraph listing limitations, then "Despite these challenges,
  the approach remains promising".
- Why: reflex reassurance; contradicts honest uncertainty.
- Fix: state each limitation with its likely effect, and end there or with the
  concrete next test.

## False agency

- Looks like: "The complaint becomes a fix." "The data tell us", "The model
  wants", "The results speak for themselves"; inanimate subjects doing human
  verbs.
- Why: hides the actor and anthropomorphises models and data.
- Fix: name the actor. "We fixed it." "The posterior mean shifts by 0.3."
  Do not give models intentions ("the model learns to avoid"): say what the
  fitting procedure does.

## Passive voice (with the Methods exception)

- Looks like: "It was decided that...", "Samples were chosen", "The model can
  be used to".
- Why: actor-less sentences blur responsibility and read as filler.
- Rule: active voice by default, with "we" for the authors' own work and "the
  package" or "the function" as subject in documentation. Passive is acceptable
  in Methods when the actor is the authors or is irrelevant ("Samples were
  centrifuged at 4 degrees C"). Do not use passive to hide a judgement
  ("Outliers were removed" needs the rule and the count).

## Narrator-from-a-distance

- Looks like: "It has long been recognised that...", "Researchers often
  face...", "Users typically want..." with no specific population.
- Why: generic observer voice; the writer commits to nothing.
- Fix: "We" for the authors; cite named work; address the user directly in
  documentation ("You can pass a formula or a data frame").

## Listicle in a trench coat

- Looks like: "The first limitation... The second limitation... The third..."
  as a paragraph.
- Why: a list pretending to be prose.
- Fix: write a real list when items are parallel (bullets in documentation,
  `itemize` in LaTeX only if the venue allows), or order by importance in
  connected prose.

## Bold-first bullets

- Looks like: every list item opens with a bolded keyword and a colon.
- Why: slide-deck formatting inside text.
- Fix: plain items, or a table when items share attributes. Bold only for
  genuine key terms on first definition.

## Sentence starters to avoid

- Looks like: a sentence opening with What/When/Where/Why/How as a crutch
  ("What this means is...", "How we did it matters"); "This is where...".
- Fix: restructure so the subject carries the point.

## Rhythm

- Looks like: three consecutive sentences of similar length; every paragraph
  ending on a punchy one-liner; every paragraph opening with a topic sentence
  of the same shape.
- Fix: vary length; end paragraphs on the last piece of content. In results
  sections, a short sentence is fine for one headline number.

## One-point dilution

- Looks like: the same argument restated in several paragraphs or sections,
  each in new words; one metaphor extended over a page.
- Why: length without content; also a mark of generated text.
- Fix: state the point once where it belongs, cross-refer elsewhere. Cut
  repeated claims between Abstract, Introduction and Discussion to the
  minimum the venue needs.

## Fractal summaries

- Looks like: "In this section we will... [content]... In summary, we have
  shown...", at every level.
- Fix: keep the abstract and one closing paragraph; delete the other recaps.

## Dead and stacked metaphors

- Looks like: one metaphor repeated more than twice; stacked analogies for
  authority ("Like X, like Y, like Z").
- Fix: use the literal term; keep a figure of speech only once.

## Content duplication

- Looks like: a vignette repeating the README, or a Discussion repeating the
  Results paragraph by paragraph.
- Fix: link to the single source of truth; the Discussion interprets, it does
  not restate.

## Fabricated precision and unsupported claims

- Looks like: numbers or citations that appear without a source, "significant"
  without a test, "robust" without a sensitivity analysis.
- Fix: use only numbers from the analysis output; write "[CHECK]" or ask the
  author when unsure. Never invent a citation, estimate or interval.
