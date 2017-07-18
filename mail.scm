#|
Copyright 2017, Sjors van Gelderen
|#

(declare (unit mail))


(define mailbox_zero '())


(define (send-mail contents recipient mailbox)
  (cons (cons recipient contents) mailbox))


(define (receive-mail recipient mailbox)
  '())
