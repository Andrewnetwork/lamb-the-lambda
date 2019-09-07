---
layout: page
title: About
permalink: /about/
---

Some stuff about functional programming. 
<a href="https://www.twitch.tv/amathematicalway">Hang out on saturdays from 9 - 11 EST.</a>

## ?Name
With monads you often chain together many lambda functions...
```haskell
action1 
    >>= 
        (\x1 -> action2
            >>=
                (\x2 -> action3 
                    >>=
                        (\x3 -> fn x1 x2 x3)))
```
So we have a lambda, lambda, lambda ... and so on. When you say "lambda lambda" it sounds like "lamb the lambda." This combined with the idea of making a cute lamb mascot was the motivation for the blog name 😁. 