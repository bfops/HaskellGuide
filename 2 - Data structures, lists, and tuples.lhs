> import Prelude hiding (String)

Haskell's data structures are similar to C's, in that they just wrap some values.
`struct MyStruct { int x, y; char c }` becomes

> data MyStruct = MyStruct Int Int Char

To create an object of this data structure:

> myObj :: MyStruct
> myObj = MyStruct 1 2 '3'

`union MyUnion { int i; double d; }` can be expressed as

> data MyUnion = MyInt Int
>              | MyDouble Double

`MyInt` and `MyDouble` are the constructors of `MyUnion`.
All constructors of a type can be exported at once using `..`:

< module MyModule ( MyUnion (..) ) where

> myIntObj, myDoubleObj :: MyUnion
> myIntObj = MyInt 1
> myDoubleObj = MyDouble 1.0

Data structures can also be pattern-matched against:

> foo :: MyUnion -> Double
> foo (MyInt i) = realToFrac i  --realToFrac can convert Ints to Doubles
> foo (MyDouble d) = d

They can have types as parameters:

> data Box a = Box a
> box :: Box Int
> box = Box 5

They can also be recursive:

> data List a = Empty
>             | Cons a (List a)

> myList :: List Int
> myList = Cons 1 (Cons 2 (Cons 3 Empty))

Haskell has built-in support for lists like this, but `List a` is `[a]`, `Empty` is `[]`, and `Cons` is `(:)`

> myList2 = 1 : 2 : 3 : []

We're also given this syntax:

> myList3 = [1, 2, 3]
> myList2, myList3 :: [Int]

Anonymous structs (i.e. tuples) can be constructed with a similar syntax:

> myTuple :: (Int, Double, Char)
> myTuple = (1, 1.0, '1')

Both lists and tuples can be pattern-matched against, as expected:

> getFst :: (a, b, c) -> a
> getFst (x, _, _) = x

> getHead :: [a] -> a
> getHead (x:_) = x

Compilers may warn you if your pattern-matching doesn't cover all the bases.
In this case, calling `getHead` with the empty list will cause a runtime error, since there's no match against it. Let's fix that.

> getHead [] = error "You're doing it wrong"

If you're constructing large data structures, you may want to use record syntax:

> data MyRecord = MyRecord { i :: Int
>                          , d :: Double
>                          , c :: Char
>                          }

This is equivalent to

< data MyRecord = MyRecord Int Double Char
< i :: MyRecord -> Int
< d :: MyRecord -> Double
< c :: MyRecord -> Char
< i (MyRecord x _ _) = x
< d (MyRecord _ x _) = x
< c (MyRecord _ _ x) = x

This is especially useful if you have a lot of similarly-typed fields in your data structure.

Types can be "renamed" using the `type` keyword:

> type Ints = [Int]
> xs :: Ints
> ys :: [Int]
> xs = [1, 2, 3]
> ys = xs

In fact, `String` is defined as:

> type String = [Char]

To "copy" a type, but keep it distinct from the original, we can use the `newtype` keyword:

> newtype IntList = IntList [Int]
> getList :: IntList -> [Int]
> getList (IntList l) = l

> zs :: IntList
> zs = IntList xs
> xs' :: Ints
> xs' = getList zs
