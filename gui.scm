#|
GUI element logic
Copyright 2017, Sjors van Gelderen
|#

(declare (unit gui)
	 (uses debug))
	 ;;(uses math))

;; Prefixes
(use (prefix sdl2 sdl2:))

;; Label - Currently ignores caption
(define (gui-label x y w h color caption size)
  (gui-draw-label x y w h color caption size))

(define (gui-draw-label x y w h color caption size)
  (sdl2:fill-rect! (sdl2:window-surface window)
		   (sdl2:make-rect x y w h)
		   color))

;; Button
(define (gui-button x y w h color caption size action mailbox)
  (gui-draw-label x y w h color caption size)
  (action))

;; Palette
;; Loop for drawing the palette - Fix incorrect positioning (also flipped vertically)
#|
(define (gui-draw-palette)
  (let loop ((p palette)
	     (s (floor (* window_height 0.025))))
    (unless (= (length p) 0)
      (sdl2:fill-rect!
       (sdl2:window-surface window)
       (sdl2:make-rect
	(* (modulo (length p) 16) s)
	(+ (* (floor (/ (length p) 16)) s) 128)
	s s)
       (car p))
      
      (loop (cdr p) s))))
|#
