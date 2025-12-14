#lang racket/base

(require "syntax.rkt"
         racket/match
         racket/list)

(provide typecheck)

(define (typecheck term [ctx '()])
   (match term
      [(c-int _) (ty-int)]
      [(c-bool _) (ty-bool)]
      
      [(c-var idx)
       (with-handlers ([exn:fail:contract?
                        (λ (e) (error "index out of bounds during typecheck:" idx))])
          (list-ref ctx idx))]

      [(c-op op e1 e2)
       (let ([t1 (typecheck e1 ctx)]
             [t2 (typecheck e2 ctx)])
          (unless (and (equal? t1 (ty-int)) (equal? t2 (ty-int)))
             (error "operator arguments must be Int, got:" t1 t2))
          (case op
             [(+ - * /) (ty-int)]
             [(= < > <= >=) (ty-bool)]
             [else (error "unknown operator:" op)]))]

      [(c-if c t e)
       (let ([tc (typecheck c ctx)]
             [tt (typecheck t ctx)]
             [te (typecheck e ctx)])
          (unless (equal? tc (ty-bool))
             (error "if condition must be Bool, got:" tc))
          (unless (equal? tt te)
             (error "if branches must have same type, got:" tt te))
          tt)]

      [(c-pair e1 e2)
       (ty-prod (typecheck e1 ctx) (typecheck e2 ctx))]

      [(c-fst e)
       (match (typecheck e ctx)
          [(ty-prod t1 t2) t1]
          [other (error "fst expects pair, got:" other)])]

      [(c-snd e)
       (match (typecheck e ctx)
          [(ty-prod t1 t2) t2]
          [other (error "snd expects pair, got:" other)])]

      [(c-abs type body)
       (ty-arr type (typecheck body (cons type ctx)))]

      [(c-app rator rand)
       (let ([trator (typecheck rator ctx)]
             [trand (typecheck rand ctx)])
          (match trator
             [(ty-arr dom rng)
              (if (equal? dom trand)
                  rng
                  (error "application type mismatch. expected:" dom "got:" trand))]
             [other (error "application rator must be function, got:" other)]))]

      [(c-let rhs body)
       (let ([trhs (typecheck rhs ctx)])
          (typecheck body (cons trhs ctx)))]
      
      [else (error "unknown term in typecheck:" term)]))