#lang stlc

(require stlc/private/test)

(printf "Running comparison tests...\n")

;; Equality
(check-equal? (eval (= 5 5)) '#t "Equal integers true")
(check-equal? (eval (= 5 3)) '#f "Equal integers false")
(check-equal? (eval (= 0 0)) '#t "Zero equality")
(check-equal? (eval (= 10 10)) '#t "Large number equality")
(check-equal? (eval (= (- 5 2) 3)) '#t "Equality with expression")

;; Less than
(check-equal? (eval (< 3 5)) '#t "Less than true")
(check-equal? (eval (< 5 3)) '#f "Less than false")
(check-equal? (eval (< 5 5)) '#f "Less than equal")
(check-equal? (eval (< 0 1)) '#t "Zero less than")
(check-equal? (eval (< (- 10 5) 6)) '#t "Less than with expression")

;; Greater than
(check-equal? (eval (> 5 3)) '#t "Greater than true")
(check-equal? (eval (> 3 5)) '#f "Greater than false")
(check-equal? (eval (> 5 5)) '#f "Greater than equal")
(check-equal? (eval (> 1 0)) '#t "Greater than zero")
(check-equal? (eval (> (+ 3 2) 4)) '#t "Greater than with expression")

;; Less than or equal
(check-equal? (eval (<= 3 5)) '#t "Less than or equal true")
(check-equal? (eval (<= 5 3)) '#f "Less than or equal false")
(check-equal? (eval (<= 5 5)) '#t "Less than or equal equal")
(check-equal? (eval (<= 0 0)) '#t "Zero less than or equal")
(check-equal? (eval (<= (* 2 3) 7)) '#t "Less than or equal with expression")

;; Greater than or equal
(check-equal? (eval (>= 5 3)) '#t "Greater than or equal true")
(check-equal? (eval (>= 3 5)) '#f "Greater than or equal false")
(check-equal? (eval (>= 5 5)) '#t "Greater than or equal equal")
(check-equal? (eval (>= 0 0)) '#t "Zero greater than or equal")
(check-equal? (eval (>= (+ 2 3) 4)) '#t "Greater than or equal with expression")

;; Comparison in functions
(check-equal? (eval ($ (λ (x Int) (= x 5)) 5)) '#t "Equality in function true")
(check-equal? (eval ($ (λ (x Int) (= x 5)) 3)) '#f "Equality in function false")
(check-equal? (eval ($ (λ (x Int) (< x 10)) 5)) '#t "Less than in function")
(check-equal? (eval ($ (λ (x Int) (> x 0)) 5)) '#t "Greater than in function")

;; Comparison with let bindings
(check-equal? (eval (let (x 5) (= x 5))) '#t "Equality with let")
(check-equal? (eval (let (x 10) (let (y 5) (< y x)))) '#t "Nested let with comparison")
(check-equal? (eval (let (x 7) (>= x 5))) '#t "Greater than or equal with let")

;; Comparison in conditionals
(check-equal? (eval (if (= 5 5) 1 0)) '1 "If with equality true")
(check-equal? (eval (if (= 5 3) 1 0)) '0 "If with equality false")
(check-equal? (eval (if (< 3 5) true false)) '#t "If with less than")
(check-equal? (eval (if (> 5 3) true false)) '#t "If with greater than")

;; Complex comparison expressions
(check-equal? (eval (if (= 5 5) (if (< 3 5) 1 0) 0)) '1 "Nested if with comparisons")
(check-equal? (eval (if (= 5 3) 0 (if (> 5 3) 1 0))) '1 "Nested if with comparisons 2")
(check-equal? (eval ($ (λ (x Int) (if (< x 10) 1 0)) 5)) '1 "Comparison in higher-order function")

;; Boundary cases
(check-equal? (eval (= (- 10 5) (+ 2 3))) '#t "Equality with arithmetic")
(check-equal? (eval (< (* 2 3) 10)) '#t "Less than with multiplication")
(check-equal? (eval (> (/ 10 2) 4)) '#t "Greater than with division")

(printf "All comparison tests passed!\n")