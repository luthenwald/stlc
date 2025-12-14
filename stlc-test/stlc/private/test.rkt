#lang racket/base

(require rackunit)
(provide (all-from-out rackunit))

(define (check-equal? actual expected [msg ""])
   (unless (equal? actual expected)
      (error (format "Test failed: ~a\nExpected: ~v\nActual:   ~v" msg expected actual))))

(provide check-equal?)