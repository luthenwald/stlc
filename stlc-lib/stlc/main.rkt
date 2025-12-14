#lang racket/base

(require stlc/private/kernel)
(provide (all-from-out stlc/private/kernel))

(module reader syntax/module-reader stlc/main
   #:wrapper1 call-with-stlc-reading-parameterization
   (require stlc/private/reader))