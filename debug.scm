#|
Debug message logging logic
Copyright 2017, Sjors van Gelderen
|#

(declare (unit debug))

(define debug-enabled) ;; Debug toggle

(define (debug-enable () (set! debug-enabled #t)))
(define (debug-disable () (set! debug-enabled #f)))

(define (debug-log level message)
    (let ((kind
	  (cond ((eq? level 'info) "INFO: ")
		((eq? level 'warning) "WARNING: ")
		(else "ERROR: "))))
    (print kind message)))
