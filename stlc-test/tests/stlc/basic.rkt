#lang stlc

; (require rackunit)
(require stlc/private/test)
 
(test-case "Identity function type"
   (check-equal? (typeof (λ (x Int) x)) (-> Int Int)))

(test-case "Simple evaluation"
   (check-equal? (eval ($ (λ (x Int) (+ x 1)) 10)) '11))

(test-case "Pair construction"
   (check-equal? (eval (, 1 true)) (cons '1 '#t)))

(test-case "Pair destruction with lambda"
   (check-equal? (eval ($ (λ (p (* Int Int)) 
                            (+ (fst p) (snd p)))
                         (, 10 20)))
                 '30))

(test-case "Nested products and let"
   (check-equal? (eval (let (nested (, 1 (, true false)))
                         (fst (snd nested))))
                 '#t))

(test-case "Arithmetic types"
   (check-equal? (typeof (+ 1 2)) Int))

(test-case "Comparison types"
   (check-equal? (typeof (> 1 2)) Bool))

(test-case "If expression"
   (check-equal? (eval (if true 1 2)) '1)
   (check-equal? (eval (if false 1 2)) '2))