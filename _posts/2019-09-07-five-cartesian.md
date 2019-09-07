---
layout: post
title:  "Five Ways to Compute the Cartesian Product with Haskell"
date:   2019-09-06 09:30:44 -0400
categories: haskell
author: Andrew Ribeiro 
mathjax: true
---

{% if page.mathjax %}
<script type="text/javascript" async src='https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.2/MathJax.js?config=TeX-MML-AM_CHTML'></script>
{% endif %}


- [Introduction](#introduction)
- [1. Comprehension](#1-comprehension)
- [2. Bind](#2-bind)
- [3. Do](#3-do)
- [4. Applicative](#4-applicative)
- [5. Explicit Recursion](#5-explicit-recursion)
- [Test for Equivalence](#test-for-equivalence)
- [Till Next Time](#till-next-time)
- [Exercises](#exercises)


# Introduction 

{% include figure.html src="img/cartesian.png" 
    desc="The cartesian product of [1,2,3] × [1,2,3]" height="230px" width="400px" %}

In [set-builder notation](https://en.wikipedia.org/wiki/Set-builder_notation) from mathematics, the cartesian product is defined as: 

$$ A \times B = \{ (a,b) \ | \ a \in A \wedge b \in B \}$$

What it says in English: the cartesian product of sets *A* and *B* is the set of all tuples where the first element is an element of *A* and the second element is an element of *B*. 

This post contains five Haskell functions which compute the cartesian product using different techniques. My intention is to highlight the diversity and expressiveness Haskell provides and to present a [rosetta code](http://www.rosettacode.org/wiki/Rosetta_Code) which may help you better understand these different techniques by seeing how they each uniquely solve the same problem. 

*Note: An interactive environment with this code is available on [Repl.it](https://repl.it/@Andrewnetwork/Five-Ways-to-Compute-the-Cartesian-Product).*

# 1. Comprehension
```haskell
cp_lc :: [a] -> [b] -> [(a, b)]
cp_lc a b = [ (x,y) | x <- a, y <- b ]
```
Isn't it magnificently delightful that Haskell syntax almost has a direct correspondence to the mathematical notation used to define the cartesian product?! It's like math is coming alive and can actually do for itself what it expresses -- math is the promise, computation is the delivery.

First we should discuss the type of the function `[a] -> [b] -> [(a,b)]`. It states that this function will take a list containing items of type `a` and transform it into a list containing items of type `(a,b)`. This type captures the most general idea of what the cartesian product does and we will see it shared with with the solutions below. 

The terms to the right of `|` are called *generators*. These statements generate the values which are combined by the statement to the left of `|`. The way these values are bound and used to build the output list can be easily expressed by an analogous imperative program:
```javascript
let output = []

for(let ai=0; ai < a.length; ai++){
    for(let bi=0; bi < b.length; bi++){
        output.push( (a[ai],b[bi]) )
    }
}
```
In other words, we bind a value of `a` to `x`, then go through the entire list of `b`, binding each value to `y`, then we move to the next value of `a` and repeat this process until we have computed the cartesian product. List comprehensions are [syntactic sugar](https://wiki.haskell.org/Syntactic_sugar). They describe a computation at a high level, they do not expose us to the actual implementation level details. In fact all methods here except [explicit recursion](#5-explicit-recursion) hide how the result are produced -- in the sense of actually manipulating list values directly. In this sense, Haskell at a higher level becomes more like a declarative language, where we use general interfaces to describe our computations.

You can learn more about list comprehensions [here](https://wiki.haskell.org/List_comprehension). 

# 2. Bind
```haskell
cp_mb :: Monad m => m a -> m b -> m (a, b)
cp_mb a b = a 
             >>= 
               (\x -> b
                 >>= 
                   (\y -> return (x,y)))
```
We're now beginning to take a syntactic sugar diet. Before we talk about the details of the function, let's talk about the type. This solution is more general than the list comprehension solution, because as the name implies, list comprehensions are for lists, whereas this solution is for *monads in general*. Depending on your experience in Haskell, you may be very confused by this. The question I'm hearing is: "Wait a second, how is this function going to work on lists? We don't have a `[]` around `a` or `b` here... what's going on!?" Lists *are* monads, and we can rewrite `[a]` as `[] a`. It so happens that wrapping the brackets around the `a` in the type is syntactic sugar at the type level which just makes type signatures easier to read -- `[] a -> [] b -> [] (a, b)` doesn't look as pretty, right? Also, lists get a special treatment because they are heavily used and all functional languages have a lineage to list processing languages. So even though this solution is more general and works on all monads, it also works on lists, because lists *are* monads. 

The key to understanding this solution is the `>>=` or bind operator. It has the type:

```haskell
(>>=) :: Monad m => m a -> (a -> m b) -> m b
```

It takes a monad `m` that contains an `a`, a function that takes an `a` and puts it inside of `m`, and produces a new `m`. I'm not going to attempt to explain monads in full here. There are plenty of *monad tutorials* out there. I highly recommend learning about them by doing exercises instead of reading about them -- just as I would recommend tasting food if you want to know how it tastes instead of reading food reviews. For this purpose, [The Monad Challenges](https://mightybyte.github.io/monad-challenges/) were an excellent resource in building my understanding of monads. 

Let's look at how `>>=` is defined for the list monad. We can find the definition in the monad instance for list in the [standard prelude](http://hackage.haskell.org/package/base-4.12.0.0/docs/src/GHC.Base.html#line-984). 

```haskell
instance Monad []  where
    xs >>= f = [y | x <- xs, y <- f x]
```
If `m` is a list, this is the definition that would be used; however, this solution allows us to use any monad. Thus, *what the bind actually does is dependent upon the particular monad being used*. This is the power of types. We can reason about this solution at an abstract level without fixing ourself to any particular monad instance. As long as our types line up, we can construct a general solution which works for all monads, and that's what we did here. 

I'm aware of how inadequate this explanation is. It's hard to explain these concepts directly, it is easier to understand them by applying them yourself. 

# 3. Do
```haskell
cp_do :: Monad m => m a -> m b -> m (a, b)
cp_do a b = do x <- a
               y <- b
               return (x,y)
```
[Do notation](https://en.wikibooks.org/wiki/Haskell/do_notation) is just syntactic sugar for what we did in the [bind](#2-bind) solution. You may have noticed that the previous solution looked quite formidable and repeated the same pattern of chaining together lambda functions `\x -> ..`. This solution hides the repetitive details. The `return :: Monad m => a -> m a` function does the same thing it does in the previous solution: it puts `(x,y)` into the monad. We use return instead of explicitly putting `[(x,y)]` because this is a general solution for any monad, not just the list monad.

If you are new to Haskell, you are probably feeling overwhelmed. Sorry! I hope this just gives you the gist of things. It's hard to go into all these details in a single post, but I do promise we are moving on from the monad stuff now. It just gets simpler from here! Hang tight! 

# 4. Applicative
```haskell
cp_ap :: Applicative f => f a1 -> f a2 -> f (a1, a2)
cp_ap a b = (,) <$> a <*> b
```

We're now in [applicative](http://hackage.haskell.org/package/base-4.12.0.0/docs/Control-Applicative.html) land! Just like the monad solutions above, we have a type constraint `Applicative f` which allows us to provide a solution for all applicative instances. You may have guessed it by now, but a list is also an instance of applicative just as it is an instance of monad. In order to make some progress in describing why this is a solution for computing the cartesian product, we're going to assume `f` is a list `[]`. 

Here are the types of the three functions involved here: 
```haskell
(,)   :: a -> b -> (a, b)
(<$>) :: Functor f => (a -> b) -> f a -> f b
(<*>) :: Applicative f => f (a -> b) -> f a -> f b
```
`(,)` is a function that takes two values and makes a tuple out of them. `<$>` is the [infix](https://wiki.haskell.org/Infix_operator) `fmap`. `<*>` is the applicative operator. Without going into too much detail about these functions individually, I will just walk through a particular evaluation of this function. 

```haskell
ls1 = [1,2,3] :: [Int]
ls2 = "abc" :: [Char]
cp_ap ls1 ls2
```
Let's derive the type first. Substituting the type variables for the concrete types we have for this particular application gives us: 

```
cp_ap :: [Int] -> [Char] -> [(Int, Char)]
(,)   :: Int -> Char -> (Int, Char)
(<$>) :: (Int -> Char) -> f a -> [(Int, Char)]
(<*>) :: [Char -> (Int,Char)] -> [Char] -> [(Int, Char)]
```

Now that we see the type we expect to produce `[(Int,Char)]`, let's produce it! This function is evaluated from left to right, so let's evaluate `(,) <$> [1,2,3]` first. This expression maps the tuple generating function over `[1,2,3]` to produce a list of partially applied tuple generating functions through a process called [currying](https://wiki.haskell.org/Currying). If I wrote down `1+`, how would you feel about it? It's clearly missing something, there needs to be another number for me to have a valid addition, `1+` doesn't allow me to produce a result; however, we can think of `1+` as a value of a special kind, namely a function which when given an input adds one to it. So we can fill the hole left by the incomplete addition in many ways, i.e., `1+2`, `1+3`, and so on. 

We are doing the same kind of thing with `(,)`, we are applying it to one argument which produces another function that takes an argument in order to finally evaluate to a tuple. We are mapping the tuple creating function over `[1,2,3]` to produce a list of functions:

```haskell
[\y->(1,y) , \y->(2,y) , \y->(3,y)]
```

These tuples long for a completion that only `<*>` can provide! The type of this list of functions is `[Char -> (Int,Char)]` this is exactly the type `<*>` needs to produce the final result. We apply each function in this list to the entirety of `"abc"` and show an intermediate representation so you can see what is really going on: 

```haskell
[ 
    (\y->(1,y)) 'a', (\y->(1,y)) 'b', (\y->(1,y)) 'c'
    (\y->(2,y)) 'a', (\y->(2,y)) 'b', (\y->(2,y)) 'c'
    (\y->(3,y)) 'a', (\y->(3,y)) 'b', (\y->(3,y)) 'c'
]
```

Then we apply each lambda function to get the final result: 

```haskell
[ 
    (1,'a'),(1,'b'),(1,'c')
    (2,'a'),(2,'b'),(2,'c')
    (3,'a'),(3,'b'),(3,'c')
]
```

Isn't `<*>` cool? Anytime you find yourself thinking about producing a list of functions, `<*>` will come knocking.

# 5. Explicit Recursion
```haskell
cp_ls :: [a] -> [b] -> [(a, b)]
cp_ls a b = cp_ls' a b
            where cp_ls' [] _  = []
                  cp_ls' a' [] = cp_ls' (tail a') b
                  cp_ls' a' b' = (head a', head b') : cp_ls' a' (tail b')
```
Finally we come to the most primitive solution of the lot. I don't mean primitive as an aspersion, but quite literally in the sense that we are using primitive list manipulation techniques and explicit recursion to produce the solution. Not very much is hidden here. If monads are like high level languages, this solution is the Haskell equivalent to assembly language. We're down in the dirt doing everything ourselves, not using any fancy computational interfaces Haskell provides to do all the heavy lifting.

We use a scoped secondary function `cp_ls'` so that we have access to `b` as a global. To explain why this is necessary, let's go through the three cases of the function.

- `cp_ls' [] _  = []` - If `a'` is an empty list, return an empty list. This is our base case. 
-  `cp_ls' a' [] = cp_ls' (tail a') b` - If `b'` is empty, move on the the next `a'` and replenish our `b'` with `b` for the next recursive cycle. 
-  `cp_ls' a' b' = (head a', head b') : cp_ls' a' (tail b')` - This is our tuple construction case. If both `a'` and `b'` have at least a single item, we can construct a tuple by taking the head of each. Then we do tail recursion by calling `cp_ls' a' (tail b')` with the fixed `a'` and tail of `b'`. 
  

# Test for Equivalence
Now that we have all our solutions, let's create a test which tells us if all of our solutions return the same result for the same inputs. 

```haskell
allEqual :: (Eq a) => [a] -> Bool
allEqual = (1==) . length . nub

equalityTest :: (Eq a, Eq b) => [a] -> [b] -> Bool
equalityTest a b = 
  allEqual $ 
    [cp_mb, cp_lc, cp_do, cp_ap, cp_ls] <*> pure a <*> pure b
```

If we are in a superfluous mood --which I am,-- we can even define a special unicode operator for the cartesian product. 

```haskell
(✖) :: [a] -> [b] -> [(a, b)]
a ✖ b = cp_do a b
```
Finally we make a main function which prints out some results and does a test. 

```haskell
main = do
  putStrLn "[1,2,3] ✖ \"abc\" ="
  print $ [1,2,3] ✖ "abc" 
  putStr "\n\nTesting for solution equality..."
  print $ equalityTest [1,2,3] "abc"
```

# Till Next Time 
Thanks for taking the time to read my first Haskell post! I'm still learning a great deal about Haskell and find that [trying to explain what you are learning](https://fs.blog/2012/04/feynman-technique/) has many benefits. What I write here doesn't come from a place of sagacity, but from my passion to understand this fantastic language. I may have made some errors in my exposition or framing of concepts, but my code does compile... so I got that going for me. If you found an error, would like to contribute your solution to the exercises, or anything of the collaborative sort, [please see my page on contributing](https://github.com/Andrewnetwork/lamb-the-lambda/blob/master/contrib.md). 

# Exercises
1. How would you extend these solutions for three lists? 
2. How would you extend these solutions for the general case of a list of lists? 
3. How would you implement the cartesian product in other ways? Could you use other control structures like [Arrow](http://hackage.haskell.org/package/base-4.12.0.0/docs/Control-Arrow.html)?
4. What does the cartesian product produce for other monads and applicatives? For example, `Maybe` is a monad. What does the cartesian product produce for the maybe monad? 
5. How could you use the result of the cartesian product to make a multiplication table?
6. We define the *conditional cartesian product* as: 
   
$$A \overset{p}{\times} B = \{ (a,b) \ | \ a \in A \wedge b \in B \wedge p((a,b))\}$$

<span style="display:block; margin-left:30px;">
Where $$p$$ is a predicate $$p:(A,B) \to Bool$$. How would you modify each of the solutions to compute the conditional cartesian product?
</span>

<div style="text-align:center">
    <a href="https://repl.it/@Andrewnetwork/Five-Ways-to-Compute-the-Cartesian-Product">
        Experiment with this code on Repl.it
    </a>
</div>
