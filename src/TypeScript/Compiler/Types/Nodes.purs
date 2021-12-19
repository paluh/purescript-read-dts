module TypeScript.Compiler.Types.Nodes where

import Data.Undefined.NoProblem (Opt)
import TypeScript.Compiler.Types (Node, ScriptTarget, Typ)
import Unsafe.Coerce (unsafeCoerce)

interface :: forall k. Node k -> { | k }
interface = unsafeCoerce

foreign import getChildren :: forall k. Node k -> Array (Node ())

-- | Semiautomatically generated stubs which are required
-- | by `Compiler.Factory.NodeTests`.
-- | Every such alias makes no sens on its own
-- | be if we fill it makes `NodeTests` functions
-- | really useful.
type AbstractKeyword = Node ()
type ArrayBindingPattern = Node ()
type ArrayLiteralExpression = Node ()
type ArrayTypeNode = Node ()
type ArrowFunction = Node ()
type AsExpression = Node ()
type AssertClause = Node ()
type AssertEntry = Node ()
type AssertsKeyword = Node ()
type AsteriskToken = Node ()
type AsyncKeyword = Node ()
type AwaitExpression = Node ()
type AwaitKeyword = Node ()
type BigIntLiteral = Node ()
type BinaryExpression = Node ()
type BindingElement = Node ()
type Block = Node ()
type BreakStatement = Node ()
type Bundle = Node ()
type CallExpression = Node ()
type CallSignatureDeclaration = Node ()
type CaseBlock = Node ()
type CaseClause = Node ()
type CatchClause = Node ()
-- | This approximation is probably enough
-- | given `Compalier.Factory.asClassExpression`
-- | and `Compalier.Factory.asClassDeclaration`
type ClassDeclaration = ClassLikeDeclaration
type ClassElement = Node (name :: PropertyName)
type ClassExpression = ClassLikeDeclaration
type ClassLikeDeclaration = Node
  ( name :: Opt Identifier
  , typeParameters :: Array TypeParameterDeclaration
  -- , heritageClauses?: NodeArray<HeritageClause>;
  , members :: Array ClassElement
  )

type ClassStaticBlockDeclaration = Node ()
type Clauses = Node ()
type ColonToken = Node ()
type CommaListExpression = Node ()
type ComputedPropertyName = Node ()
type ConditionalExpression = Node ()
type ConditionalTypeNode = Node ()
type ConstructSignatureDeclaration = Node ()
type ConstructorDeclaration = Node ()
type ConstructorTypeNode = Node ()
type ContinueStatement = Node ()
type DebuggerStatement = Node ()
type Declaration = Node ()
type Decorator = Node ()
type DefaultClause = Node ()
type DeleteExpression = Node ()
type DoStatement = Node ()
type DotDotDotToken = Node ()
type ElementAccessExpression = Node ()
type Elements = Node ()
type EmptyStatement = Node ()
type EndOfDeclarationMarker = Node ()
type Enum = Node ()
type EnumDeclaration = Node ()
type EnumMember = Node ()
type EqualsGreaterThanToken = Node ()
type ExclamationToken = Node ()
type ExportAssignment = Node ()
type ExportDeclaration = Node
  ( parent :: Node () -- SourceFile | ModuleBlock;
  -- , exportClause ∷ NamedExports;
  -- , moduleSpecifier?: Expression;
  )

type ExportKeyword = Node ()
type ExportSpecifier = Node ()
type Expression = Node ()
type ExpressionStatement = Node ()
type ExpressionWithTypeArguments = Node ()
type ExternalModuleReference = Node ()
type ForInStatement = Node ()
type ForOfStatement = Node ()
type ForStatement = Node ()
type FunctionDeclaration = Node ()
type FunctionExpression = Node ()
type FunctionTypeNode = Node ()
type GetAccessorDeclaration = Node ()
type HeritageClause = Node ()
type Identifier = Node ()
type Identifiers = Node ()
type IfStatement = Node ()
type ImportClause = Node ()
type ImportDeclaration = Node ()
type ImportEqualsDeclaration = Node ()
type ImportExpression = Node ()
type ImportSpecifier = Node ()
type ImportTypeNode = Node ()
type IndexSignatureDeclaration = Node ()
type IndexedAccessTypeNode = Node ()
type InterfaceDeclaration = Node
  ( name :: Identifier
  , typeParameters :: Array TypeParameterDeclaration
  -- , heritageClauses?: NodeArray<HeritageClause>;
  , members :: Array TypeElement
  )

type InferTypeNode = Node ()
type IntersectionTypeNode = Node ()
type JSDoc = Node ()
type JSDocAllType = Node ()
type JSDocFunctionType = Node ()
type JSDocLink = Node ()
type JSDocLinkCode = Node ()
type JSDocLinkPlain = Node ()
type JSDocMemberName = Node ()
type JSDocNameReference = Node ()
type JSDocNamepathType = Node ()
type JSDocNonNullableType = Node ()
type JSDocNullableType = Node ()
type JSDocOptionalType = Node ()
type JSDocSignature = Node ()
type JSDocTypeExpression = Node ()
type JSDocTypeLiteral = Node ()
type JSDocUnknownType = Node ()
type JSDocVariadicType = Node ()
type JSX = Node ()
type JsxAttribute = Node ()
type JsxAttributes = Node ()
type JsxClosingElement = Node ()
type JsxClosingFragment = Node ()
type JsxElement = Node ()
type JsxExpression = Node ()
type JsxFragment = Node ()
type JsxOpeningElement = Node ()
type JsxOpeningFragment = Node ()
type JsxSelfClosingElement = Node ()
type JsxSpreadAttribute = Node ()
type JsxText = Node ()
type LabeledStatement = Node ()
type LiteralTypeNode = Node ()
type MappedTypeNode = Node ()
type MergeDeclarationMarker = Node ()
type MetaProperty = Node ()
type MethodDeclaration = Node ()
type MethodSignature = Node ()
type MinusToken = Node ()
type Misc = Node ()
type MissingDeclaration = Node ()
type ModuleBlock = Node ()
type ModuleDeclaration = Node ()
type NamedExports = Node ()
type NamedImports = Node ()
type NamedTupleMember = Node ()
type Names = Node ()
type NamespaceExport = Node ()
type NamespaceExportDeclaration = Node ()
type NamespaceImport = Node ()
type NewExpression = Node ()
type NoSubstitutionTemplateLiteral = Node ()
type NonNullExpression = Node ()
type NotEmittedStatement = Node ()
type NumericLiteral = Node ()
type ObjectBindingPattern = Node ()
type ObjectLiteralExpression = Node ()
type OmittedExpression = Node ()
type OptionalTypeNode = Node ()
type ParameterDeclaration = Node ()
type ParenthesizedExpression = Node ()
type ParenthesizedTypeNode = Node ()
type PartiallyEmittedExpression = Node ()
type PropertyName = Node ()
type PlusToken = Node ()
type PostfixUnaryExpression = Node ()
type PrefixUnaryExpression = Node ()
type PrivateIdentifier = Node ()
type PropertyAccessExpression = Node ()
type PropertyAssignment = Node ()
type PropertyDeclaration = Node ()
type PropertySignature = Node ()
type Punctuation = Node ()
type QualifiedName = Node ()
type QuestionDotToken = Node ()
type QuestionToken = Node ()
type ReadonlyKeyword = Node ()
type References = Node ()
type RegularExpressionLiteral = Node ()
type RestTypeNode = Node ()
type ReturnStatement = Node ()
type SemicolonClassElement = Node ()
type SetAccessorDeclaration = Node ()
type ShorthandPropertyAssignment = Node ()
type SourceFile = Node
  ( isDeclarationFile :: Boolean
  , fileName :: String
  , moduleName :: Opt String
  , statements :: Array Statement
  , text :: String
  , languageVersion :: ScriptTarget
  )

type SpreadAssignment = Node ()
type SpreadElement = Node ()
type Statement = Node ()
type StaticKeyword = Node ()
type StringLiteral = Node ()
type SuperExpression = Node ()
type SwitchStatement = Node ()
type SyntheticExpression = Node ()
type SyntaxList = Node (_children :: Array (Node ()))
type SyntheticReferenceExpression = Node ()
type TaggedTemplateExpression = Node ()
type TemplateExpression = Node ()
type TemplateHead = Node ()
type TemplateLiteralTypeNode = Node ()
type TemplateLiteralTypeSpan = Node ()
type TemplateMiddle = Node ()
type TemplateSpan = Node ()
type TemplateTail = Node ()
type ThisTypeNode = Node ()
type ThrowStatement = Node ()
type TokenNode = Node ()
type TryStatement = Node ()
type TupleTypeNode = Node ()
type TypeAliasDeclaration = Node
  ( name :: Identifier
  , typeParameters :: Array TypeParameterDeclaration
  , "type" :: Typ ()
  )

type TypeAssertion = Node ()
type TypeElement = Node
  ( name :: PropertyName
  , questionToken :: Opt TokenNode
  )

type TypeLiteralNode = Node ()
type TypeMember = Node ()
type TypeNode = Node ()
type TypeOfExpression = Node ()
type TypeOperatorNode = Node ()
type TypeParameterDeclaration = Node
  ( name :: Identifier
  , constraint :: Opt TypeNode
  , default :: Opt TypeNode
  )

type TypePredicateNode = Node ()
type TypeQueryNode = Node ()
type TypeReferenceNode = Node ()
type UnionTypeNode = Node ()
type Unparsed = Node ()
type UnparsedPrepend = Node ()
type UnparsedSource = Node ()
type VariableDeclaration = Node ()
type VariableDeclarationList = Node ()
type VariableStatement = Node ()
type VoidExpression = Node ()
type WhileStatement = Node ()
type WithStatement = Node ()
type Words = Node ()
type YieldExpression = Node ()
