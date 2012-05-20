> import Prelude hiding (abs, otherwise)

Guards are used for functions with multiple conditionals:

> abs :: Int -> Int
> abs n | n <  0    = negate n
>       | n == 0    = 0
>       | otherwise = n

Like pattern-matches, they are evaluated in top-down order, matching the first succeeding one.
The library defines `otherwise`:

> otherwise :: Bool
> otherwise = True

Hoogle is your friend for searching functions, packages, and type signatures: http://www.haskell.org/hoogle/

In general, when you notice common patterns in your code, write a function to abstract it out.
If it seems easy-to-generalize, do it.
If it seems general in any way, search for the type signature on Hoogle and see if someone's created a similar function.

Become familiar with the Prelude and the rest of the standard library. http://hackage.haskell.org/packages/archive/base/latest/doc/html/
All the documentation's thorough, and source code is available for everything.
As long as you know what modules are in there, you'll have a sense for what not to rewrite.

The answer to the bonus-point question at the bottom of lesson 1 is that `fib` produces erroneous results for negative n,
but `fib2` just recurses infinitely. Or until your stack explodes. Whichever happens first.
