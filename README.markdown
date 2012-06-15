# The Basics #

All the guide files are literate Haskell files (`.lhs` instead of `.hs`), where `>` denotes the beginning of a line of code,
and anything else is a comment. Convention uses `<` to mean code that shouldn't be actually compiled.

In normal Haskell files (`.hs`), comments are: `--` as an equivalent for C/C++'s `//` comments, and `{-` and `-}` for C's `/*` and `*/` comments.
Whitespace restrictions are pretty minimal, as long as blocks of code in the same scope have consistent indentation.

You can load Haskell files through ghci and play with any of the functions given.

    ghci
    > :load [file ..]

You can also create your own `.hs` or `.lhs` files and compile them in GHC with minimal difficulty:

    ghc [file ..]

# Modules #

Programs in Haskell can be divided into modules, which are separate `.hs` or `.lhs` files.
A module usually starts with something like:

    module MyModule where

This names the module MyModule. Usually, modules export some functions;
this is analogous to creating a header file in C, in that it allows other modules to access functions defined internally.

    module MyModule ( export1, export2, ...) where

To access things from another module, they must be imported:

    import MyModule

Modules my also export entire other modules:

    module MyModule ( module Module1 ) where

We can also selectively import things, if we don't want the whole module:

    import MyModule (export1)

    import MyModule hiding (export2)

Modules in subdirectories have names like this:

    module Wrappers.Graphics.MyModule

We can optionally shorten them with:

    import Games.Cards.Deck as Deck

Sometimes, multiple modules define the same name. If this happens, we can specify which one we mean by "qualifying" with the module name:

    myDraw = draw -- error! Did you mean Games.Cards.Deck.draw, or Wrappers.Graphics.MyModule.draw?

    myDraw = Deck.draw -- Much better
    gDraw = Wrappers.Graphics.MyModule.draw -- also great

We can force all references to a certain module to be qualified using the `qualified` keyword:

    import qualified Wrappers.Graphics.MyModule as G

    myDraw = draw -- Clearly, Games.Cards.Deck.draw
    gDraw = G.draw -- Graphics drawing

Future lessons may start with a Prelude import (part of the standard library) hiding some stuff, so we can rewrite it later.
