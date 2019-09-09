Hey! Today I'm going to think about converting an operation I perform regularly into a Haskell program. What does that entail? I must figure out the type of the data, the type of the operations which act on that data, and then I must consider the implementation of the operations which satisfy the types. 

Here's a number: `12345 :: [Int]`. Let's say I asked you to start from the left and add one to each digit. 

Now let's say we have: `"abcd" :: [Char]`. I may wish to modify a single character of the buffer repeatedly until some condition is met, then move to another position in the buffer. 

The general pattern: I have an array of elements I am looking to transform with respect to a particular position. 

