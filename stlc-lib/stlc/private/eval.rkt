#lang racket/base

(require "syntax.rkt"
         racket/match
         racket/list)

(provide eval-term)

(struct closure (body ctx) #:transparent)

(define (eval-term term [ctx '()])
   (match term
      [(c-int v) v]
      [(c-bool v) v]
      
      [(c-var idx)
       (with-handlers ([exn:fail:contract?
                        (λ (e) (error "runtime index out of bounds:" idx))])
          (list-ref ctx idx))]

      [(c-op op e1 e2)
       (let ([v1 (eval-term e1 ctx)]
             [v2 (eval-term e2 ctx)])
          (case op
             [(+) (+ v1 v2)]
             [(-) (- v1 v2)]
             [(*) (* v1 v2)]
             [(/) (quotient v1 v2)]
             [(=) (= v1 v2)]
             [(<) (< v1 v2)]
             [(>) (> v1 v2)]
             [(<=) (<= v1 v2)]
             [(>=) (>= v1 v2)]
             [else (error "unknown operator:" op)]))]

      [(c-if c t e)
       (if (eval-term c ctx)
           (eval-term t ctx)
           (eval-term e ctx))]

      [(c-pair e1 e2)
       (cons (eval-term e1 ctx) (eval-term e2 ctx))]

      [(c-fst e)
       (car (eval-term e ctx))]

      [(c-snd e)
       (cdr (eval-term e ctx))]

      [(c-abs _ body)
       (closure body ctx)]

      [(c-app rator rand)
       (let ([fun (eval-term rator ctx)]
             [arg (eval-term rand ctx)])
          (match fun
             [(closure body clo-ctx)
              (eval-term body (cons arg clo-ctx))]
             [other (error "attempt to apply non-function:" other)]))]

      [(c-let rhs body)
       (let ([v (eval-term rhs ctx)])
          (eval-term body (cons v ctx)))]

      [else (error "unknown term in eval:" term)]))