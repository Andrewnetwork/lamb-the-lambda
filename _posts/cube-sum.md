---
layout: post
title:  "Cube Sum"
date:   2019-09-05 09:30:44 -0400
categories: haskell basic math
mathjax: true
---
{% if page.mathjax  %}
<script type="text/javascript" async src='https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.2/MathJax.js?config=TeX-MML-AM_CHTML'></script>
{% endif %}

<u><b>Problem:</b></u> Create a function $$f:\mathbb{N} \to [\mathbb{N}]$$ which takes $$n$$ as an input and produces $$n$$ *consecutive odd numbers* whose sum is equal to $$n^3$$.

<u><b>Example:</b></u> $$f(3) = [7,9,11]$$

<div style="text-align:center; margin-bottom:13px;">
    <img src="{{site.baseurl}}/img/div.png" width=300 height=30 />
</div>

{% highlight haskell %}
f :: Int -> [Int]
f n = take n [n * (n - 1) + 1, n * (n - 1) + 3 ..]
{% endhighlight %}
