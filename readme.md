# syntax

```bnf
type ::= Int
      |  Bool
      |  (-> type type)
      |  (* type type)

term ::= (λ (var type) term)
      |  ($ term term)
      |  (if term term term)
      |  (let (var term) term)
      |  (pair term term)
      |  (fst term)
      |  (snd term)
      |  var
      |  int
      |  bool
      |  (op term term)

var  ::= <symbol>
int  ::= <integer>
bool ::= true | false
op   ::= + | - | * | / | = | < | > | <= | >=
```

# setup

```just
# link local packages into your racket installation
install: 
   raco pkg install --auto --skip-installed --link ./stlc-lib ./stlc-test ./stlc-doc ./stlc

# compile the linked packages
setup: 
   raco setup --pkgs stlc-lib stlc-test

# run the test suite
test: 
   raco test stlc-test/tests/stlc/

# build documentation as single-page HTML
doc: 
   raco scribble --html --dest doc --dest-name stlc stlc-doc/scribblings/stlc/main.scrbl

# open the documentation page
preview:
   open ./doc/stlc.html
```

# examples

```racket
#lang stlc

;; type checking
(typeof (λ (x Int) x))
;; -> (-> Int Int)

;; evaluation
(eval ($ (λ (x Int) (+ x 1)) 10))
;; -> 11
```

# references

- *Types and Programming Languages*, Benjamin C. Pierce.
- *https://github.com/lexi-lambda/hackett*, Alexis King.
- *https://github.com/lazear/types-and-programming-languages*, Michael Lazear
