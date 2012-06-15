> import Prelude hiding (Maybe (..), Functor, fmap, (++), abs)

The `Maybe` data structure is defined in the Prelude (standard library) as such:

> data Maybe a = Just a
>              | Nothing

Data structures are all well and good, but sometimes, we want a function to work on a bunch of different data structures.
For instance, what if I want a function to "run through" a data structure.
and systematically change all type `a` to type `b`?

< -- f has two parameters: a "transformation" function, and a data structure on which to run it.
< f :: (a -> b) -> DataStructure a -> DataStructure b
< f t d = ???

There's no tool in our toolbox yet to write this.
We want to be able to treat distinct data structures the same way, in certain contexts.

To deal with this, Haskell uses the notion of typeclasses:
The "Functor" typeclass applies to data structures which support the function we want (called `fmap`).

> class Functor f where
>     fmap :: (a -> b) -> f a -> f b

This means that if something would like to be considered a Functor, it needs to support the `fmap` function.
To tell Haskell to consider something a Functor, we do this:

> instance Functor Maybe where
>     fmap _ Nothing = Nothing
>     fmap f (Just x) = Just (f x)

> instance Functor [] where
>     fmap _ [] = []
>     fmap f (x:xs) = f x : fmap f xs -- This is identical to the `map` function for lists.

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

Typeclasses can also provide default values for functions; instances still have the option of overriding it.
The Applicative typeclass requires that instances provide a `<*>` operator:

> class Functor f => Applicative f where
>     (<*>) :: f (a -> b) -> f a -> f b

But there's more than that:

>     pure :: a -> f a
>     (<*) :: f a -> f b -> f a
>     (*>) :: f a -> f b -> f b
>     (<*) x y = (\a _ -> a) <$> x <*> y -- (const <$> x) <*> y
>     (*>) x y = y <* x

The `pure` function makes something into an Applicative object:

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

It becomes easier to use once you see it in combination with `<$>`:

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
