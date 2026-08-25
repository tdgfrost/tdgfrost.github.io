# thomasfrost.io

Personal site. Plain [Jekyll](https://jekyllrb.com), no JavaScript, no build tooling beyond Ruby.
Deployed to GitHub Pages by `.github/workflows/deploy.yml` on every push to `main`.

## What lives where

| Path | What it is |
| --- | --- |
| `index.md` | Home page — intro, Research, Background, Projects, Publications |
| `blog.md` | Blog index (lists everything in `_posts/`) |
| `_posts/` | Blog posts, one markdown file each (`*.html` here is generated — don't edit) |
| `_typst/` | Blog posts written in Typst, one `.typ` file each |
| `_plugins/typst.rb` | Compiles `_typst/*.typ` into posts at build time |
| `_config.yml` | Site title, nav links, social links, CV path |
| `_layouts/` | Page templates (`default`, `page`, `post`) |
| `assets/css/style.css` | The entire design, one file |
| `assets/img/profile.jpg` | Headshot |
| `assets/Thomas_Frost_CV.pdf` | CV |
| `CNAME` | Custom domain (`www.thomasfrost.io`) |

## Adding a blog post

Posts can be written in either markdown or Typst. Both end up in the same place,
styled identically, listed together on `/blog/`.

### Markdown

Create `_posts/YYYY-MM-DD-some-slug.md`. No front matter is required — the date
and title come from the filename, and the preview text on `/blog/` falls back to
the opening paragraph:

```markdown
Body in markdown.
```

Add front matter to override either:

```markdown
---
title: "Your title"
description: One line shown on the blog index and under the title.
---

Body in markdown.
```

### Typst

Create `_typst/YYYY-MM-DD-some-slug.typ`, starting with the shared preamble:

```typst
#import "_post.typ": post
#show: post.with(
  title: "Your title",
  description: "One line shown on the blog index and under the title.",
)

Body in Typst, with maths like $x^2$ and $ sum_(i=1)^n x_i $.
```

`description` is the preview line on `/blog/`, and doubles as the page's meta
description for search engines and link previews. To show something *different*
under the title on the post itself, add `subtitle:` — it applies to the post
page only, and falls back to `description` when omitted, so one value still
covers both by default. `subtitle: ""` gives a post with no subtitle at all.
Markdown posts take the same two keys in their front matter.

As with markdown, the date comes from the filename unless you override it with
`date:`, which takes a `datetime` (add `hour`/`minute`/`second` to order several
posts published on one day) or a plain `"YYYY-MM-DD"` string:

```typst
#show: post.with(
  title: "Your title",
  date: datetime(year: 2026, month: 9, day: 1),
)
```

When you change `date:`, the build renames the `.typ` file so its filename date
matches — `2026-08-25-some-slug.typ` becomes `2026-09-01-some-slug.typ` — so the
two can't drift apart. The slug is kept, and if a file of the target name
already exists the rename is skipped with a warning rather than clobbering it.

Note that changing the date also changes the post's URL, since the permalink is
built from it — again, exactly as in markdown.

`_plugins/typst.rb` compiles it to `_posts/YYYY-MM-DD-some-slug.html` on every
build. That output is a build artefact and is gitignored — commit the `.typ`.

Building Typst posts needs the `typst` CLI (`brew install typst`); CI installs
it in `.github/workflows/deploy.yml`. If it is missing the build still succeeds,
skipping Typst posts with a warning.

**One caveat worth knowing.** Typst's HTML export is still in development. Prose,
lists, tables, code, figures and footnotes export as real HTML, but anything
needing page layout — equations, shapes, CeTZ diagrams — is *dropped silently*
unless wrapped in `html.frame()`, which renders it to inline SVG. `_post.typ`
does this for equations automatically. For anything else, wrap it yourself:

```typst
#figure(html.frame(rect(width: 60pt, height: 30pt)), caption: [A shape.])
```

The build prints a warning naming anything it saw dropped, so watch the log.
SVG maths is an image: it does not reflow, and is not selectable or searchable.

Either way: commit and push. The post appears on `/blog/` automatically.

## Adding a project or publication

Both are plain HTML lists at the bottom of `index.md`. Copy an existing `<li class="entry">`
block and edit it.

## Changing the nav

Edit the `nav:` list in `_config.yml`. Nothing else references it.

## Previewing locally

The macOS system Ruby (2.6) is too old for Jekyll 4. Use the Homebrew one:

```bash
export PATH="/opt/homebrew/opt/ruby/bin:$PATH" && bundle install && bundle exec jekyll serve
```

Then open http://localhost:4000. Pushing without previewing is fine too — CI builds the same way.

`--incremental` is safe to use: `_plugins/incremental_post_lists.rb` opts any
page that lists posts (`blog.md`) out of the incremental cache. Without it,
Jekyll compares only that page's own mtime against its output, so changing a
post's date, title or description leaves the blog index stale — and restarting
the server does not clear it, because `.jekyll-metadata` survives a restart.

Note that Ruby loads `_plugins/*.rb` once at startup, so changes to either
plugin need a server restart. Changes to posts and `.typ` files do not.
