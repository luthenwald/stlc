#lang stlc

(require stlc/private/test)

(printf "Running product type tests...\n")

;; Simple pair construction
(check-equal? (eval (pair 1 2)) (cons '1 '2) "Simple integer pair")
(check-equal? (eval (pair true false)) (cons '#t '#f) "Boolean pair")
(check-equal? (eval (pair 1 true)) (cons '1 '#t) "Mixed type pair")
(check-equal? (eval (pair 0 0)) (cons '0 '0) "Zero pair")

;; Pair destruction with fst and snd
(check-equal? (eval (fst (pair 10 20))) '10 "fst of integer pair")
(check-equal? (eval (snd (pair 10 20))) '20 "snd of integer pair")
(check-equal? (eval (fst (pair true false))) '#t "fst of boolean pair")
(check-equal? (eval (snd (pair true false))) '#f "snd of boolean pair")

;; Nested products
(check-equal? (eval (pair (pair 1 2) 3)) (cons (cons '1 '2) '3) "Nested pair outer")
(check-equal? (eval (fst (pair (pair 1 2) 3))) (cons '1 '2) "fst of nested pair")
(check-equal? (eval (snd (pair (pair 1 2) 3))) '3 "snd of nested pair")
(check-equal? (eval (fst (fst (pair (pair 1 2) 3)))) '1 "fst of fst of nested pair")
(check-equal? (eval (snd (fst (pair (pair 1 2) 3)))) '2 "snd of fst of nested pair")

;; Deeply nested products
(check-equal? (eval (pair 1 (pair true false))) (cons '1 (cons '#t '#f)) "Deeply nested pair 1")
(check-equal? (eval (fst (snd (pair 1 (pair true false))))) '#t "Deeply nested access 1")
(check-equal? (eval (pair (pair 1 2) (pair 3 4))) (cons (cons '1 '2) (cons '3 '4)) "Deeply nested pair 2")
(check-equal? (eval (fst (snd (pair (pair 1 2) (pair 3 4))))) '3 "Deeply nested access 2")

;; Products with let bindings
(check-equal? (eval (let (p (pair 10 20)) (fst p))) '10 "Let with pair and fst")
(check-equal? (eval (let (p (pair 10 20)) (snd p))) '20 "Let with pair and snd")
(check-equal? (eval (let (p (pair 1 2)) (pair (fst p) (snd p)))) (cons '1 '2) "Let with pair reconstruction")
(check-equal? (eval (let (nested (pair 1 (pair true false))) (fst (snd nested)))) '#t "Let with nested pair")

;; Products with functions
(check-equal? (eval ($ (λ (p (* Int Int)) (fst p)) (pair 5 6))) '5 "Function with product parameter")
(check-equal? (eval ($ (λ (p (* Int Int)) (+ (fst p) (snd p))) (pair 10 20))) '30 "Function with product arithmetic")
(check-equal? (eval ($ (λ (x Int) (pair x (+ x 1))) 5)) (cons '5 '6) "Function returning product")
(check-equal? (eval ($ (λ (x Int) (pair (pair x 1) (pair x 2))) 10)) (cons (cons '10 '1) (cons '10 '2)) "Function returning nested product")

;; Products in conditionals
(check-equal? (eval (if true (pair 1 2) (pair 3 4))) (cons '1 '2) "Pair in if true branch")
(check-equal? (eval (if false (pair 1 2) (pair 3 4))) (cons '3 '4) "Pair in if false branch")
(check-equal? (eval (fst (if true (pair 10 20) (pair 30 40)))) '10 "fst of conditional pair")

;; Products with arithmetic
(check-equal? (eval (pair (+ 1 2) (- 5 3))) (cons '3 '2) "Pair with arithmetic expressions")
(check-equal? (eval (+ (fst (pair 10 20)) (snd (pair 10 20)))) '30 "Arithmetic on pair components")
(check-equal? (eval (pair (* 2 3) (/ 10 2))) (cons '6 '5) "Pair with multiplication and division")

;; Products with comparisons
(check-equal? (eval (pair (= 5 5) (< 3 5))) (cons '#t '#t) "Pair with comparisons")
(check-equal? (eval (if (fst (pair true false)) 1 0)) '1 "Conditional with pair fst")
(check-equal? (eval (if (snd (pair false true)) 1 0)) '1 "Conditional with pair snd")

;; Complex product patterns
(check-equal? (eval (let (p1 (pair 1 2)) (let (p2 (pair 3 4)) (pair (fst p1) (snd p2))))) (cons '1 '4) "Multiple let bindings with products")
(check-equal? (eval ($ (λ (p (* (* Int Int) Int)) (fst (fst p))) (pair (pair 1 2) 3))) '1 "Function with deeply nested product type")
(check-equal? (eval ($ (λ (f (-> Int Int)) (pair ($ f 1) ($ f 2))) (λ (x Int) (* x 2)))) (cons '2 '4) "Higher-order function with products")

;; Product type preservation
(check-equal? (typeof (pair 1 2)) (* Int Int) "Product type inference")
(check-equal? (typeof (pair true false)) (* Bool Bool) "Boolean product type")
(check-equal? (typeof (pair (pair 1 2) true)) (* (* Int Int) Bool) "Nested product type")
(check-equal? (typeof (fst (pair 1 true))) Int "fst type inference")
(check-equal? (typeof (snd (pair 1 true))) Bool "snd type inference")

(printf "All product type tests passed!\n")