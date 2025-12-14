#lang racket/base

(provide (all-defined-out))

;; type-level syntax
(struct ty-int  ()        #:transparent)
(struct ty-bool ()        #:transparent)
(struct ty-arr  (dom rng) #:transparent)
(struct ty-prod (l r)     #:transparent)

;; source term-level syntax
(struct s-var  (id)             #:transparent)
(struct s-abs  (id type body)   #:transparent)
(struct s-app  (rator rand)     #:transparent)
(struct s-if   (cond then else) #:transparent)
(struct s-let  (id rhs body)    #:transparent)
(struct s-pair (e1 e2)          #:transparent)
(struct s-fst  (e)              #:transparent)
(struct s-snd  (e)              #:transparent)
(struct s-int  (val)            #:transparent)
(struct s-bool (val)            #:transparent)
(struct s-op   (op e1 e2)       #:transparent)

;; nameless representation using de Bruijin indices
(struct c-var  (idx)            #:transparent)
(struct c-abs  (type body)      #:transparent)
(struct c-app  (rator rand)     #:transparent)
(struct c-if   (cond then else) #:transparent)
(struct c-let  (rhs body)       #:transparent)
(struct c-pair (e1 e2)          #:transparent)
(struct c-fst  (e)              #:transparent)
(struct c-snd  (e)              #:transparent)
(struct c-int  (val)            #:transparent)
(struct c-bool (val)            #:transparent)
(struct c-op   (op e1 e2)       #:transparent)