---
layout: post
title:  "Digit Counter"
date:   2019-09-05 09:30:44 -0400
categories: haskell basic math
mathjax: true
---
{% if page.mathjax  %}
<script type="text/javascript" async src='https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.2/MathJax.js?config=TeX-MML-AM_CHTML'></script>
{% endif %}

- [Introduction](#introduction)
- [The Counter Type Class](#the-counter-type-class)


# Introduction
Let's say you have a number $$12345$$ 

# The Counter Type Class
We begin with a mystery: the following expression represents the number $$123456$$. Can you figure out what the operators `<+<` and `>+>` mean?
```haskell
DigitCounter 0 0 0 <+< (6,1) >+> (1,2) >+> (1,3) >+> (1,4) >+> (1,5) >+> (1,6)
```
In this post we will 
