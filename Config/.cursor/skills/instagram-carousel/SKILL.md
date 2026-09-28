---
name: instagram-carousel
description: >-
  Download an Instagram post or carousel, split it into numbered stills,
  and insert a Quarto lightbox gallery. Use when the user pastes an
  instagram.com/p/ URL, asks to extract a carousel, or invokes
  /instagram-carousel.
disable-model-invocation: true
---

# Instagram carousel → Quarto gallery

Firecrawl and most scrapers **block** Instagram. Do not use
`firecrawl_scrape` or `WebFetch` as the primary extractor. Use
**instaloader** (anonymous public posts) as we did for
`DdG5U50D_Hv`.

## Slash command

`/instagram-carousel` with one or more Instagram URLs (or shortcodes).
Optional: a target `.qmd` and a `group=` name.

## Workflow

1. Parse each URL. The shortcode is the path after `/p/`
   (`Ddlol_yG6q1`). Ignore `utm_*`, `stkn`, `img_index`, `igsi`.
   Match `/p/{code}/` only — a naive `[A-Za-z0-9_-]+` steals
   `https` from the URL.
2. From the **project root**, run the helper (creates a throwaway
   venv if `instaloader` is missing):

   ```bash
   python3 ~/.cursor/skills/instagram-carousel/scripts/fetch_carousel.py \
     --url "https://www.instagram.com/p/SHORTCODE/" \
     --out figures/instagram
   ```

   Several posts:

   ```bash
   python3 ~/.cursor/skills/instagram-carousel/scripts/fetch_carousel.py \
     --url URL1 --url URL2 --out figures/instagram
   ```

   The script writes `figures/instagram/<owner>-<shortcode>/`:

   - `01.jpg`, `02.jpg`, … one file per still (sidecar or single)
   - `SOURCE.md` — permalink, owner, date, caption
   - prints Quarto gallery markdown on stdout

3. Use **full / unsandboxed network** (`required_permissions: ["all"]`).
   Sandboxed DNS often fails for `pip` and Instagram.
4. Open each still (Read tool on the `.jpg`) and write a short
   British-English caption. Treat the Instagram **caption** as the
   readable text; AI slides often drop spaces.
5. Insert a [lightbox gallery](https://quarto.org/docs/output-formats/html-lightbox-figures.html#galleries).
   Site-wide `format.html.lightbox: true` must already be on
   (see `_quarto.yml`). Same `group` on every image in the set.

   ```markdown
   ::: {layout-ncol=2}

   ![Caption for slide 1.](../figures/instagram/owner-SHORTCODE/01.jpg){group="SHORTCODE" fig-alt="…"}

   ![Caption for slide 2.](../figures/instagram/owner-SHORTCODE/02.jpg){group="SHORTCODE" fig-alt="…"}

   :::
   ```

6. Credit the account and permalink above the gallery. Quote the
   caption if the lettering is unreadable.
7. Do not commit helper venvs. `.venv*` stays gitignored.
8. In this maths site, prefer an include under
   `_includes/galleries/{shortcode}.qmd` and
   `{{< include ../_includes/galleries/{shortcode}.qmd >}}`.

## Failures

| Symptom | What to do |
|---------|------------|
| Firecrawl “we do not support this site” | Expected. Use the script. |
| `401` / `require_login` on GraphQL | Expected. Do not chase Instagram APIs. |
| instaloader login wall | Ask the user for a session, or skip. |
| Video-only item | Skip the video; keep stills. |

## What not to do

- Do not invent slides if download fails.
- Do not hotlink `cdninstagram.com` URLs (they expire).
- Do not put profile avatars or “more posts” thumbnails in the gallery.
