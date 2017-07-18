#|
Copyright 2017, Sjors van Gelderen
|#

(declare (unit state)
	 (uses debug)
	 (uses mail))


(use (prefix sdl2 sdl2:))


(define state_zero
  (list (cons 'mailbox mailbox_zero)
	(cons 'active_color (sdl2:make-color 0 0 12))))


#|
(define (query-state which state)
  (let loop ((s state))
    (if (> (length s) 0)
	(if (equal? (caar s) which)
	    (cdar s)
	    (loop (cdr s)))
	(debug-log 'error
		   (string-append "Failed to find state entry for " which)))))
|#
