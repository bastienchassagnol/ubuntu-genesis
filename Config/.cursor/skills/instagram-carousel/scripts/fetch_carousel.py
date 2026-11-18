#!/usr/bin/env python3
"""Download an Instagram post/carousel into numbered stills + SOURCE.md."""

from __future__ import annotations

import argparse
import re
import sys
import time
from pathlib import Path

SHORTCODE_RE = re.compile(r"instagram\.com(?:/[^/?#]+)?/p/([A-Za-z0-9_-]+)")
BARE_RE = re.compile(r"^[A-Za-z0-9_-]{5,}$")


def shortcode_from(value: str) -> str:
    value = value.strip()
    match = SHORTCODE_RE.search(value)
    if match:
        return match.group(1)
    if BARE_RE.match(value):
        return value
    raise SystemExit(f"Could not parse shortcode from: {value}")


def ensure_instaloader():
    try:
        import instaloader  # noqa: F401
    except ImportError as exc:
        raise SystemExit(
            "instaloader is not installed. Create a venv and "
            "`pip install instaloader`, then re-run."
        ) from exc


def download_one(shortcode: str, out_root: Path) -> Path:
    import instaloader

    loader = instaloader.Instaloader(
        download_videos=False,
        download_video_thumbnails=False,
        save_metadata=False,
        compress_json=False,
        quiet=False,
        max_connection_attempts=3,
    )
    post = instaloader.Post.from_shortcode(loader.context, shortcode)
    owner = post.owner_username or "instagram"
    dest = out_root / f"{owner}-{shortcode}"
    dest.mkdir(parents=True, exist_ok=True)

    urls: list[str] = []
    if post.typename == "GraphSidecar":
        urls = [node.display_url for node in post.get_sidecar_nodes() if not node.is_video]
    elif not post.is_video:
        urls = [post.url]

    if not urls:
        raise SystemExit(f"{shortcode}: no stills (video-only?)")

    session = loader.context._session
    for index, url in enumerate(urls, start=1):
        path = dest / f"{index:02d}.jpg"
        response = session.get(url, timeout=60)
        response.raise_for_status()
        path.write_bytes(response.content)

    date = post.date_utc.date().isoformat() if post.date_utc else "unknown"
    caption = (post.caption or "").strip()
    source = dest / "SOURCE.md"
    source.write_text(
        f"# Source\n\n"
        f"- Account: [@{owner}](https://www.instagram.com/{owner}/)\n"
        f"- Post: https://www.instagram.com/p/{shortcode}/\n"
        f"- Date (UTC): {date}\n"
        f"- Stills: {len(urls)}\n\n"
        f"## Caption\n\n{caption}\n",
        encoding="utf-8",
    )

    group = shortcode
    rel = dest.as_posix()
    print(f"# {owner} / {shortcode} → {dest} ({len(urls)} stills)")
    print("::: {layout-ncol=2}")
    print()
    for index in range(1, len(urls) + 1):
        name = f"{index:02d}.jpg"
        print(
            f"![Slide {index} of {shortcode}.]"
            f"({rel}/{name}){{group=\"{group}\" fig-alt=\"Slide {index} of Instagram post {shortcode}.\"}}"
        )
        print()
    print(":::")
    print()
    return dest


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--url", action="append", required=True, help="Instagram URL or shortcode")
    parser.add_argument("--out", type=Path, default=Path("figures/instagram"))
    args = parser.parse_args()
    ensure_instaloader()
    args.out.mkdir(parents=True, exist_ok=True)
    failed: list[str] = []
    for raw in args.url:
        code = shortcode_from(raw)
        for attempt in range(1, 4):
            try:
                download_one(code, args.out)
                break
            except Exception as exc:  # noqa: BLE001 — report and retry
                print(f"WARN {code} attempt {attempt}: {exc}", file=sys.stderr)
                time.sleep(8 * attempt)
        else:
            failed.append(code)
        time.sleep(3)
    if failed:
        raise SystemExit("Failed: " + ", ".join(failed))


if __name__ == "__main__":
    main()
