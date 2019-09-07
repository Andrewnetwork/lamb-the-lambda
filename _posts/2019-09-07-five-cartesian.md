---
layout: post
title:  "Five Ways to Compute the Cartesian Product"
date:   2019-09-06 09:30:44 -0400
categories: haskell
mathjax: true
---

- [Introduction](#introduction)
- [1. Comprehension](#1-comprehension)
- [2. Do](#2-do)
- [3. Bind](#3-bind)
- [4. Applicative](#4-applicative)
- [5. Recursion](#5-recursion)


# Introduction 

{% include figure.html src="img/cartesian.png" 
    desc="The cartesian product of [1,2,3] × [1,2,3]" height="230px" width="400px" %}


# 1. Comprehension
```haskell
cp_lc :: [b] -> [(b, b)]
cp_lc ls = [ (x,y) | x <- ls, y <- ls ]
```

# 2. Do
```haskell
cp_do :: Monad m => m b -> m (b, b)
cp_do ls = do x <- ls
              y <- ls
              return (x,y)
```

# 3. Bind
```haskell
cp_mb :: Monad m => m b -> m (b, b)
cp_mb ls = ls 
            >>= 
              (\x -> ls
                >>= 
                  (\y -> return (x,y)))
```

# 4. Applicative
```haskell
cp_ap :: Applicative f => f a -> f (a, a)
cp_ap ls = (,) <$> ls <*> ls
```

# 5. Recursion
```haskell
cp_ls :: [a] -> [(a,a)]
cp_ls ls = concat $ cp_ls' ls 
           where cp_ls' (x:xs) = (((,) x) <$> ls) : cp_ls' xs
                 cp_ls' [] = []
```



<div style="text-align:center">
    <a href="https://repl.it/@Andrewnetwork/Five-Ways-to-Compute-the-Cartesian-Product">
        Experiment with this code on Repl.it
    </a>
</div>