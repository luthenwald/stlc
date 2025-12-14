#lang stlc

(require stlc/private/test)

(printf "Running control flow tests...\n")

;; If expressions - basic cases
(check-equal? (eval (if true 1 2)) '1 "If true branch")
(check-equal? (eval (if false 1 2)) '2 "If false branch")
(check-equal? (eval (if true true false)) '#t "If with boolean branches true")
(check-equal? (eval (if false true false)) '#f "If with boolean branches false")

;; If expressions with arithmetic
(check-equal? (eval (if true (+ 1 2) (- 5 3))) '3 "If with arithmetic true")
(check-equal? (eval (if false (+ 1 2) (- 5 3))) '2 "If with arithmetic false")
(check-equal? (eval (if true (* 2 3) (/ 10 2))) '6 "If with multiplication true")
(check-equal? (eval (if false (* 2 3) (/ 10 2))) '5 "If with division false")

;; If expressions with comparisons
(check-equal? (eval (if (= 5 5) 1 0)) '1 "If with equality true")
(check-equal? (eval (if (= 5 3) 1 0)) '0 "If with equality false")
(check-equal? (eval (if (< 3 5) true false)) '#t "If with less than")
(check-equal? (eval (if (> 5 3) true false)) '#t "If with greater than")

;; Nested if expressions
(check-equal? (eval (if true (if true 1 2) 3)) '1 "Nested if true-true")
(check-equal? (eval (if true (if false 1 2) 3)) '2 "Nested if true-false")
(check-equal? (eval (if false (if true 1 2) 3)) '3 "Nested if false")
(check-equal? (eval (if (= 5 5) (if (< 3 5) 1 0) 0)) '1 "Nested if with comparisons")

;; Let bindings - basic cases
(check-equal? (eval (let (x 5) x)) '5 "Simple let binding")
(check-equal? (eval (let (x 10) (+ x 1))) '11 "Let binding with arithmetic")
(check-equal? (eval (let (x true) x)) '#t "Let binding with boolean")
(check-equal? (eval (let (x (pair 1 2)) (fst x))) '1 "Let binding with pair")

;; Nested let bindings
(check-equal? (eval (let (x 5) (let (y 3) (+ x y)))) '8 "Nested let bindings")
(check-equal? (eval (let (x 10) (let (y 5) (let (z 2) (+ x (+ y z)))))) '17 "Triple nested let")
(check-equal? (eval (let (x 1) (let (y 2) (pair x y)))) (cons '1 '2) "Nested let with pair")

;; Let bindings with functions
(check-equal? (eval (let (f (λ (x Int) (+ x 1))) ($ f 5))) '6 "Let binding with function")
(check-equal? (eval (let (x 10) (let (f (λ (y Int) (+ x y))) ($ f 5)))) '15 "Nested let with closure")
(check-equal? (eval (let (f (λ (x Int) (* x 2))) ($ f 7))) '14 "Let binding function application")

;; Scoping rules - variable shadowing
(check-equal? (eval (let (x 5) (let (x 10) x))) '10 "Variable shadowing inner")
(check-equal? (eval (let (x 5) (let (x 10) (+ x 1)))) '11 "Variable shadowing with arithmetic")
(check-equal? (eval (let (x 1) (let (y 2) (let (x 3) (+ x y))))) '5 "Shadowing in nested let")

;; Let bindings in conditionals
(check-equal? (eval (if true (let (x 5) x) (let (x 10) x))) '5 "Let in if true branch")
(check-equal? (eval (if false (let (x 5) x) (let (x 10) x))) '10 "Let in if false branch")
(check-equal? (eval (let (x 5) (if true x (+ x 1)))) '5 "If in let binding")

;; Complex control flow patterns
(check-equal? (eval (let (x 10) (if (< x 5) 1 (if (< x 15) 2 3)))) '2 "Nested if in let")
(check-equal? (eval (let (x 5) (let (y 3) (if (< x y) x y)))) '3 "Let with if comparison")
(check-equal? (eval (let (f (λ (x Int) (if (< x 5) 1 0))) ($ f 3))) '1 "Function with if in let")

;; Let bindings with products
(check-equal? (eval (let (p (pair 1 2)) (let (x (fst p)) (let (y (snd p)) (+ x y))))) '3 "Nested let with product destructuring")
(check-equal? (eval (let (x 5) (let (p (pair x (+ x 1))) (snd p)))) '6 "Let with pair construction")

;; Control flow type preservation
(check-equal? (typeof (if true 1 2)) Int "If expression type")
(check-equal? (typeof (if false true false)) Bool "If expression boolean type")
(check-equal? (typeof (let (x 5) x)) Int "Let binding type")
(check-equal? (typeof (let (x true) x)) Bool "Let binding boolean type")

(printf "All control flow tests passed!\n")