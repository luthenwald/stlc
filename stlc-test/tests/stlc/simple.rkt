#lang stlc

(require stlc/private/test)

(printf "Running tests...\n")

(check-equal? (typeof (λ (x Int) x)) (-> Int Int) "Identity function type")

(check-equal? (eval ($ (λ (x Int) (+ x 1)) 10)) '11 "Simple evaluation")

(check-equal? (eval (pair 1 true)) (cons '1 '#t) "Pair construction")

(check-equal? (eval ($ (λ (p (* Int Int)) 
                         (+ (fst p) (snd p)))
                      (pair 10 20)))
              '30 "Pair destruction with lambda")

(check-equal? (eval (let (nested (pair 1 (pair true false)))
                      (fst (snd nested))))
              '#t "Nested products and let")

(check-equal? (typeof (+ 1 2)) Int "Arithmetic types")
(check-equal? (typeof (> 1 2)) Bool "Comparison types")

(check-equal? (eval (if true 1 2)) '1 "If true")
(check-equal? (eval (if false 1 2)) '2 "If false")

(printf "All tests passed!\n")