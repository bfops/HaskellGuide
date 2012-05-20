All the guide files are literate Haskell files (`.lhs` instead of `.hs`), where `>` denotes the beginning of a line of code,
and anything else is a comment. Convention uses `<` to mean code that shouldn't be actually compiled.

You can load these files through ghci and play with any of the functions given.

    ghci
    > :load [file ..]

You can also create your own .hs or .lhs files and compile them in GHC with minimal difficulty:

    ghc [file ..]
