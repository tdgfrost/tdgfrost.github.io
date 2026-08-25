// Shared preamble for every Typst blog post.
//
// Usage, at the top of a file in _typst/:
//
//   #import "_post.typ": post
//   #show: post.with(title: "...", description: "...")
//
// `description` is the preview line on /blog/ (and the page's meta description
// for search engines and link previews). `subtitle` is the line shown under the
// title on the post itself; it falls back to `description` when not given, so
// pass it only when you want the two to differ. Pass `subtitle: ""` for a post
// with no subtitle at all.
//
// The filename supplies the date and URL slug, exactly as it does for the
// markdown posts in _posts/. Passing `date:` overrides the filename's date,
// as front matter does for a markdown post. It accepts either a datetime:
//
//   date: datetime(year: 2026, month: 9, day: 1)
//
// (add hour/minute/second to order several posts within one day), or a plain
// "YYYY-MM-DD" string.

#let post(title: none, description: none, subtitle: none, date: none, body) = {
  // A datetime has to be formatted here: `typst query` serialises one to its
  // debug representation, which Jekyll cannot read.
  let date-str = if type(date) == datetime {
    if date.hour() == none {
      date.display("[year]-[month]-[day]")
    } else {
      date.display("[year]-[month]-[day] [hour]:[minute]:[second]")
    }
  } else {
    date
  }

  // Picked up by `typst query` and turned into Jekyll front matter.
  [#metadata((
    title: title,
    description: description,
    subtitle: subtitle,
    date: date-str,
  ))<frontmatter>]

  // Typst's HTML export silently DROPS anything that needs real layout —
  // equations, shapes, CeTZ diagrams. html.frame() renders such content to
  // inline SVG instead. Block frames are block-level in the output, so inline
  // equations get wrapped in a span to keep them inside their paragraph.
  show math.equation.where(block: false): it => html.elem(
    "span",
    html.frame(it),
    attrs: (class: "typst-inline"),
  )
  show math.equation.where(block: true): it => html.elem(
    "div",
    html.frame(it),
    attrs: (class: "typst-block"),
  )

  body
}
