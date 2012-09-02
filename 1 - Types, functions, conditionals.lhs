We can indicate the type of a variable (known as a **type signature**) by using `::`.
Translating `int i` from C to Haskell looks like:

> i :: Int

In C, simply declaring an int i is good enough; lack of a definition (initialization) will work, but yield undefined results.
In Haskell, this will yield a compile-time error unless you have a line explicitly initializing/defining `i` somewhere:

> i = 5

We can also specify type with an expression directly:

> j = 5 :: Int

Type signatures can usually be omitted, but it's good practice to include them.
It's also quite often easier to write the type signature of a function than it is to write the code itself,
and it helps give you an overview of how it works.
The compiler may also generate warnings if you have top-level (i.e. global) definitions without type signatures.

Haskell requires that all types have names beginning with Uppercase letters,
and all values (variables and functions) have names which start with lowercase letters.

Some of the types available are Int, Integer, Char, String, Float, Double.
These are act like their C equivalents, with the addition of `Integer` for arbitrarily large integers.

Conditionals take the form `if b then t else f`

> message :: String
> message = if True then "Truth lives!" else "Satan's thermometer is going to need checking"

The type of a function requires use of the `->` symbol:

> -- fib n = nth fibonacci number; fib 0 = 0, fib 1 = 1
> fib :: Int -> Int

`fib` is a variable, and just like `i` or `j`, it needs a value, albeit a value which is a function.
To create a one-parameter function, whose parameter is named `x`, and whose body is `..`, the syntax is `\x -> ..`

Function values are called **lambdas** or **anonymous** functions.

> fib = \n -> if n <= 1
>             then n
>             else fib (n - 1) + fib (n - 2)

Note that `fib` isn't a lambda (it's not anonymous, since it's named `fib`),
but the part after the `=` sign is.

Since functions are (extremely) common in Haskell, we get to use a bit of a shorthand:

> fib2 n = if n <= 1
>          then n
>          else fib2 (n - 1) + fib2 (n - 2)

In Haskell, functions can only take one parameter, so we write "multi-parameter" functions like this:

> add :: Int -> (Int -> Int)
> add x = \y -> x + y

> three :: Int
> three = (add 1) 2

Here, `add` takes a single Int, and then produces a function which will also take a single Int,
and then produce the sum of both.

Rather than thinking of `add` as a function which takes two Ints and produces an Int,
it should be thought of as taking one Int, subsequently taking another, and then producing a value.

There's shorthand here, too; Haskell will assume that functions are being applied left-to-right,
and add in the parentheses correspondingly.

> five :: Int
> five = add 2 3 -- the same as `(add 2) 3`

There's a similar rule for the type signatures as well, this time, from right-to-left:

> addTogether :: Int -> Int -> Int -- the same as `Int -> (Int -> Int)`

Even better, the shorthand for declaring functions extends to "multi-parameter" functions:

> addTogether x y = x + y

Lambdas can also be written as though they have several parameters:

> sub :: Int -> Int -> Int
> sub = \x y -> x - y

Because every function only has one parameter, we can **partially apply** functions:

> increment :: Int -> Int
> increment = add 1

> two :: Int
> two = increment 1 -- like (add 1) 1

Operators can also be partially applied, using parentheses:

> double :: Int -> Int
> double = (* 2)

Any function can be made infix (i.e. usable like an operator) by putting `` around it:

> one :: Int
> one = 3 `sub` 2

Similarly, operators can be made into regular functions by partially applying with no parameters:

> mult :: Int -> Int -> Int
> mult = (*)

Any function whose name is completely made up of symbols is assumed to be an operator (e.g. +, -, <$>, ++, **, ^^)

To ignore a parameter to a function, you can replace the parameter name with an underscore.
If a parameter is unused in a function, you should explicitly ignore it (failing to do so may cause compiler warnings)

> always1 :: Int -> Int
> always1 _ = 1

Function type signatures can also include lowercase-starting type names to represent arbitrary types:

> identity :: a -> a
> identity x = x

Function definitions also support pattern-matching against specific parameter values:

> fib3 :: Int -> Int
> fib3 0 = 0
> fib3 1 = 1
> fib3 n = fib (n - 1) + fib (n - 2)

Patterns are matched in top-down order, matching the first one possible.
(Bonus points for identifying how `fib` and `fib3` differ in behavior)
