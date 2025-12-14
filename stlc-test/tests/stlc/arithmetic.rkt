#lang stlc

(require stlc/private/test)

(printf "Running arithmetic tests...\n")

;; Addition
(check-equal? (eval (+ 1 2)) '3 "Simple addition")
(check-equal? (eval (+ 0 0)) '0 "Zero addition")
(check-equal? (eval (+ 100 200)) '300 "Large number addition")
(check-equal? (eval (+ (- 10 5) 3)) '8 "Addition with subtraction")
(check-equal? (eval (+ 1 (+ 2 3))) '6 "Nested addition")

;; Subtraction
(check-equal? (eval (- 5 3)) '2 "Simple subtraction")
(check-equal? (eval (- 10 10)) '0 "Zero subtraction")
(check-equal? (eval (- 3 5)) '-2 "Negative result")
(check-equal? (eval (- 0 5)) '-5 "Subtract from zero")
(check-equal? (eval (- 10 (- 3 1))) '8 "Nested subtraction")

;; Multiplication
(check-equal? (eval (* 2 3)) '6 "Simple multiplication")
(check-equal? (eval (* 0 100)) '0 "Zero multiplication")
(check-equal? (eval (* 1 42)) '42 "Identity multiplication")
(check-equal? (eval (* 5 (* 2 3))) '30 "Nested multiplication")
(check-equal? (eval (* (- 5 2) 3)) '9 "Multiplication with subtraction")

;; Division
(check-equal? (eval (/ 10 2)) '5 "Simple division")
(check-equal? (eval (/ 15 3)) '5 "Division with remainder")
(check-equal? (eval (/ 7 2)) '3 "Integer division truncation")
(check-equal? (eval (/ 100 10)) '10 "Large number division")
(check-equal? (eval (/ (* 6 2) 3)) '4 "Division with multiplication")

;; Complex arithmetic expressions
(check-equal? (eval (+ (* 2 3) (- 10 4))) '12 "Mixed arithmetic")
(check-equal? (eval (- (* 5 2) (+ 3 1))) '6 "Complex expression 1")
(check-equal? (eval (/ (+ 10 5) 3)) '5 "Complex expression 2")
(check-equal? (eval (+ 1 (+ 2 (+ 3 4)))) '10 "Deeply nested addition")

;; Arithmetic in functions
(check-equal? (eval ($ (λ (x Int) (+ x 1)) 5)) '6 "Addition in function")
(check-equal? (eval ($ (λ (x Int) (* x 2)) 7)) '14 "Multiplication in function")
(check-equal? (eval ($ (λ (x Int) (- x 3)) 10)) '7 "Subtraction in function")
(check-equal? (eval ($ (λ (x Int) (/ x 2)) 8)) '4 "Division in function")

;; Arithmetic with let bindings
(check-equal? (eval (let (x 5) (+ x 3))) '8 "Addition with let")
(check-equal? (eval (let (x 10) (let (y 5) (- x y)))) '5 "Nested let with subtraction")
(check-equal? (eval (let (x 3) (* x (+ x 1)))) '12 "Let with nested arithmetic")

;; Arithmetic in conditionals
(check-equal? (eval (if true (+ 1 2) (- 5 3))) '3 "Arithmetic in if true branch")
(check-equal? (eval (if false (+ 1 2) (- 5 3))) '2 "Arithmetic in if false branch")
(check-equal? (eval (if (= 5 5) (* 2 3) (/ 10 2))) '6 "Arithmetic with comparison condition")

(printf "All arithmetic tests passed!\n")