> import Prelude hiding (Maybe (..), Functor, fmap, (++), abs)

The `Maybe` data structure is defined in the Prelude (standard library) as such:

> data Maybe a = Just a
>              | Nothing

Data structures are all well and good, but sometimes, we want a function to work on a bunch of different data structures.
For instance, what if I want a function to "run through" a data structure.
and systematically change all type `a` values to type `b` ones? For example:

> transformMaybe :: (a -> b) -> Maybe a -> Maybe b
> transformMaybe f (Just a) = Just (f a)
> transformMaybe _ Nothing = Nothing

> transformList :: (a -> b) -> [a] -> [b]
> transformList f (a:rest) = (f a) : transformList f rest
> transformList _ [] = []

What we really want is some generic function to work for both of these:

< -- f has two parameters: a "transformation" function, and a data structure on which to run it.
< f :: (a -> b) -> DataStructure a -> DataStructure b
< f t d = ???

There's no tool in our toolbox to write this.. yet.
To deal with this, Haskell uses the notion of typeclasses:
The "Functor" typeclass applies to data structures which support the function we want (called `fmap`).

> class Functor f where
>     fmap :: (a -> b) -> f a -> f b

This means that if something would like to be considered a `Functor`, it needs to support the `fmap` function.
To tell Haskell to consider something a `Functor`, we use the `instance` keyword:

> instance Functor Maybe where
>     fmap = transformMaybe

This allows `Maybe` to be considered a `Functor` whenever we want.

> instance Functor [] where
>     fmap = transformList -- identical to the `map` function

The `fmap` function works like any other:

> is :: [Int]
> ds :: [Double]

> is = [1, 2, 3]
> ds = fmap realToFrac is -- `realToFrac` converts a real number to a fractional one

> highScore :: Maybe Double -- A score is Nothing if nobody's played
> roundedHighScore :: Maybe Int
> highScore = Just 123.4
> roundedHighScore = fmap floor highScore

When declaring things, we may optionally add a restriction to the typeclasses of variable-type parameters:

> (<$>) :: Functor f => (a -> b) -> f a -> f b
> (<$>) = fmap

This function will only be valid for a type `f` if `f` has been made an instance of `Functor`.

Typeclasses don't have to just define one function; the `Applicative` typeclass defines two:

> class Functor f => Applicative f where
>     (<*>) :: f (a -> b) -> f a -> f b
>     pure :: a -> f a -- Create an Applicative object
>     (<*) :: f a -> f b -> f a
>     (*>) :: f a -> f b -> f b

Typeclasses may provide default values for some functions; instances of these classes may *choose* to override the default definitions
(usually for performance reasons), but may also provide no definition, in which case the default one will be used.
The `Applicative` typeclass provides default definitions for `(<*)` and `(*>)`

>     (<*) x y = (\a _ -> a) <$> x <*> y -- (const <$> x) <*> y
>     (*>) x y = y <* x

`Maybe` and `[]` are both `Applicative`s, as well as `Functors`:

> instance Applicative Maybe where
>     pure = Just
>     (Just f) <*> (Just x) = Just (f x)
>     _ <*> _ = Nothing

> -- append
> (++) :: [a] -> [a] -> [a]
> (x:xs) ++ ys = x : (xs ++ ys)
> [] ++ ys = ys

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
> highScoreDiff score1 score2 = diff <$> score1 <*> score2
>     where diff x y = abs (x - y)

> crossProduct :: [a] -> [b] -> [(a, b)]
> crossProduct xs ys = makeTuple <$> xs <*> ys
>     where makeTuple x y = (x, y)

This might be a good time to mention that `where` lets you introduce a local "sub-scope".
You can put as many functions, variables, etc. into that subscope, as long as they're all indented equally.

We can also use `let`:

< crossProduct xs ys = let makeTuple x y = (x, y)
<                      in makeTuple <$> xs <*> ys
