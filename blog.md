---
layout: page
title: Blog
permalink: /blog/
description: Notes on reinforcement learning, clinical machine learning, and medicine.
---

Occasional thoughts
{% if site.posts.size > 0 %}
<ul class="entry-list post-list">
  {% for post in site.posts %}
  {%- comment -%}
    Jekyll derives the title and date from the filename when they are absent
    from the front matter, and the preview below falls back to the post's own
    opening text — so a new file in _posts needs no front matter at all.
    This preview uses `description`; a post's own page prefers `subtitle`, so
    the two can differ.
  {%- endcomment -%}
  {%- assign entry_desc = post.description | default: post.excerpt -%}
  {%- assign entry_desc = entry_desc | strip_html | normalize_whitespace | truncate: 200 -%}
  <li class="entry">
    <span class="entry-date">{{ post.date | date: "%-d %b %Y" }}</span>
    <span class="entry-body">
      <span class="entry-title"><a href="{{ post.url | relative_url }}">{{ post.title }}</a></span>
      {% if entry_desc != "" %}<span class="entry-desc">{{ entry_desc }}</span>{% endif %}
    </span>
  </li>
  {% endfor %}
</ul>
{% else %}
<p>No posts yet.</p>
{% endif %}
