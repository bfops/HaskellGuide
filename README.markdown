# The Basics #

All the guide files are literate Haskell files (`.lhs` instead of `.hs`), where `>` denotes the beginning of a line of code,
and anything else is a comment. Convention uses `<` to mean code that shouldn't be actually compiled.

In normal Haskell files (`.hs`), comments can be constructed as follows: `--` as an equivalent for C/C++'s `//` comments,
and `{-...-}` instead of C's `/*...*/` comments.

Whitespace restrictions are pretty minimal, as long as blocks of code in the same scope have consistent indentation.

You can load Haskell files (`.hs` and `.lhs`) through ghci and play with any of the functions given.

    ghci
    > :load [file ..]

If they have an entry point (like `int main` in C/C++), you can also compile Haskell files using GHC:

    ghc [file ..]

# Modules #

Programs in Haskell can be divided into **modules**; separate `.hs` or `.lhs` files are seperate modules.
A module usually starts with a line naming the module:

    module MyModule where

This can be omitted, and the module will assume the name of the file.

Modules **export** some variables/functions (i.e. make them usable from other modules):

    module MyModule ( export1, export2, ...) where

Omitting a list of exports, or omitting the `module` line altogether will export *every* globally-defined
variable or function in the module.

To access exported items from another module, they must first be imported:

    import MyModule (export1)

Omitting an import list will cause all of the exports the module to be imported:

    import MyModule

If we don't like a module's name, we can choose to rename it

    import MyModule as IHateYourStupidModule (export1)

We can also choose to import a module, but leave little pieces out:

    import MyModule hiding (export2)

Entire modules can also be exported; this will cause every symbol imported from the module to be exported.

    module Module1 ( module MyModule ) where

    import MyModule (export1, export2)

When Haskell source files are layered in a directory structure (e.g. src/Wrappers/Graphics/MyModule.hs),
the module names look like this:

    module Wrappers.Graphics.MyModule

Sometimes, multiple modules define things with the same name.
If this happens, we can specify which one we mean by "qualifying" with the module name:

    import Game.Cards.Deck as Deck
    import Wrappers.Graphics.OpenGL

    myDraw = draw -- error! Did you mean Games.Cards.Deck.draw, or Wrappers.Graphics.OpenGL.draw?

    myDraw = Deck.draw -- Much better
    glDraw = Wrappers.Graphics.OpenGL.draw -- also great

We can **require** that every use of a module's import be explicitly qualified,
by using the `qualified` keyword on the module import:

    import Games.Cards.Deck
    import qualified Wrappers.Graphics.OpenGL as GL

    myDraw = draw -- Clearly, Games.Cards.Deck.draw
    glDraw = GL.draw -- Graphics drawing

The Prelude module (part of the standard library) is implicitly imported in Haskell modules.
It can be explicitly imported to only include parts of it.
Future lessons may start with an import of Prelude to hide some stuff that we plan to rewrite in the lesson.
