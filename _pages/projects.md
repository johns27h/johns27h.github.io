---
title: "Projects"
permalink: /projects/
layout: collection
---

Here you'll find some test posts I made using RMarkdown, Knitr, and Jekyll. Stay tuned for some more interesting projects!


<h1>Latest Posts</h1>

<ul>
  {% for post in site.posts %}
    <li>
      <h2><a href="{{ post.url }}">{{ post.title }}</a></h2>
      {{ post.excerpt }}
    </li>
  {% endfor %}
</ul>
