{-
  Five Ways to Compute the Cartesian Product with Haskell
  Andrew Ribeiro 
  September 2019
-}

module FiveCartesian where

import Data.List (nub)

-- Comprehension
cp_lc :: [a] -> [b] -> [(a, b)]
cp_lc a b = [ (x,y) | x <- a, y <- b ]

-- Bind
cp_mb :: Monad m => m a -> m b -> m (a, b)
cp_mb a b = a 
             >>= 
               (\x -> b
                 >>= 
                   (\y -> return (x,y)))
          
-- Do
cp_do :: Monad m => m a -> m b -> m (a, b)
cp_do a b = do x <- a
               y <- b
               return (x,y)

-- Applicative
cp_ap :: Applicative f => f a1 -> f a2 -> f (a1, a2)
cp_ap a b = (,) <$> a <*> b

-- Explicit Recursion
cp_ls :: [a] -> [b] -> [(a, b)]
cp_ls a b = cp_ls' a b
            where cp_ls' [] _  = []
                  cp_ls' a' [] = cp_ls' (tail a') b
                  cp_ls' a' b' = (head a', head b') : cp_ls' a' (tail b')

-- Testing the equality of these methods. 
allEqual :: (Eq a) => [a] -> Bool
allEqual = (1==) . length . nub

equalityTest :: (Eq a, Eq b) => [a] -> [b] -> Bool
equalityTest a b = 
  allEqual $ 
    [cp_mb, cp_lc, cp_do, cp_ap, cp_ls] <*> pure a <*> pure b

-- Defining the cartesian product operator.
(✖) :: [a] -> [b] -> [(a, b)]
a ✖ b = cp_do a b -- Try replacing cp_do with different solutions.

main = do
  putStrLn "[1,2,3] ✖ \"abc\" ="
  print $ [1,2,3] ✖ "abc" 
  putStr "\n\nTesting for solution equality..."
  print $ equalityTest [1,2,3] "abc"
  