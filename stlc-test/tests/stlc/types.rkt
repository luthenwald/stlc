#lang stlc

(require stlc/private/test)

(printf "Running type system tests...\n")

;; Basic type inference
(check-equal? (typeof 42) Int "Integer literal type")
(check-equal? (typeof true) Bool "Boolean true type")
(check-equal? (typeof false) Bool "Boolean false type")

;; Function types
(check-equal? (typeof (λ (x Int) x)) (-> Int Int) "Identity function type")
(check-equal? (typeof (λ (x Bool) x)) (-> Bool Bool) "Boolean identity function type")
(check-equal? (typeof (λ (x Int) true)) (-> Int Bool) "Constant function type")
(check-equal? (typeof (λ (x Int) 42)) (-> Int Int) "Constant integer function type")

;; Nested function types
(check-equal? (typeof (λ (f (-> Int Int)) ($ f 0))) (-> (-> Int Int) Int) "Higher-order function type")
(check-equal? (typeof (λ (x Int) (λ (y Int) (+ x y)))) (-> Int (-> Int Int)) "Curried function type")

;; Product types
(check-equal? (typeof (pair 1 2)) (* Int Int) "Simple product type")
(check-equal? (typeof (pair true false)) (* Bool Bool) "Boolean product type")
(check-equal? (typeof (pair 1 true)) (* Int Bool) "Mixed product type")
(check-equal? (typeof (pair (pair 1 2) true)) (* (* Int Int) Bool) "Nested product type")

;; Product type operations
(check-equal? (typeof (fst (pair 1 true))) Int "fst type inference")
(check-equal? (typeof (snd (pair 1 true))) Bool "snd type inference")
(check-equal? (typeof (fst (pair (pair 1 2) true))) (* Int Int) "fst on nested product")

;; Arithmetic type inference
(check-equal? (typeof (+ 1 2)) Int "Addition type")
(check-equal? (typeof (- 5 3)) Int "Subtraction type")
(check-equal? (typeof (* 2 3)) Int "Multiplication type")
(check-equal? (typeof (/ 10 2)) Int "Division type")

;; Comparison type inference
(check-equal? (typeof (= 1 2)) Bool "Equality type")
(check-equal? (typeof (< 1 2)) Bool "Less than type")
(check-equal? (typeof (> 1 2)) Bool "Greater than type")
(check-equal? (typeof (<= 1 2)) Bool "Less than or equal type")
(check-equal? (typeof (>= 1 2)) Bool "Greater than or equal type")

;; If expression types
(check-equal? (typeof (if true 1 2)) Int "If expression with Int branches")
(check-equal? (typeof (if false true false)) Bool "If expression with Bool branches")
(check-equal? (typeof (if true (pair 1 2) (pair 3 4))) (* Int Int) "If expression with product branches")

;; Let binding types
(check-equal? (typeof (let (x 42) x)) Int "Let binding type inference")
(check-equal? (typeof (let (x true) x)) Bool "Let binding with Bool")
(check-equal? (typeof (let (x (pair 1 2)) (fst x))) Int "Let binding with product")

;; Complex nested types
(check-equal? (typeof (λ (p (* Int Int)) (fst p))) (-> (* Int Int) Int) "Function with product parameter")
(check-equal? (typeof (λ (f (-> Int Int)) (pair ($ f 1) ($ f 2)))) (-> (-> Int Int) (* Int Int)) "Function returning product")

;; Type preservation: function application
(check-equal? (typeof ($ (λ (x Int) x) 5)) Int "Function application type preservation")

(printf "All type system tests passed!\n")