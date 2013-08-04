> import Prelude hiding (putStrLn)

In Haskell, IO computations are done through Monads. The changing context in an IO computation
is the (changing) stateful, external world surrounding the program.

> -- putStr :: String -> IO ()
> putStrLn :: String -> IO ()
> putStrLn s = putStr s >> putStr "\n"

The () type is a zero-tuple, and is commonly used as a "void" type.
In general, the type signature `IO a` can be understood as a value of type `a`
that's dependent on the world state.

The `>>=` function can be thought of as taking a value in the context of the state,
and using it to create a new world state with a new value.

IO is often done using do-notation:

> -- getLine :: IO String

> main :: IO ()
> main = do
>           putStr "Enter a string: "
>           s <- getLine
>           putStrLn ("You said " ++ s)

Now you can finally write hello world.
