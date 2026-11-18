# Presenting: notes, speaker view, navigation, slide numbers

Merged from: present-speaker-notes, present-speaker-view, present-navigation, present-slide-numbers. Each section keeps its own references.


## Speaker notes

References:
- https://quarto.org/docs/presentations/revealjs/presenting.html#speaker-notes

Add notes to a slide with a `.notes` div:

```markdown
## Slide

Visible content.

::: {.notes}
Only I see this in speaker view. Remember to mention the caveat.
:::
```

Notes appear in speaker view (press `S`) alongside the current slide, next slide, and timer. See *Speaker view* below.

### Gotchas

- Notes are still present in the HTML source (not secret); don't put sensitive material there.
- One `.notes` div per slide; place it anywhere in the slide's content.

## Speaker view / presenter mode

References:
- https://quarto.org/docs/presentations/revealjs/presenting.html#speaker-view

Press `S` during a presentation to open speaker view in a second window: current slide, upcoming slide, speaker notes (above), and a timer.

Intended flow: mirror or extend your display, put speaker view on your laptop, the slides on the projector.

### Gotchas

- Requires pop-ups enabled for the presentation's origin.
- The notes window and slides stay in sync automatically; navigate from either.
- Works from the rendered HTML in a browser, including `quarto preview`.

## Navigation, menu, overview, keyboard

References:
- https://quarto.org/docs/presentations/revealjs/presenting.html

### Keyboard cheat sheet

| Key | Action |
|---|---|
| →, Space, N | next |
| ←, P | previous |
| F | fullscreen |
| S | speaker view |
| O | overview (thumbnail grid) |
| M | menu |
| B | chalkboard |
| C | notes canvas |
| E | print/PDF view |
| R | scroll view |
| Esc | exit overview/mode |
| `<number>` then Enter | jump to slide |
| ? | show all shortcuts |

### Menu and overview

The menu (button bottom-left, or `M`) lists slides for quick jumps. Overview (`O`) shows a zoomed-out thumbnail grid.

### Options

```yaml
format:
  revealjs:
    menu: true          # or false to disable
    navigation-mode: linear   # linear | vertical | grid
    controls: true      # on-screen arrows
    progress: true      # progress bar (colored by $link-color)
```

### Scroll view

`R` toggles a continuous vertical scroll of the whole deck (good for reading, not presenting). Enable by default with `view: scroll`.

### Gotchas

- Style the progress bar via `$link-color` (`slides-theme.md`).
- `navigation-mode: grid` matters only when you use vertical (nested) slides.
- The menu is a plugin (on by default); `menu: false` removes both button and `M`.

## Slide numbers and auto-advance

References:
- https://quarto.org/docs/presentations/revealjs/presenting.html

### Slide numbers

```yaml
format:
  revealjs:
    slide-number: true      # or a format string
```

Format options: `c` (current), `c/t` (current/total), `h.v` (horizontal.vertical), `h.v.c`. Control where they show with `show-slide-number: all | print | speaker`.

### Auto-advance

```yaml
format:
  revealjs:
    auto-slide: 5000        # ms per slide
    loop: true              # loop back to start
```

Good for kiosk/unattended playback.

### Slide tone

Audible cue on advance (accessibility / pacing):

```yaml
format:
  revealjs:
    slide-tone: true
```

### Gotchas

- `auto-slide` also pauses on user interaction; press `A` to toggle it live.
- `show-slide-number: print` keeps numbers out of the live talk but in the PDF.
- There is no documented per-slide way to hide the number; `show-slide-number` controls visibility globally by context (`all`/`print`/`speaker`). To suppress it on one slide, hide it with your own CSS targeting that slide.
