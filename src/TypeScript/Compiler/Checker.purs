module TypeScript.Compiler.Checker where

import Prelude

import Data.Function.Uncurried (Fn2, runFn2)
import Data.Maybe (Maybe)
import Data.Nullable (Nullable, toMaybe)
import TypeScript.Compiler.Types (TypeChecker, Node, Typ)

typeToString :: forall r. TypeChecker -> Typ r -> String
typeToString = runFn2 typeToStringImpl

foreign import typeToStringImpl :: forall r. Fn2 TypeChecker (Typ r) String

getSymbolAtLocation :: forall r. TypeChecker -> Node r -> Maybe Symbol
getSymbolAtLocation c = toMaybe <<< runFn2 getSymbolAtLocationImpl c

foreign import getSymbolAtLocationImpl :: forall k. Fn2 TypeChecker (Node k) (Nullable Symbol)

getTypeAtLocation :: forall k. TypeChecker -> Node k -> Maybe (Typ ())
getTypeAtLocation c = toMaybe <<< runFn2 getTypeAtLocationImpl c

foreign import getTypeAtLocationImpl :: forall k. Fn2 TypeChecker (Node k) (Nullable (Typ ()))

getFullyQualifiedName :: TypeChecker -> Symbol -> String
getFullyQualifiedName c = runFn2 getFullyQualifiedNameImpl c

foreign import getFullyQualifiedNameImpl :: Fn2 TypeChecker Symbol String

