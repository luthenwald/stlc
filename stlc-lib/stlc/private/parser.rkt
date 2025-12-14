#lang racket/base

(require "syntax.rkt"
         racket/list
         racket/match)

(provide parse-type
         surface->core)

;; parse type syntaxes into internal type ast
(define (parse-type t)
   (match t
      [(? ty-int?) t]
      [(? ty-bool?) t]
      [(? ty-arr?) t]
      [(? ty-prod?) t]
      ['Int (ty-int)]
      ['Bool (ty-bool)]
      [`(-> ,t1 ,t2) (ty-arr (parse-type t1) (parse-type t2))]
      [`(* ,t1 ,t2) (ty-prod (parse-type t1) (parse-type t2))]
      [else (error "unknown type:" t)]))

;; convert named surface terms (s-* forms) into de Bruijin-indexed core terms (c-* forms)
(define (surface->core term [ctx '()])
   (match term
      [(s-int v) (c-int v)]
      [(s-bool v) (c-bool v)]
      [(s-var id)
       (let ([idx (index-of ctx id)])
          (if idx
              (c-var idx)
              (error "unbound variable:" id)))]
      [(s-op op e1 e2)
       (c-op op (surface->core e1 ctx) (surface->core e2 ctx))]
      [(s-if c t e)
       (c-if (surface->core c ctx)
             (surface->core t ctx)
             (surface->core e ctx))]
      [(s-pair e1 e2)
       (c-pair (surface->core e1 ctx) (surface->core e2 ctx))]
      [(s-fst e) (c-fst (surface->core e ctx))]
      [(s-snd e) (c-snd (surface->core e ctx))]
      [(s-app rator rand)
       (c-app (surface->core rator ctx) (surface->core rand ctx))]
      [(s-abs id type body)
       (c-abs (parse-type type)
              (surface->core body (cons id ctx)))]
      [(s-let id rhs body)
       (c-let (surface->core rhs ctx)
              (surface->core body (cons id ctx)))]
      [else (error "unknown surface term:" term)]))