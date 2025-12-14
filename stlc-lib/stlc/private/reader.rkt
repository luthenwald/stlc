#lang racket/base

(provide call-with-stlc-reading-parameterization)

(define (call-with-stlc-reading-parameterization proc)
   (parameterize ([read-accept-dot #t]
                  [read-accept-bar-quote #f])
      (proc)))