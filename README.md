# thomasfrost.io

Personal site. Plain [Jekyll](https://jekyllrb.com), no JavaScript, no build tooling beyond Ruby.
Deployed to GitHub Pages by `.github/workflows/deploy.yml` on every push to `main`.

## What lives where

| Path | What it is |
| --- | --- |
| `index.md` | Home page — intro, Research, Background, Projects, Publications |
| `blog.md` | Blog index (lists everything in `_posts/`) |
| `_posts/` | Blog posts, one markdown file each |
| `_config.yml` | Site title, nav links, social links, CV path |
| `_layouts/` | Page templates (`default`, `page`, `post`) |
| `assets/css/style.css` | The entire design, one file |
| `assets/img/profile.jpg` | Headshot |
| `assets/Thomas_Frost_CV.pdf` | CV |
| `CNAME` | Custom domain (`www.thomasfrost.io`) |

## Adding a blog post

Create `_posts/YYYY-MM-DD-some-slug.md`:

```markdown
---
layout: post
title: "Your title"
date: 2026-09-01
description: One line shown on the blog index.
---

Body in markdown.
```

Commit and push. That's the whole process — the post appears on `/blog/` automatically.

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
