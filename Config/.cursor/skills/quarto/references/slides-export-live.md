# PDF export, chalkboard, multiplex

Merged from: present-pdf-export, present-chalkboard, present-multiplex. Each section keeps its own references.


## PDF export / printing

References:
- https://quarto.org/docs/presentations/revealjs/presenting.html#print-to-pdf

Reveal.js decks print to PDF from the browser:

1. Open the rendered HTML.
2. Press `E` to switch to print view (or append `?print-pdf` to the URL).
3. Print (Cmd/Ctrl-P) and choose "Save as PDF". Set margins to None and enable background graphics.

Chrome/Chromium gives the most reliable output.

### Notes and fragments

- Fragments export as separate pages by default; add `pdf-separate-fragments: false` to collapse each slide's fragments onto one page.
- Speaker notes are included with `show-notes: true` (or `show-notes: separate-page` to put them on their own pages); `false` is the default.
- A too-tall slide expands onto multiple pages; cap that with `pdf-max-pages-per-slide` (unrelated to notes).

### Gotchas

- Use `?print-pdf` **or** press `E`; printing the normal view yields only the current slide.
- Chalkboard drawings and live/interactive content don't appear in the PDF.
- Very tall (`.scrollable`) slides get clipped in print; split them for the PDF version.

## Chalkboard and notes canvas

References:
- https://quarto.org/docs/presentations/revealjs/presenting.html#chalkboard

Draw on and over slides during a talk.

```yaml
format:
  revealjs:
    chalkboard: true
```

- `B` — toggle the chalkboard (a blank drawing surface).
- `C` — toggle the notes canvas (draw directly over the current slide).
- `DEL` — clear the current drawing.
- `D` — download drawings as JSON (restore later via the `src` option).

```yaml
format:
  revealjs:
    chalkboard:
      src: drawings.json     # preload saved drawings
      theme: whiteboard      # or chalkboard
```

You can also add per-slide buttons with `.chalkboard-buttons`.

### Gotchas

- Chalkboard is a plugin; it must be enabled in YAML before the keys do anything.
- Drawings are session-local unless you download and reload them via `src`.
- Not captured in PDF export.

## Multiplex (audience follow-along)

References:
- https://quarto.org/docs/presentations/revealjs/presenting.html#multiplex

Multiplex lets the audience follow your navigation on their own devices while you control the master.

```yaml
format:
  revealjs:
    multiplex: true
```

Rendering produces two files: your presenter copy (with a secret token) and an audience copy (`-speaker`/read-only split). Share the audience URL; navigate from the presenter copy and everyone's slides advance in sync.

### Gotchas

- Uses a public multiplex socket server by default; fine for public talks, not confidential ones.
- Only navigation syncs — not chalkboard drawings or local interaction.
- Keep the presenter (token-bearing) file private; anyone with it can drive.
