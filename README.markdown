All the guide files are literate Haskell files (.lhs instead of .hs), where you have special characters to denote code,
instead of special characters to denote comments.

You can load these files through ghci and play with any of the functions given.

    ghci
    > :load [file ..]

You can also create your own .hs or .lhs files and compile them in GHC with minimal difficulty:

    ghc [file ..]
