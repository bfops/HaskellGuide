> import Prelude hiding (String)

Haskell data structures are POD (plain-ol'-data) types, similar to structs in C.
Creating a structure with one `Int` member, and one `Char` member looks like:

> data MyStruct = MakeStruct Int Char

`MyStruct` is now a type, and can be used as such.
Additionally, there is now a function (a **constructor**, to be specific)
called `MakeStruct` which can be used to create `MyStruct`s.

> myObj :: MyStruct
> myObj = MakeStruct 1 'a'

Note that although `MakeStruct` is a function, it begins with a capital letter - all constructors do.

Datatypes can also have parameters; these parameters aren't values, but types:

> data Box a = Box a
> box :: Box Int
> box = Box 5

Sometimes we want to express data which can be in one of several distinct states.
Consider computations which may or may not result in an error: they might give a value of the type you expected, or give you an error.
(C often handles this with "special" values which represent errors, like NULL pointers).

> data ErrorVal a = Value a
>                 | Error String -- ^ Error message

> divide :: Int -> Int -> ErrorVal Int
> divide _ 0 = Error "Divide by zero"
> divide x y = Value (x `div` y)

If we want to export a type, as well as *all* its constructors, we can export the type with `(..)` after it:

< module MyModule ( ErrorVal (..) ) where

Like other values, data structures can be used in pattern-matching:

> wasSuccessful :: ErrorVal a -> Bool
> wasSuccessful (Value _) = True
> wasSuccessful (Error _) = False

Data definitions may refer to themselves:

> data List a = Empty
>             | Cons a (List a)

> myList :: List Int
> myList = Cons 1 (Cons 2 (Cons 3 Empty)) -- The list [1, 2, 3]

Haskell has built-in lists, but we have a little special syntax instead of `List` and `Cons`.

> myList2 :: [Int]
> myList2 = 1 : 2 : 3 : [] -- The list [1, 2, 3]

Haskell also gives us some shortcut syntax for creating lists from scratch:

> myList3 = [1, 2, 3] :: [Int]

We can create **tuples** (anonymous data structures) with a similar syntax:

> myTuple :: (Int, Double, Char)
> myTuple = (1, 1.0, '1')

Both lists and tuples can be pattern-matched against, as expected:

> getFst :: (a, b, c) -> a
> getFst (x, _, _) = x

> getHead :: [a] -> ErrorVal a
> getHead (x:_) = Value x
> getHead [] = Error "You're doing it wrong"

> is123 :: [Int] -> Bool
> is123 [1, 2, 3] = True

Compilers may warn you if your pattern-matching doesn't cover all the bases.
In this case, calling `is123` with any list which isn't [1, 2, 3] will cause a runtime error.
We can fix this by adding a case for other lists:

> is123 _ = False

Haskell can also create accessor functions for our data types automatically.
This is known as **record syntax**:

> data MyRecord = MyRecord { i :: Int
>                          , d :: Double
>                          , c :: Char
>                          }

This is equivalent to definition a data structure `MyRecord`:

< data MyRecord = MyRecord Int Double Char

Additionally, it creates several "accessor" functions:

< i :: MyRecord -> Int
< d :: MyRecord -> Double
< c :: MyRecord -> Char

< i (MyRecord x _ _) = x
< d (MyRecord _ x _) = x
< c (MyRecord _ _ x) = x

This is especially useful if you have a lot of similarly-typed fields in your data structure.

Types can be copied using the `type` keyword:

> type Ints = [Int]
> xs :: Ints
> ys :: [Int]
> xs = [1, 2, 3]
> ys = xs

Prelude actually defines the `String` type as:

> type String = [Char]

To clone" a type, but keep it distinct from the original, we can use the `newtype` keyword:

> newtype IntList = IntList [Int]
> getList :: IntList -> [Int]
> getList (IntList l) = l

> zs :: IntList
> zs = IntList xs
> xs' :: Ints
> xs' = getList zs -- equivalent to `xs`

Here, it would be an error to type something like `xs' = zs`, since `IntList` and `Ints` are distinct types.
