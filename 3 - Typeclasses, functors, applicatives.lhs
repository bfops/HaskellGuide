> import Prelude hiding (Maybe (..), Functor, fmap, (++), abs)

The `Maybe` data structure is defined in the Prelude (standard library) as such:

> data Maybe a = Just a
>              | Nothing

This allows a type-safe way of explaining that a value might.. well, not have a value,
similar to the use of nullptr in C++. It works like our `ErrorVal` type, only without a message.

Sometimes we want to define a function that makes conceptual sense for a variety of types,
but has to be written a little differently for each one.
For instance, there are many different kinds of data structures that can contain values
(list, array, heap, b-tree, etc.). What if we want to apply a function to every element,
regardless of structure?

With our current tools, we'd have to write a slightly different function for each type:

> transformMaybe :: (a -> b) -> Maybe a -> Maybe b
> transformMaybe f (Just a) = Just (f a)
> transformMaybe _ Nothing = Nothing

> transformList :: (a -> b) -> [a] -> [b]
> transformList f (a:rest) = (f a) : transformList f rest
> transformList _ [] = []

Haskell has a notion of **typeclasses**, which act like interfaces in an object-oriented language.
The "Functor" typeclass declares the function we want (called `fmap`):

> class Functor f where
>     fmap :: (a -> b) -> f a -> f b

`f` is the thing that will inherit the `Functor` class.
To actually "inherit" this "interface", we use the `instance` keyword:

> instance Functor Maybe where
>     fmap = transformMaybe

> -- This is not the data value the empty list; this is the list type without an element type,
> -- much like `Maybe` is a Maybe type without an element type.
> instance Functor [] where
>     fmap = transformList

The `fmap` function works like any other:

> is :: [Int]
> ds :: [Double]

> is = [1, 2, 3]
> ds = fmap realToFrac is -- `realToFrac` converts a real number to a fractional one

> highScore :: Maybe Double -- A score is Nothing if nobody's played
> highScore = Just 123.4

> roundedHighScore :: Maybe Int
> roundedHighScore = fmap floor highScore

When declaring functions, we can require that the parameters instantiate certain typeclasses,
by using a `=>`:

> -- Exactly like fmap, but as an operator.
> -- Now I can do things like (1 +) <$> [1, 2, 3] instead of fmap (1 +) [1, 2, 3]
> (<$>) :: Functor f => (a -> b) -> f a -> f b
> (<$>) = fmap

Uses of this function will only be valid for a type `f` if `f` has been made an instance of `Functor`.

Typeclasses don't have to just define one function:

> -- Notice that making something Applicative requires that it be a Functor.
> -- This is analogous to having an interface inherit another interface in OO languages.
> class Functor f => Applicative f where
>     (<*>) :: f (a -> b) -> f a -> f b
>     pure :: a -> f a -- Create an Applicative object
>     (<*) :: f a -> f b -> f a
>     (*>) :: f a -> f b -> f b

Typeclasses may provide default values for some functions; instances of these classes may *choose* to override the default definitions
(usually for performance reasons), but may also provide no definition, in which case the default one will be used.
The `Applicative` typeclass provides default definitions for `(<*)` and `(*>)`

>     -- Just take the first value
>     (<*) x y = ((\a _ -> a) <$> x) <*> y
>     (*>) x y = y <* x

`Maybe` and `[]` are both `Applicative`s:

> instance Applicative Maybe where
>     pure = Just
>     (Just f) <*> (Just x) = Just (f x)
>     _ <*> _ = Nothing

> -- append
> (++) :: [a] -> [a] -> [a]
> (x:xs) ++ ys = x : (xs ++ ys)
> [] ++ ys = ys

> -- Acts like a cross-product of functions and values.
> instance Applicative [] where
>     pure x = [x]
>     (f:fs) <*> xs = (f <$> xs) ++ (fs <*> xs)
>     [] <*> _ = []

`Applicative` becomes easier to understand and use once you see it in combination with `<$>`:

> -- absolute value
> abs :: Int -> Int
> abs x = if x < 0
>         then negate x
>         else x

> highScoreDiff :: Maybe Int -> Maybe Int -> Maybe Int
> highScoreDiff score1 score2 = (diff <$> score1) <*> score2
>     where diff x y = abs (x - y)

The `<$>` and `<*>` operators are left-associative, so the parentheses can be omitted:

> crossProduct :: [a] -> [b] -> [(a, b)]
> crossProduct xs ys = makeTuple <$> xs <*> ys
>     where makeTuple x y = (x, y)

Here, the `where` keyword lets you introduce a local "sub-scope".
You can put as many functions, variables, etc. into that subscope, as long as they're all indented equally.

We can also use `let`:

> crossProduct2 xs ys = let makeTuple x y = (x, y)
>                       in makeTuple <$> xs <*> ys
