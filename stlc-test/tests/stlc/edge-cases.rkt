#lang stlc

(require stlc/private/test)

(printf "Running edge case tests...\n")

;; Large numbers
(check-equal? (eval (+ 1000 2000)) '3000 "Large number addition")
(check-equal? (eval (* 100 100)) '10000 "Large number multiplication")
(check-equal? (typeof 999999) Int "Large number type")

;; Zero values
(check-equal? (eval (+ 0 0)) '0 "Zero addition")
(check-equal? (eval (- 0 0)) '0 "Zero subtraction")
(check-equal? (eval (* 0 100)) '0 "Zero multiplication")
(check-equal? (eval (/ 0 5)) '0 "Zero division")
(check-equal? (eval (= 0 0)) '#t "Zero equality")

;; Negative numbers
(check-equal? (eval (- 0 5)) '-5 "Negative number")
(check-equal? (eval (+ (- 0 10) 5)) '-5 "Negative in addition")
(check-equal? (eval (* (- 0 2) 3)) '-6 "Negative multiplication")
(check-equal? (eval (= (- 0 5) (- 0 5))) '#t "Negative equality")

;; Deep nesting - functions
(check-equal? (eval ($ ($ ($ (λ (x Int) (λ (y Int) (λ (z Int) (+ x (+ y z))))) 1) 2) 3)) '6 "Deeply nested currying")
(check-equal? (eval ($ (λ (f (-> Int Int)) ($ (λ (g (-> Int Int)) ($ g ($ f 0))) (λ (x Int) (+ x 2)))) (λ (x Int) (+ x 1)))) '3 "Deeply nested function applications")

;; Deep nesting - products
(check-equal? (eval (fst (fst (pair (pair (pair 1 2) 3) 4)))) (cons '1 '2) "Deeply nested product access")
(check-equal? (eval (snd (fst (pair (pair 1 (pair 2 3)) 4)))) (cons '2 '3) "Deeply nested product access 2")

;; Deep nesting - let bindings
(check-equal? (eval (let (a 1) (let (b 2) (let (c 3) (let (d 4) (+ a (+ b (+ c d)))))))) '10 "Deeply nested let bindings")
(check-equal? (eval (let (x 1) (let (y 2) (let (z 3) (pair x (pair y z)))))) (cons '1 (cons '2 '3)) "Nested let with products")

;; Deep nesting - conditionals
(check-equal? (eval (if true (if true (if true 1 2) 3) 4)) '1 "Deeply nested if expressions")
(check-equal? (eval (if (= 1 1) (if (< 2 3) (if (> 4 3) 1 0) 0) 0)) '1 "Deeply nested if with comparisons")

;; Complex mixed expressions
(check-equal? (eval ($ (λ (x Int) (if (< x 10) (+ x 1) (- x 1))) 5)) '6 "Complex function with conditional")
(check-equal? (eval (let (x 10) (let (f (λ (y Int) (if (< y x) (* y 2) y))) ($ f 5)))) '10 "Complex let with function and conditional")
(check-equal? (eval ($ (λ (p (* Int Int)) (if (< (fst p) (snd p)) (fst p) (snd p))) (pair 5 3))) '3 "Complex function with product and conditional")

;; Type preservation - complex expressions
(check-equal? (typeof ($ (λ (x Int) (if (< x 5) 1 0)) 3)) Int "Type preservation in complex function")
(check-equal? (typeof (let (x 5) (let (y 3) (if (< x y) x y)))) Int "Type preservation in nested let with if")
(check-equal? (typeof ($ (λ (f (-> Int Int)) (pair ($ f 1) ($ f 2))) (λ (x Int) (* x 2)))) (* Int Int) "Type preservation in higher-order function")

;; Empty/trivial contexts
(check-equal? (eval 42) '42 "Trivial expression")
(check-equal? (eval true) '#t "Trivial boolean")
(check-equal? (typeof 42) Int "Trivial type")

;; Identity patterns
(check-equal? (eval ($ (λ (x Int) x) 42)) '42 "Identity function")
(check-equal? (eval ($ (λ (x Bool) x) true)) '#t "Boolean identity function")
(check-equal? (eval ($ (λ (p (* Int Int)) p) (pair 1 2))) (cons '1 '2) "Product identity function")

;; Constant functions
(check-equal? (eval ($ (λ (x Int) 42) 0)) '42 "Constant function")
(check-equal? (eval ($ (λ (x Int) true) 0)) '#t "Constant boolean function")
(check-equal? (eval ($ (λ (x Int) (pair 1 2)) 0)) (cons '1 '2) "Constant product function")

;; Function composition patterns
(check-equal? (eval ($ (λ (f (-> Int Int)) ($ (λ (g (-> Int Int)) ($ g ($ f 0))) (λ (x Int) (+ x 2)))) (λ (x Int) (+ x 1)))) '3 "Function composition")
(check-equal?
   (eval
      ($
         ($
            ($
               (λ (f (-> Int Int))
                  (λ (g (-> Int Int))
                     (λ (x Int) ($ g ($ f x)))))
               (λ (x Int) (* x 2)))
            (λ (x Int) (+ x 1)))
         5))
   '11
   "Curried function composition")

;; Complex product manipulations
(check-equal? (eval ($ (λ (p (* (* Int Int) Int)) (+ (fst (fst p)) (snd p))) (pair (pair 1 2) 3))) '4 "Complex product manipulation")
(check-equal? (eval (let (p (pair 1 (pair 2 3))) (pair (fst p) (snd (snd p))))) (cons '1 '3) "Complex nested product access")

;; Stress test - very complex expression
(check-equal? (eval ($ (λ (f (-> Int (-> Int Int))) ($ ($ f 1) 2)) (λ (x Int) (λ (y Int) (+ x y))))) '3 "Stress test complex expression")
(check-equal? (eval (let (x 5) (let (f (λ (y Int) (+ x y))) ($ (λ (g (-> Int Int)) ($ g 10)) f)))) '15 "Stress test with closures")

(printf "All edge case tests passed!\n")