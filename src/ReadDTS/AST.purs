module ReadDTS.AST where

import Prelude

import Control.Monad.Error.Class (class MonadError, throwError)
import Control.Monad.Except (ExceptT(..), runExcept, runExceptT)
import Control.Monad.Rec.Loops (unfoldrM) as Rec.Loops
import Control.Monad.Rec.Loops (whileJust_)
import Control.Monad.State (StateT, execState, execStateT, runStateT)
import Control.Monad.State.Class (gets, modify_)
import Data.Array (catMaybes)
import Data.Array (catMaybes) as Array
import Data.Array as A
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Bifoldable (class Bifoldable, bifoldMap, bifoldl, bifoldlDefault, bifoldr, bifoldrDefault)
import Data.Bifunctor (class Bifunctor, lmap)
import Data.Bifunctor (lmap) as Bifunctor
import Data.Divide (divided)
import Data.Either (Either(..))
import Data.Eq (class Eq1, eq1)
import Data.Foldable (class Foldable, fold, foldMap, foldlDefault, foldr, foldrDefault)
import Data.FoldableWithIndex (forWithIndex_)
import Data.Functor.Contravariant ((>$<))
import Data.Functor.Mu (Mu(..)) as Mu
import Data.Functor.Mu (Mu(..), roll)
import Data.Generic.Rep (class Generic)
import Data.Lens (Lens, over, use)
import Data.Lens (over) as Lens
import Data.Lens.Record (prop)
import Data.Lens.Setter ((.=), (.~), (%=))
import Data.List (List(..), fromFoldable, singleton) as List
import Data.List (List, (:))
import Data.Map (Map)
import Data.Map (empty, filter, filterKeys, fromFoldable, insert, keys, lookup, singleton, toUnfoldableUnordered, union) as Map
import Data.Maybe (Maybe(..), isJust, isNothing)
import Data.Monoid (guard) as Monoid
import Data.Newtype (un)
import Data.Predicate (Predicate(..))
import Data.Profunctor.Strong ((&&&))
import Data.Set (Set)
import Data.Set (empty, fromFoldable, insert, member) as Set
import Data.Show.Generic (genericShow)
import Data.Traversable (class Traversable, for, sequence, traverse, traverseDefault)
import Data.TraversableWithIndex (forWithIndex, traverseWithIndex)
import Data.Tuple (fst)
import Data.Tuple.Nested ((/\))
import Debug (traceM)
import Effect (Effect)
import Effect.Class (liftEffect)
import Matryoshka (CoalgebraM, anaM, cata)
import ReadDTS (Application, Param, Prop, Props, asTypeRef, readDeclaration, readType, sequenceProp) as ReadDTS
import ReadDTS (Options, Visit, foldMapParam, fqnToString, readRootDeclarationNodes, readRootDeclarations, readType, sequenceParam)
import ReadDTS.TypeScript (getDeclarationStatementFqn)
import Type.Prelude (Proxy(..), SProxy(..))
import TypeScript.Compiler.Program (getTypeChecker)
import TypeScript.Compiler.Types (FullyQualifiedName(..), Typ)
import TypeScript.Compiler.Types (Typ) as TS
import TypeScript.Compiler.Types.Nodes (Declaration, DeclarationStatement) as Nodes
import TypeScript.Compiler.Types.Nodes (DeclarationStatement)
import Unsafe.Coerce (unsafeCoerce)
import Unsafe.Reference (unsafeRefEq)

type Prop decl ref = ReadDTS.Prop (TsType decl ref)

-- | We want this wrapper so we are able to provide basic instances
-- | for it.
-- | Some of them are just required for testing purposes.
newtype TSTyp = TSTyp (TS.Typ ())
instance Show TSTyp where
  show (TSTyp _) = "TSTyp"
instance Eq TSTyp where
  eq (TSTyp t1) (TSTyp t2) = unsafeRefEq t1 t2

data TsType decl ref
  = TsAny
  | TsApplication decl (NonEmptyArray ref)
  | TsArray ref
  | TsBoolean
  | TsBooleanLiteral Boolean
  | TsClass (Array (ReadDTS.Prop ref))
  -- | Function (ReadDTS.Function ref)
  | TsInterface (Array (ReadDTS.Prop ref))
  | TsIntersection (Array ref)
  | TsNull
  | TsNumber
  | TsNumberLiteral Number
  | TsObject (Array (ReadDTS.Prop ref))
  | TsString
  | TsStringLiteral String
  | TsTuple (Array ref)
  | TsParametric ref (NonEmptyArray (ReadDTS.Param ref))
  | TsParameter String
  | TsTypeRef decl
  | TsUndefined
  | TsUnion (Array ref)
  | TsUnknown TSTyp
-- | Void

derive instance functorTsType :: Functor (TsType decl)
derive instance eqTsType :: (Eq decl, Eq ref) => Eq (TsType decl ref)
instance eq1TsType :: Eq decl => Eq1 (TsType decl) where
  eq1 = eq
-- derive instance (Ord decl, Ord ref) => Ord (TsType decl ref)
derive instance genericTsType :: Generic (TsType decl ref) _
instance showTsType :: (Show decl, Show ref) => Show (TsType decl ref) where
  show s = genericShow s

instance Bifunctor TsType where
  bimap f g (TsApplication decl ref) = TsApplication (f decl) (map g ref)
  bimap f _ (TsTypeRef decl) = TsTypeRef (f decl)
  bimap _ g t = unsafeCoerce (map g t)

instance Foldable (TsType decl) where
  foldMap _ TsAny = mempty
  foldMap f (TsArray t) = f t
  foldMap _ TsBoolean = mempty
  foldMap _ (TsBooleanLiteral _) = mempty
  foldMap f (TsClass ts) = foldMap (f <<< _.type) ts
  -- foldMap f (Function r)
  --   = foldMap (foldMap f <<< _.type) r.parameters
  --   <> foldMap f r.returnType
  -- -- foldMap f (Intersection ts) = fold (map (foldMap f) ts)
  foldMap f (TsInterface ts) = foldMap (f <<< _.type) ts
  foldMap f (TsApplication _ ps) = foldMap f ps
  foldMap f (TsIntersection ts) = foldMap f ts
  foldMap _ TsNull = mempty
  foldMap _ TsNumber = mempty
  foldMap _ (TsNumberLiteral _) = mempty
  foldMap f (TsObject ts) = foldMap (f <<< _.type) ts
  foldMap _ (TsParameter _) = mempty
  foldMap f (TsParametric body params) = f body <> foldMap (foldMapParam f) params
  foldMap _ TsString = mempty
  foldMap _ (TsStringLiteral _) = mempty
  foldMap f (TsTuple ts) = foldMap f ts
  foldMap _ (TsTypeRef _) = mempty
  foldMap _ TsUndefined = mempty
  foldMap f (TsUnion ts) = foldMap f ts
  foldMap _ (TsUnknown _) = mempty
  -- foldMap _ Void = mempty

  foldr f t = foldrDefault f t
  foldl f t = foldlDefault f t

instance Bifoldable TsType where
  bifoldMap f _ (TsApplication decl _) = f decl
  bifoldMap f _ (TsTypeRef decl) = f decl
  bifoldMap _ g t = unsafeCoerce (foldMap g t)
  bifoldr f = bifoldrDefault f
  bifoldl f = bifoldlDefault f

instance Traversable (TsType decl) where
  sequence TsAny = pure TsAny
  sequence (TsApplication decl ps) = TsApplication decl <$> sequence ps
  sequence (TsArray t) = TsArray <$> t
  sequence TsBoolean = pure TsBoolean
  sequence (TsBooleanLiteral b) = pure $ TsBooleanLiteral b
  sequence (TsClass props) = map TsClass $ sequence $ map ReadDTS.sequenceProp props
  --   sequence (Function r) = map Function
  --     $ { parameters: _, returnType: _ }
  --     <$> traverse sequenceParameter r.parameters
  --     <*> sequence r.returnType
  --     where
  --       sequenceParameter { name, "type": t } = { name, "type": _ } <$> sequence t
  sequence (TsInterface props) = map TsInterface $ sequence $ map ReadDTS.sequenceProp props
  sequence (TsIntersection ts) = TsIntersection <$> sequence ts
  sequence TsNull = pure TsNull
  sequence TsNumber = pure $ TsNumber
  sequence (TsNumberLiteral n) = pure $ TsNumberLiteral n
  sequence (TsObject props) = map TsObject $ sequence $ map ReadDTS.sequenceProp props
  sequence (TsParameter t) = pure $ TsParameter t
  sequence (TsParametric body params) = TsParametric
    <$> body
    <*> traverse sequenceParam params
  sequence TsString = pure $ TsString
  sequence (TsStringLiteral s) = pure $ TsStringLiteral s
  sequence (TsTuple ts) = TsTuple <$> sequence ts
  sequence (TsTypeRef decl) = pure $ TsTypeRef decl
  sequence TsUndefined = pure TsUndefined
  sequence (TsUnion ts) = TsUnion <$> sequence ts
  sequence (TsUnknown t) = pure $ TsUnknown t
  --   sequence Void = pure Void
  traverse = traverseDefault

type Typ' = TsType TsRef (Typ ())

type TypeDeclaration t = { fqn :: FullyQualifiedName, "type" :: t }

type TsRef =
  { ref :: Nodes.DeclarationStatement
  , fullyQualifiedName :: FullyQualifiedName
  }

visitor :: Visit (TypeDeclaration Typ') Typ'
visitor =
  { onDeclaration: { fqn: _, "type": _ }
  , onType:
      { any: TsAny
      , application: \fqn ref args ->
          TsApplication { fullyQualifiedName: fqn, ref } args
      , array: TsArray
      , boolean: TsBoolean
      , booleanLiteral: TsBooleanLiteral
      , class: TsClass
      , intersection: TsIntersection
      , interface: TsInterface
      , object: TsObject
      , null: TsNull
      , number: TsNumber
      , numberLiteral: TsNumberLiteral
      , parameter: TsParameter
      , parametric: TsParametric
      , string: TsString
      , stringLiteral: TsStringLiteral
      , tuple: TsTuple
      , typeRef: map TsTypeRef <<< { fullyQualifiedName: _, ref: _ }
      , undefined: TsUndefined
      , unknown: TsUnknown <<< TSTyp
      , union: TsUnion
      }
  }

type TsType' = TsType { fullyQualifiedName :: FullyQualifiedName, ref :: Nodes.DeclarationStatement }

type KnownDeclarations = Map FullyQualifiedName (Mu TsType')

type UnknownDeclarations = Map FullyQualifiedName DeclarationStatement

type Context = { current :: Maybe FullyQualifiedName, known :: KnownDeclarations, unknown ::  UnknownDeclarations }

-- seen :: Context -> Set FullyQualifiedName
-- seen { current, known, unknown } = Set.fromFoldable current <> Map.keys known <> Map.keys unknown

type VisitMonad a = ExceptT (Array String) (StateT Context Effect) a

type Seed =
  { level :: Int, ref :: TS.Typ () }

type ReadTsType m = Seed -> m (TsType' (TS.Typ ()))


coalgebra ::
  forall m.
  MonadError (Array String) m =>
  ReadTsType m ->
  CoalgebraM m _ Seed
coalgebra readTsType seed@{ level, ref } = do
  let
    maxDepth = 10
    seed' = { level: level + 1, ref: _ }

  if level < 10 then do
    td <- readTsType seed
    pure $ map seed' td
  else
    throwError [ "Maximum recursion depth (max depth is " <> show maxDepth <> ") in ReadDTS.AST.visitor coalgebra" ]

_unknowns = prop (Proxy :: Proxy "unknowns")
_knowns = prop (Proxy :: Proxy "knowns")
_seen = prop (Proxy :: Proxy "seen")

visit program = do
  let
    checker = getTypeChecker program
    roots = List.fromFoldable $ readRootDeclarationNodes program
    unknowns = map (getDeclarationStatementFqn checker &&& identity) roots
    ctx =
      { unknowns
      , knowns: List.Nil
      , seen: Set.fromFoldable $ map fst unknowns
      }

    getUnknown = do
      use _unknowns >>= case _ of
        head : tail -> do
          _unknowns .= tail
          pure $ Just head
        List.Nil -> pure Nothing

    foldTypeDecls = bifoldMap
      (\{ fullyQualifiedName: fqn, ref } -> List.singleton (fqn /\ ref))
      (identity)
    stripTypeRefs = lmap _.fullyQualifiedName

  flip execStateT ctx $ whileJust_ getUnknown \(fqn /\ node) -> do
    case ReadDTS.readDeclaration checker node of
      Nothing -> throwError ["Problem reading " <> fqnToString fqn ]
      Just { typ } -> do
        typ'@(In _) <- unfoldType checker { level: 0, ref: typ }
        _knowns %= List.Cons (fqn /\ cata (\t -> Mu.In (stripTypeRefs t)) typ')
        for (cata foldTypeDecls typ') \decl@(fqn' /\ _) -> do
          seen <- use _seen
          when (not $ fqn' `Set.member` seen) do
            _seen %= Set.insert fqn'
            _unknowns %= List.Cons decl

unfoldType checker = anaM $ coalgebra \{ level, ref: t } -> pure
  if level == 0
  then ReadDTS.readType checker t [] visitor.onType
  else case ReadDTS.asTypeRef checker t visitor.onType of
    Just t' -> t'
    Nothing -> ReadDTS.readType checker t [] visitor.onType

