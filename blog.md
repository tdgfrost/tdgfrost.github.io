---
layout: page
title: Blog
permalink: /blog/
description: Notes on reinforcement learning, clinical machine learning, and medicine.
---

Occasional thoughts on the world.

{% if site.posts.size > 0 %}
<ul class="entry-list post-list">
  {% for post in site.posts %}
  <li class="entry">
    <span class="entry-date">{{ post.date | date: "%-d %b %Y" }}</span>
    <span class="entry-body">
      <span class="entry-title"><a href="{{ post.url | relative_url }}">{{ post.title }}</a></span>
      {% if post.description %}<span class="entry-desc">{{ post.description }}</span>{% endif %}
    </span>
  </li>
  {% endfor %}
</ul>
{% else %}
<p>No posts yet.</p>
{% endif %}
