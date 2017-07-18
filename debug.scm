#|
Copyright 2017, Sjors van Gelderen
|#

(declare (unit debug))


(define debug-enabled #f) ;; Debug toggle


(define (debug-enable) (set! debug-enabled #t))
(define (debug-disable) (set! debug-enabled #f))


(define (debug-log level message)
  (if debug-enabled
      (let ((kind
	     (cond ((equal? level 'info) "INFO: ")
		   ((equal? level 'warning) "WARNING: ")
		   (else "ERROR: "))))
	(print kind message))))
