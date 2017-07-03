#|
GUI element logic
Copyright 2017, Sjors van Gelderen
|#

(declare (unit gui))

;; Prefixes
(use (prefix sdl2 sdl2:))

;; GUI elements
(define gui-button
  (lambda (x y w h color window)
    (sdl2:fill-rect! (sdl2:window-surface window)
		     (sdl2:make-rect x y w h)
		     color)))
