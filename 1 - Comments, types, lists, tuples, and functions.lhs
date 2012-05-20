The Haskell equivalent of C's `//` for single-line comments is `--`
`/*` and `*/` become `{-` and `-}`
The only big whitespace restriction is that your indentation has to be consistent for blocks of code with the same scope.
Type signatures are specified with `::`, e.g. `int i` becomes

> i :: Int

Note that in Haskell, this will yield a compile-time error unless you also have a line initializing/defining `x` somewhere.

> i = 5

Type signatures can usually be omitted, but it's good practice to include them,
especially since they're often easier to write than the code, and help you figure out the code.
The compiler may also generate warnings if you have top-level (i.e. global) definitions without type signatures.

All types in Haskell start with Uppercase letters, and all values start with lowercase letters - violating this causes errors.
Some of the available types are Int, Integer, Char, String, Float, Double. These are all like their C equivalents;
Integer is for arbitrary-sized integers.

Function type signatures use the `->` operator:

> -- fib n = nth fibonacci number; fib 0 = 0, fib 1 = 1
> fib :: Int -> Int

Conditionals have the form `if b then t else f`

> fib = \n -> if n <= 1
>             then n
>             else fib (n - 1) + fib (n - 2)

`\x -> ..` is a one-parameter lambda, whose parameter is named `x`, and whose body is `..`
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

This is because the `->` operator is right-associative, and function application is left-associative, i.e. the example becomes

< add :: Int -> (Int -> Int)
< add x = \y -> x + y

< three = (add 1) 2

Because of this, functions can be partially applied, i.e.

> add1 :: Int -> Int
> add1 = add 1

> two :: Int
> two = add1 1

Operators can also be partially applied, using parentheses:

> double :: Int -> Int
> double = (*2)

Lambdas can also have several parameters:

> sub :: Int -> Int -> Int
> sub = \x y -> x - y

Any function can be made infix (i.e. usable like an operator) by putting `` around it:

> one :: Int
> one = 3 `sub` 2

Similarly, operators can be made into regular functions by partially applying with no parameters:

> mult :: Int -> Int -> Int
> mult = (*)

Any function whose name is completely symbols is assumed to be an operator.

Lists can be constructed using the cons operator `:`. The empty list is `[]`.

> list1 = 1 : []
> list21 = 2 : list1
> list12 = 1 : 2 : []

Haskell provides us a short form for lists:

> list123 = [1, 2, 3]

A similar short form exists for tuples:

> myTuple :: (Int, Char, String)
> myTuple = (0, '0', "0")

`String` is actually just defined as `[Char]`

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

(Bonus points for identifying how `fib` and `fib2` differ in behavior)

Pattern-matching also works on tuples and lists:

> getFst :: (a, b, c) -> a
> getFst (x, _, _) = x

> getHead :: [a] -> a
> getHead (x:_) = x

It would be a big mistake to write:

< getHead [x:_] = x

This is pattern-matching against a list with one element, and that element is a list whose head becomes `x`.
That's not what you wanted.

Compilers may generate warnings if your pattern-matches don't cover all your bases.
Notice above, that if I call `getHead` with the empty list, it doesn't have a definition to cover that.

> getHead [] = error "You're doing it wrong"

Much better.

