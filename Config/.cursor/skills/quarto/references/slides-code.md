# Code on slides: highlighting, unexecuted, hand-styled, syntax themes

Merged from: content-code-highlighting, content-code-unexecuted, content-code-manual, theme-syntax-highlight. Each section keeps its own references.


## Code line highlighting and step-through

References:
- https://quarto.org/docs/presentations/revealjs/#line-highlighting

### Line numbers

```yaml
format:
  revealjs:
    code-line-numbers: true
```

### Highlight specific lines

Use the `code-line-numbers` cell option on a code block:

````markdown
```{.python code-line-numbers="2,5"}
import numpy as np
x = np.arange(10)      # highlighted
y = x ** 2
z = y.sum()
print(z)               # highlighted
```
````

Ranges: `"3-5"`. Combine: `"1,3-5"`.

### Step-through (progressive highlighting)

Separate states with `|`; each forward press moves to the next highlight. This pairs with fragment navigation:

````markdown
```{.python code-line-numbers="|1|2-3|5"}
import numpy as np
x = np.arange(10)
y = x ** 2
z = y.sum()
print(z)
```
````

`|1|2-3|5` means: first show all, then highlight line 1, then 2-3, then 5.

### Executable code

For R/Python that runs at render, use `echo`/`eval`/`output` cell options; highlighting works the same on the echoed source.

### Gotchas

- The leading `|` (as in `"|1|..."`) makes the first state "no highlight / all lines," so the reveal starts neutral.
- Line highlighting counts as fragment steps — factor it into slide pacing.
- For hand-built highlights on non-executed pseudo-code, see *Hand-styled code* below.

## Showing Quarto code literally

References:
- https://slidecrafting-book.com/elements
- https://quarto.org/docs/computations/execution-options.html#unexecuted-blocks

To display Quarto/knitr code verbatim (teaching how to write Quarto, without running it), you need unexecuted blocks.

Wrap the example in a `markdown` fence that uses **more backticks** than anything inside, and add an **extra layer of curly braces** so the inner block isn't executed (double `{{python}}` for one level; triple `{{{python}}}` when the block is itself shown inside another displayed fence, as below):

`````markdown
```` markdown
This is **Quarto** code

```{{{python}}}
1 + 1
```
````
`````

The `{{{python}}}` renders as literal `{python}` instead of running. The outer ```` ```` ```` fence must have more ticks than the inner ``` ``` ``` fence.

### Gotchas

- Backtick count matters: outer fence needs strictly more ticks than any inner fence.
- Each extra `{`/`}` layer defers execution one more render pass; two braces `{{python}}` for one level, three `{{{python}}}` when the surrounding doc is itself processed again.
- This is a Quarto authoring trick, not a reveal.js feature — it works in any Quarto format.

## Hand-styled / manually highlighted code

References:
- https://slidecrafting-book.com/manual-code

When you want highlight control beyond automatic syntax highlighting, render code as plain text and style parts by hand with classes and fragments.

### A monospace text block

```scss
/*-- scss:rules --*/
.mono {
  font-family: monospace;
  font-size: 0.9em;
}
```

Put the code in a fenced div with `.mono`. Use `\ ` for leading spaces; end each line with two trailing spaces to force line breaks:

```markdown
::: {.mono}
library(ggplot2)
mtcars |> 
\ \ ggplot(aes(mpg, disp)) + 
\ \ geom_point() + 
\ \ geom_smooth(method = "lm", formula = "y ~ x")
:::
```

### Color pieces by hand

Inline style or a class colors a token:

```markdown
library([ggplot2]{style="color:purple;"})
```

Reuse theme classes here (`content-code-manual` pairs well with `slides-theme-advanced.md` color classes).

### Incremental highlight with fragments

Add `.fragment` + a `.highlight-*` class to reveal highlights one press at a time:

```markdown
geom_smooth([method = "lm"]{.fragment .highlight-red}, [formula = "y ~ x"]{.fragment .highlight-blue})
```

This highlights `method = "lm"` in red on the first advance, then `formula = "y ~ x"` in blue.

### Gotchas

- Leading whitespace needs `\ ` (backslash-space); ordinary spaces collapse.
- Two trailing spaces = a newline in Markdown; without them lines merge.
- This bypasses real syntax highlighting — only worth it when you need precise, animated emphasis. For executed code, prefer the line-highlighting section above.

## Custom code syntax highlighting

References:
- https://slidecrafting-book.com/colors
- https://quarto.org/docs/output-formats/html-code.html#highlighting

### Presets

Pick a built-in scheme in YAML:

```yaml
format:
  revealjs:
    highlight-style: github   # dracula, monokai, nord, solarized, ...
```

### Per-token custom colors

Highlighting uses [skylighting](https://github.com/jgm/skylighting), which tags each token type with a two-letter class. Target them in `scss:rules`. Group tokens that share a color to keep it compact:

```scss
code {
  span.an, span.op, span.sc, span.in,
  span.wa, span.do, span.cv, span.co { color: #5E5E5E; }  // annotations, comments, operators

  span.er, span.bn, span.al, span.pp,
  span.dt, span.fl, span.dv { color: #AD0000; }           // errors, numbers, datatypes

  span.ss, span.st, span.vs, span.ch { color: #20794D; }  // strings
  span.ot, span.cf, span.kw          { color: #003B4F; }  // keywords, control flow
  span.at { color: #657422; }                             // attribute
  span.fu { color: #4758AB; }                             // function
  span.va { color: #111111; }                             // variable
  span.im { color: #00769E; }                             // import
  span.cn { color: #8f5902; }                             // constant
}
```

Full token key: `kw` keyword, `cf` control flow, `ot` other, `st`/`ss`/`vs`/`ch` strings, `fu` function, `va` variable, `dt` datatype, `dv`/`bn`/`fl` numbers, `co`/`cv` comments, `op` operator, `at` attribute, `im` import, `cn` constant, `er` error, `al` alert, `pp` preprocessor, `sc` special char, `an` annotation, `in` info, `wa` warning, `do` documentation.

You can also make tokens italic/underlined, but keep the contrast rules and don't change font sizes (breaks alignment).

### Gotchas

- Changing token font-size misaligns code; only touch color/style.
- Custom token colors still need to contrast with `$code-block-bg`.
- These classes live under `code`; scope broader if you also style inline `code` spans differently.
