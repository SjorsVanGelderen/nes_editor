(define (bind sequence state)
  (let loop ((q sequence)
	     (s state))
    (if (> (length q) 0)
	(loop (cdr q) ((car q) s))
	s)))


(define (foo state)
  (cdr state))


(define (bar state)
  (cddr state))


(define sequence
  (list foo
	bar))


(print (bind sequence '(0 1 2 3 4 5 6 7 8 9)))
