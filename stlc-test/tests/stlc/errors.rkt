#lang stlc

(require stlc/private/test)

(printf "Running error tests...\n")

;; Type errors - operator argument types
(check-exn #rx"operator arguments must be Int"
           (#%plain-lambda () (typeof (+ true false)))
           "Addition with boolean arguments")

(check-exn #rx"operator arguments must be Int"
           (#%plain-lambda () (typeof (- true false)))
           "Subtraction with boolean arguments")

(check-exn #rx"operator arguments must be Int"
           (#%plain-lambda () (typeof (* true false)))
           "Multiplication with boolean arguments")

(check-exn #rx"operator arguments must be Int"
           (#%plain-lambda () (typeof (/ true false)))
           "Division with boolean arguments")

(check-exn #rx"operator arguments must be Int"
           (#%plain-lambda () (typeof (= true false)))
           "Equality with boolean arguments")

;; Type errors - function application type mismatches
(check-exn #rx"application type mismatch"
           (#%plain-lambda () (typeof ($ (λ (x Int) x) true)))
           "Function application type mismatch Int vs Bool")

(check-exn #rx"application type mismatch"
           (#%plain-lambda () (typeof ($ (λ (x Bool) x) 5)))
           "Function application type mismatch Bool vs Int")

(check-exn #rx"application rator must be function"
           (#%plain-lambda () (typeof ($ 5 10)))
           "Application of non-function")

(check-exn #rx"application rator must be function"
           (#%plain-lambda () (typeof ($ true false)))
           "Application of boolean")

;; Type errors - if branch type mismatches
(check-exn #rx"if branches must have same type"
           (#%plain-lambda () (typeof (if true 1 true)))
           "If branches with different types Int vs Bool")

(check-exn #rx"if branches must have same type"
           (#%plain-lambda () (typeof (if false 5 true)))
           "If branches with different types Int vs Bool 2")

(check-exn #rx"if condition must be Bool"
           (#%plain-lambda () (typeof (if 5 1 2)))
           "If condition with Int instead of Bool")

;; Type errors - fst/snd on non-pairs
(check-exn #rx"fst expects pair"
           (#%plain-lambda () (typeof (fst 5)))
           "fst on integer")

(check-exn #rx"fst expects pair"
           (#%plain-lambda () (typeof (fst true)))
           "fst on boolean")

(check-exn #rx"snd expects pair"
           (#%plain-lambda () (typeof (snd 5)))
           "snd on integer")

(check-exn #rx"snd expects pair"
           (#%plain-lambda () (typeof (snd true)))
           "snd on boolean")

;; Runtime errors - division by zero (if checked)
(check-exn #rx"division by zero"
           (#%plain-lambda () (eval (/ 10 0)))
           "Division by zero behavior")

;; Runtime errors - applying non-function
(check-exn #rx"attempt to apply non-function"
           (#%plain-lambda () (eval ($ 5 10)))
           "Runtime application of non-function")

(check-exn #rx"attempt to apply non-function"
           (#%plain-lambda () (eval ($ true false)))
           "Runtime application of boolean")

;; Type errors - unbound variables (if we had a way to test parsing errors)
;; These would be caught at parse/surface->core time

;; Complex type error scenarios
(check-exn #rx"operator arguments must be Int"
           (#%plain-lambda () (typeof (+ (fst (pair 1 2)) true)))
           "Arithmetic with mixed types from pair")

(check-exn #rx"application type mismatch"
           (#%plain-lambda () (typeof ($ (λ (f (-> Int Int)) ($ f true)) (λ (x Int) x))))
           "Higher-order function type mismatch")

(check-exn #rx"if branches must have same type"
           (#%plain-lambda () (typeof (if true (pair 1 2) 5)))
           "If branches with product vs Int")

;; Nested error cases
(check-exn #rx"application type mismatch"
           (#%plain-lambda () (typeof (+ ($ (λ (x Int) x) true) 5)))
           "Nested expression type error")

(check-exn #rx"if branches must have same type"
           (#%plain-lambda () (typeof (fst (if true 5 (pair 1 2)))))
           "Conditional expression type error in fst")

(printf "All error tests passed!\n")