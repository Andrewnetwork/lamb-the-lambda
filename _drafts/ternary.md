---
layout: post
title:  "Making a Ternary Operator in Haskell"
date:   2019-09-05 09:30:44 -0400
categories: haskell basic 
mathjax: true
---
{% if page.mathjax  %}
<script type="text/javascript" async src='https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.2/MathJax.js?config=TeX-MML-AM_CHTML'></script>
{% endif %}

`if` statements are a staple of programming. A common use of `if` statements is to set the value of a variable based on some condition. For example, what if we needed to decide what to tip our waiter based on the service they provide. 

```javascript
let tip = 0;

if(service == GOOD){
    tip = .25;
}else{
    tip = .10;
} 
```

Since if statements are [statements](https://en.wikipedia.org/wiki/Statement_(computer_science)), not [expressions](https://en.wikipedia.org/wiki/Expression_(computer_science)), they cannot return a value. We simply use them to conditionally execute different blocks of code. On the other hand, the **ternary** operator is an *expression*, it returns some value. By using the ternary operator, we can rewrite the code above: 

```javascript
let tip = service == GOOD ? .25 : .10
```
In this post I will show how to create a ternary operator in Haskell. Before we get started, I must note that Haskell already has a ternary operator [built in as a primitive](https://www.haskell.org/onlinereport/exps.html#sect3.6). It looks like: 

```haskell
let tip = if service == GOOD then .25 else .10
```

We would like to build our own by defining two operators and using the `Maybe` type. Our maybe will look like this:

```haskell
let tip = "YES" ? 0.25 <|> 0.25
```
The only change from the Javascript ternary operator is that we swap `:` for `<|>` because `:` is used in Haskell to denote the [cons](https://en.wikipedia.org/wiki/Cons) operator. 

```haskell
(?) :: Bool -> a -> Maybe a
True  ? x = Just x
False ? _ = Nothing 
infixl 3 ?

(<|>) :: Maybe a -> a -> a
Nothing <|> x = x 
Just x  <|> _ = x
infixl 3 <|>
```
The boolean value is used to conditionally construct a value of type `Maybe`. If the condition is `True`, then we wrap the value for the true condition in `Just x`. Conversely, if the condition is *False*, we return `Nothing` because we are discarding this first value, as it was intended to be returned only if the condition was `True`. The `<|>` operator takes the `Maybe` we construct with `?` and handles two cases: 
1. If the condition was `True`, then we ignore the second value in the ternary operator and return the first value -- the value after `<|>`.
2. If the condition was `False`, then we ignore the first value in the ternary operator and return the second value. 

TODO: Note about infix. 

Now that we have replicated the behavior of the standard ternary operator, is there anything else we can do with the operators we created? 

