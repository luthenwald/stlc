#lang racket/base

(require (for-syntax racket/base)
         racket/match
         "syntax.rkt"
         "parser.rkt"
         "typecheck.rkt"
         "eval.rkt")

(provide (except-out (all-from-out racket/base)
                     #%datum lambda if let * + - / = < > <= >= unquote)
         (rename-out [stlc-datum #%datum]
                     [stlc-lambda λ]
                     [stlc-app $]
                     [stlc-if if]
                     [stlc-let let]
                     [stlc-pair pair]
                     [stlc-unquote unquote]
                     [stlc-mul *]
                     [stlc-add +]
                     [stlc-sub -]
                     [stlc-div /]
                     [stlc-eq =]
                     [stlc-lt <]
                     [stlc-gt >]
                     [stlc-le <=]
                     [stlc-ge >=])
         fst snd
         Int Bool
         true false
         ->
         typeof eval)

(define Int 'Int)
(define Bool 'Bool)
(define true (s-bool #t))
(define false (s-bool #f))
(define (-> d r) `(-> ,d ,r))

(define (stlc-mul a b)
   (if (or (symbol? a) (pair? a))
       `(* ,a ,b)
       (s-op '* a b)))

(define (stlc-add a b) (s-op '+ a b))
(define (stlc-sub a b) (s-op '- a b))
(define (stlc-div a b) (s-op '/ a b))
(define (stlc-eq a b) (s-op '= a b))
(define (stlc-lt a b) (s-op '< a b))
(define (stlc-gt a b) (s-op '> a b))
(define (stlc-le a b) (s-op '<= a b))
(define (stlc-ge a b) (s-op '>= a b))

(define (fst e) (s-fst e))
(define (snd e) (s-snd e))

(define (stlc-app rator rand) (s-app rator rand))
(define (stlc-if c t e) (s-if c t e))
(define (stlc-pair e1 e2) (s-pair e1 e2))

(define-syntax (stlc-unquote stx)
   (syntax-case stx ()
      [(_ e1 e2)
       #'(stlc-pair e1 e2)]
      [(_ e1)
       #'(lambda (e2) (stlc-pair e1 e2))]))

(define-syntax (stlc-lambda stx)
   (syntax-case stx ()
      [(_ (x T) body)
       #'(s-abs 'x T (let ([x (s-var 'x)]) body))]))

(define-syntax (stlc-let stx)
   (syntax-case stx ()
      [(_ (x rhs) body)
       #'(s-let 'x rhs (let ([x (s-var 'x)]) body))]))

(define-syntax (stlc-datum stx)
   (syntax-case stx ()
      [(_ . val)
       (let ([v (syntax-e #'val)])
          (cond
             [(integer? v) (with-syntax ([v v]) #'(s-int v))]
             [(boolean? v) (with-syntax ([v v]) #'(s-bool v))]
             [else #'(#%datum . val)]))]))

(define (type->sexpr t)
   (match t
      [(ty-int) 'Int]
      [(ty-bool) 'Bool]
      [(ty-arr d r) `(-> ,(type->sexpr d) ,(type->sexpr r))]
      [(ty-prod l r) `(* ,(type->sexpr l) ,(type->sexpr r))]
      [else t]))

(define (typeof t)
   (type->sexpr (typecheck (surface->core t))))

(define (eval t)
   (eval-term (surface->core t)))