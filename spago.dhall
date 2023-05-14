{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "my-project"
, dependencies =
  [ "aff"
  , "arrays"
  , "bifunctors"
  , "console"
  , "control"
  , "debug"
  , "effect"
  , "either"
  , "errors"
  , "exceptions"
  , "filterable"
  , "fixed-points"
  , "foldable-traversable"
  , "foreign"
  , "foreign-object"
  , "free"
  , "functions"
  , "identity"
  , "integers"
  , "js-object"
  , "language-cst-parser"
  , "lists"
  , "matryoshka"
  , "maybe"
  , "monad-loops"
  , "newtype"
  , "node-buffer"
  , "node-fs"
  , "node-path"
  , "nullable"
  , "optparse"
  , "ordered-collections"
  , "partial"
  , "pprint"
  , "prelude"
  , "prettier-printer"
  , "profunctor"
  , "profunctor-lenses"
  , "psci-support"
  , "record"
  , "refs"
  , "safe-coerce"
  , "strings"
  , "strings-extra"
  , "test-unit"
  , "tidy-codegen"
  , "transformers"
  , "tuples"
  , "typelevel-prelude"
  , "undefined-is-not-a-problem"
  , "unsafe-coerce"
  , "unsafe-reference"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
