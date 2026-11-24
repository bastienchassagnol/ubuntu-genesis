# Dataviz inspiration (before code)

Search curated galleries, then borrow form, annotation and palette. **Implementation stays R/ggplot2** in Quarto or pre-rendered figures for Sphinx — design only here.

Provenance: [holtzy/dataviz-skills/inspiration](https://github.com/holtzy/dataviz-skills) (MIT).

| Source | Role |
|---|---|
| [dataviz-inspiration.com](https://www.dataviz-inspiration.com) | 450+ tagged projects (CC BY 4.0 catalogue data) |
| [Dataviz Index](https://datavizindex.fr) | French editorial picks (WeDoData) |

Live API + 24 h cache (`~/.cache/dataviz-inspiration`). Do not copy catalogues into the repo.

## Family (pick one)

| Reader must see… | `--family` |
|---|---|
| spread of values (raincloud, ridgeline) | `distribution` |
| relationship | `correlation` |
| rank / compare quantities | `ranking` |
| share of whole | `partOfAWhole` |
| change over time | `evolution` |
| geography | `map` |
| flows, networks | `flow` |

Then `chart-chooser.md` + house rule for the final type (e.g. **ggdist raincloud** when shape matters).

## Search

From the **data-visualisation** skill directory:

```bash
python3 scripts/search_viz.py "abstention turnout élection" --family map --limit 8
python3 scripts/search_viz.py "raincloud ridgeline" --family distribution --label "small multiples"
python3 scripts/search_viz.py --family distribution --vocab
python3 scripts/search_viz.py "clinical" --family ranking --thumbs /tmp/viz-thumbs --format json
```

| Option | Meaning |
|---|---|
| query | Bilingual keywords (EN + FR) |
| `--family` | See table |
| `--type` | Repeatable OR (`choropleth`, `sankey`…); `--vocab` lists |
| `--label` | Repeatable AND (`annotation`, `small multiples`…) |
| `--thumbs DIR` | Download thumbnails to **look** (never ship) |
| `--format json` | Full records for the agent |

## Present, then code

For each of 3–5 picks: title, author, **original URL**, **gallery URL**, what to borrow, why it fits. End with credits to both galleries.

Method refs (when form is unclear): [data-to-viz.com](https://www.data-to-viz.com), our `caveats.md`, [Insee courrier dataviz](https://www.insee.fr/fr/information/7722079) for public-statistics tone.