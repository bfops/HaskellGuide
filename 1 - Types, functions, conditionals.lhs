Type signatures are specified with `::`, e.g. `int i` becomes

> i :: Int

Note that in Haskell, this will yield a compile-time error unless you also have a line initializing/defining `i` somewhere.

> i = 5

We can also specify type with an expression directly:

> j = 5 :: Int

Type signatures can usually be omitted, but it's good practice to include them,
especially since they're often easier to write than the code, and help you figure out the code.
The compiler may also generate warnings if you have top-level (i.e. global) definitions without type signatures.

All types in Haskell start with Uppercase letters, and all values start with lowercase letters - violating this causes errors.
Some of the available types are Int, Integer, Char, String, Float, Double. These are all like their C equivalents;
Integer is for arbitrary-sized integers.

Conditionals have the form `if b then t else f`

> axiom = if True then "Truth lives!" else "Wait, what just happened?"

Function types use the `->` operator:

> -- fib n = nth fibonacci number; fib 0 = 0, fib 1 = 1
> fib :: Int -> Int

`\x -> ..` is a one-parameter function, whose parameter is named `x`, and whose body is `..`

> fib = \n -> if n <= 1
>             then n
>             else fib (n - 1) + fib (n - 2)

Haskell has support for writing it like this:

< fib n = if n <= 1
<         then n
<         else fib (n - 1) + fib (n - 2)

All functions in Haskell take only one parameter, but we can write seemingly multi-parameter functions like this:

> add :: Int -> Int -> Int
> add x y = x + y

And called like this:

> three :: Int
> three = add 1 2

This is because the `->` operator is right-associative, and function application is left-associative, so the compiler sees `add` as:

< add :: Int -> (Int -> Int)
< add x = \y -> x + y

< three = (add 1) 2

Lambdas can also be written as though they have several parameters:

> sub :: Int -> Int -> Int
> sub = \x y -> x - y

Because every function only has one parameter, we can "partially apply" functions:

> increment :: Int -> Int
> increment = add 1

> two :: Int
> two = increment 1

Operators can also be partially applied, using parentheses:

> double :: Int -> Int
> double = (*2)

Any function can be made infix (i.e. usable like an operator) by putting `` around it:

> one :: Int
> one = 3 `sub` 2

Similarly, operators can be made into regular functions by partially applying with no parameters:

> mult :: Int -> Int -> Int
> mult = (*)

Any function whose name is completely symbols is assumed to be an operator.

Function parameters can be completely ignored with `_`.
If you don't use a parameter anywhere in a function, you should usually replace it with `_`, or you may get compiler warnings.

> always1 :: Int -> Int
> always1 _ = 1

Function type signatures can also include lowercase-starting names for arbitrary types:

> identity :: a -> a
> identity x = x

Function definitions also support pattern-matching against specific parameter values:

> fib2 :: Int -> Int
> fib2 0 = 0
> fib2 1 = 1
> fib2 n = fib (n - 1) + fib (n - 2)

Patterns are matched in top-down order, matching the first one possible.
(Bonus points for identifying how `fib` and `fib2` differ in behavior)
