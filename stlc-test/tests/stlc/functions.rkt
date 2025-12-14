#lang stlc

(require stlc/private/test)

(printf "Running function tests...\n")

;; Simple function application
(check-equal? (eval ($ (λ (x Int) x) 5)) '5 "Identity function application")
(check-equal? (eval ($ (λ (x Int) (+ x 1)) 10)) '11 "Function with arithmetic")
(check-equal? (eval ($ (λ (x Bool) x) true)) '#t "Boolean function application")

;; Function composition
(check-equal? (eval ($ (λ (x Int) (+ x 1)) ($ (λ (x Int) (* x 2)) 5))) '11 "Function composition")
(check-equal? (eval ($ (λ (f (-> Int Int)) ($ f 5)) (λ (x Int) (+ x 1)))) '6 "Higher-order function application")

;; Currying
(check-equal? (eval ($ ($ (λ (x Int) (λ (y Int) (+ x y))) 3) 4)) '7 "Curried function application")
(check-equal? (eval ($ ($ ($ (λ (x Int) (λ (y Int) (λ (z Int) (+ x (+ y z))))) 1) 2) 3)) '6 "Triple currying")

;; Closures and lexical scoping
(check-equal? (eval ($ (λ (x Int) ($ (λ (y Int) (+ x y)) 5)) 10)) '15 "Closure with outer binding")
(check-equal? (eval (let (x 10) ($ (λ (y Int) (+ x y)) 5))) '15 "Closure with let binding")
(check-equal? (eval ($ (λ (x Int) (let (y 5) ($ (λ (z Int) (+ x (+ y z))) 3))) 10)) '18 "Nested closures")

;; Higher-order functions
(check-equal? (eval ($ (λ (f (-> Int Int)) ($ f ($ f 0))) (λ (x Int) (+ x 1)))) '2 "Apply function twice")
(check-equal? (eval ($ (λ (f (-> Int Int)) (pair ($ f 1) ($ f 2))) (λ (x Int) (* x 2)))) (cons '2 '4) "Function applied to multiple arguments")
(check-equal? (eval ($ (λ (f (-> Int Bool)) (if ($ f 5) 1 0)) (λ (x Int) (< x 10)))) '1 "Function returning boolean")

;; Functions with products
(check-equal? (eval ($ (λ (p (* Int Int)) (+ (fst p) (snd p))) (pair 10 20))) '30 "Function with product parameter")
(check-equal? (eval ($ (λ (x Int) (pair x (+ x 1))) 5)) (cons '5 '6) "Function returning product")
(check-equal? (eval ($ (λ (f (-> Int Int)) (pair ($ f 1) ($ f 2))) (λ (x Int) (* x 3)))) (cons '3 '6) "Higher-order with products")

;; Nested function applications
(check-equal? (eval ($ (λ (f (-> Int Int)) ($ (λ (g (-> Int Int)) ($ g ($ f 0))) (λ (x Int) (+ x 2)))) (λ (x Int) (+ x 1)))) '3 "Deeply nested applications")
(check-equal? (eval ($ ($ (λ (f (-> Int (-> Int Int))) ($ f 5)) (λ (x Int) (λ (y Int) (+ x y)))) 3)) '8 "Nested curried application")

;; Functions in conditionals
(check-equal? (eval ($ (if true (λ (x Int) x) (λ (x Int) (+ x 1))) 5)) '5 "Apply function from if true branch")
(check-equal? (eval ($ (if false (λ (x Int) x) (λ (x Int) (+ x 1))) 5)) '6 "Apply function from if false branch")

;; Functions with let bindings
(check-equal? (eval (let (f (λ (x Int) (+ x 1))) ($ f 5))) '6 "Function in let binding")
(check-equal? (eval (let (x 10) (let (f (λ (y Int) (+ x y))) ($ f 5)))) '15 "Nested let with closure")
(check-equal? (eval (let (f (λ (x Int) (* x 2))) ($ f 7))) '14 "Let binding function application")

;; Complex function patterns
(check-equal? (eval ($ (λ (x Int) ($ (λ (y Int) ($ (λ (z Int) (+ x (+ y z))) 3)) 2)) 1)) '6 "Triple nested function")
(check-equal? (eval ($ ($ (λ (f (-> Int Int)) (λ (x Int) ($ f ($ f x)))) (λ (x Int) (+ x 1))) 0)) '2 "Function that applies function twice")

(printf "All function tests passed!\n")