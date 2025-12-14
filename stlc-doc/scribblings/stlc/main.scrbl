#lang scribble/manual

@title{simply-typed λcalculus in racket}
@author{lμthenwałd}

@(require racket/match
          scribble/manual/lang)

@(define (type-expr? v)
   (match v
      ['Int #t]
      ['Bool #t]
      [`(-> ,d ,r) (and (type-expr? d) (type-expr? r))]
      [`(* ,l ,r) (and (type-expr? l) (type-expr? r))]
      [_ #f]))

@defmodulelang[stlc]

this is an implementation of the @hyperlink["https://en.wikipedia.org/wiki/Simply_typed_lambda_calculus"]{simply-typed λ-calculus}
(stlc) in racket. it provides a minimal, statically-typed functional language with integers, booleans, functions, products,
and primitive operations.

the language enforces strict typing rules at compile time and uses
@hyperlink["https://en.wikipedia.org/wiki/Evaluation_strategy#Call_by_value"]{call-by-value} evaluation.
internal representation uses @hyperlink["https://en.wikipedia.org/wiki/De_Bruijn_sequence"]{de bruijn}
indices for correct variable handling and alpha-equivalence.

@section{installation}

to install the package as a local collection:

@commandline{just install}

this links the local packages into your racket installation. then compile:

@commandline{just setup}

to run the test suite:

@commandline{just test}

to build this documentation:

@commandline{just doc}

@section{quick start}

to use @racketmodname[stlc] as a language:

@codeblock{
#lang stlc

(typeof (λ (x Int) x))
(eval ($ (λ (x Int) (+ x 1)) 10))
}

the language provides two main entry points: @racket[typeof] for type checking and @racket[eval] for evaluation.

@section{api index}

this section provides a quick reference to all available forms, procedures, types, and identifiers in @racketmodname[stlc].

@subsection{types}

@itemlist[
@item{@racket[Int] — integer type}
@item{@racket[Bool] — boolean type}
@item{@racket[(-> type type)] — function type constructor}
@item{@racket[(* type type)] — product type constructor}
]

@subsection{literals}

@itemlist[
@item{@racket[true] — boolean true}
@item{@racket[false] — boolean false}
@item{integer literals — standard racket integers}
]

@subsection{forms}

@itemlist[
@item{@racket[(λ (var type) term)] — lambda abstraction}
@item{@racket[($ term term)] — function application}
@item{@racket[(if term term term)] — conditional expression}
@item{@racket[(let (var term) term)] — local binding}
@item{@racket[(pair term term)] — pair construction}
@item{@racket[(fst term)] — first projection}
@item{@racket[(snd term)] — second projection}
]

@subsection{operators}

arithmetic (return @racket[Int]):
@itemlist[
@item{@racket[(+ term term)]}
@item{@racket[(- term term)]}
@item{@racket[(* term term)]}
@item{@racket[(/ term term)]}
]

comparison (return @racket[Bool]):
@itemlist[
@item{@racket[(= term term)]}
@item{@racket[(< term term)]}
@item{@racket[(> term term)]}
@item{@racket[(<= term term)]}
@item{@racket[(>= term term)]}
]

@subsection{procedures}

@itemlist[
@item{@racket[(typeof term)] — returns the type of a term}
@item{@racket[(eval term)] — evaluates a term and returns its value}
]

@section{type-level syntax}

the type system includes base types and type constructors:

@verbatim|{
type ::= Int
      |  Bool
      |  (-> type type)
      |  (* type type)
}|

@defthing[Int 'Int]{
the type of integers.
}

@defthing[Bool 'Bool]{
the type of boolean values (@racket[true] and @racket[false]).
}

@defform[(-> type type)]{
function type constructor. the first @racket[type] is the domain, the second is the range.
}

@defform[(* type type)]{
product type constructor. represents pairs of values.
}

@section{term-level syntax}

@verbatim|{
term ::= integer
      |  true
      |  false
      |  var
      |  (λ (var type) term)
      |  ($ term term)
      |  (if term term term)
      |  (let (var term) term)
      |  (pair term term)
      |  (, term term)
      |  (fst term)
      |  (snd term)
      |  (op term term)

op   ::= + | - | * | / | = | < | > | <= | >=
}|

@subsection{term literals}

@defthing[true 'Bool]{
boolean literal representing truth.
}

@defthing[false 'Bool]{
boolean literal representing falsity.
}

@defthing[integer 'Int]{
integer literal.
}
integer literals are written as standard racket integers.

@subsection{functions}

@defform[(λ (var type) term)]{
lambda abstraction. binds @racket[var] with type @racket[type] in @racket[term].
}

@defform[($ term term)]{
function application. applies the first term (function) to the second term (argument).
}

@subsection{conditionals}

@defform[(if term term term)]{
conditional expression. the first term must evaluate to a boolean. the second and third terms must have the same type.
}

@subsection{let bindings}

@defform[(let (var term) term)]{
local binding. binds @racket[var] to the value of the first @racket[term] in the second @racket[term].
}

@subsection{products}

@defform[(pair term term)]{
pair construction. creates a product value from two terms.
}

@defform[(fst term)]{
first projection. extracts the first component of a product.
}

@defform[(snd term)]{
second projection. extracts the second component of a product.
}

@subsection{term operators}

arithmetic operators require integer arguments and return integers:

@defform[(+ term term)]
@defform[(- term term)]
@defform/none[(* term term)]
@defform[(/ term term)]

division uses integer division (quotient).

comparison operators require integer arguments and return booleans:

@defform[(= term term)]
@defform[(< term term)]
@defform[(> term term)]
@defform[(<= term term)]
@defform[(>= term term)]

@section{entry points}

@defproc[(typeof [term any/c]) type-expr?]{
returns the type of @racket[term] as a type expression. raises an error if the term is ill-typed.
}

@defproc[(eval [term any/c]) any/c]{
evaluates @racket[term] and returns its value. raises an error if evaluation fails or the term is ill-typed.
}

@section{semantics}

evaluation follows call-by-value semantics. functions are evaluated to closures that capture their lexical environment.

values are:
@itemlist[
@item{integers}
@item{booleans}
@item{closures (functions)}
@item{pairs (represented as racket @racket[cons] pairs)}
]

type checking is performed before evaluation. all terms must be well-typed.

scoping is lexical and static. variable shadowing is permitted in nested bindings.

@section{examples}

@subsection{basic functions}

@codeblock{
#lang stlc

;; identity function
(typeof (λ (x Int) x))
;; -> (-> Int Int)

;; function application
(eval ($ (λ (x Int) (+ x 1)) 10))
;; -> 11
}

@subsection{product examples}

@codeblock{
#lang stlc

;; pair construction
(eval (pair 1 true))
;; -> '(1 . true)

;; pair destruction
(eval ($ (λ (p (* Int Int)) 
            (+ (fst p) (snd p)))
         (pair 10 20)))
;; -> 30
}

@subsection{nested products and let}

@codeblock{
#lang stlc

(eval (let (nested (pair 1 (pair true false)))
         (fst (snd nested))))
;; -> true
}

@subsection{control flow}

@codeblock{
#lang stlc

(eval (if true 1 2))
;; -> 1

(eval (if (= 5 5) true false))
;; -> true
}

@subsection{higher-order functions}

@codeblock{
#lang stlc

(eval ($ (λ (f (-> Int Int)) ($ f ($ f 0))) 
         (λ (x Int) (+ x 1))))
;; -> 2
}

@section{errors}

the type checker and evaluator report errors for:

@itemlist[
@item{type mismatches in function application}
@item{non-function values in application position}
@item{type mismatches in operator arguments (must be @racket[int])}
@item{type mismatches in conditional branches}
@item{non-boolean conditions in @racket[if] expressions}
@item{projection operations (@racket[fst], @racket[snd]) on non-product types}
@item{unbound variables}
@item{runtime errors (e.g., division by zero, applying non-functions)}
]

error messages indicate the expected and actual types, or the nature of the runtime error.

@section{internals}

the implementation uses a two-stage pipeline:

@itemlist[
@item{surface syntax: named variables using @racket[s-*] structs}
@item{core syntax: de bruijn indices using @racket[c-*] structs}
]

the conversion from surface to core syntax (@racket[surface->core]) handles variable binding and ensures correct substitution
semantics. type checking and evaluation operate on the core representation.

the type checker (@racket[typecheck]) maintains a context of types for bound variables. the evaluator (@racket[eval-term]) maintains
a context of values for bound variables, implementing closures for function values.

this design ensures that alpha-equivalent terms are represented identically in the core syntax, simplifying type checking and
evaluation.