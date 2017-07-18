#|
Copyright 2017, Sjors van Gelderen
|#

(declare (unit gui)
	 (uses debug))
	 ;;(uses math))


(use (prefix sdl2 sdl2:))


(define black     (sdl2:make-color   0   0  12))
(define dark_gray (sdl2:make-color  80 100  91))
(define gray      (sdl2:make-color 202 216 203))
(define red       (sdl2:make-color 255   1   1))
(define green     (sdl2:make-color   0 200   0))
(define purple    (sdl2:make-color 150   0 150))
(define blue      (sdl2:make-color   0   0 200))


(define palette_rgb_values
  (list #(101 101 101)
	#(  3  47 103)
	#( 21  35 125)
	#( 60  26 122)
	#( 95  18  97)
	#(114  14  55)
	#(112  16  13)
	#( 89  26   5)
	#( 52  40   3)
	#( 13  51   3)
	#(  3  59   4)
	#(  4  60  19)
	#(  3  56  63)
	#(  0   0   0)
	#(  0   0   0)
	#(  0   0   0)
	
	#(176 176 176)
	#( 15  99 179)
	#( 64  81 208)
	#(120  65 204)
	#(167  54 169)
	#(192  52 112)
	#(189  60  48)
	#(159  74   0)
	#(109  92   0)
	#( 54 109   0)
	#(  7 119   4)
	#(  0 121  61)
	#(  0 114 125)
	#(  0   0   0)
	#(  0   0   0)
	#(  0   0   0)

	#(254 254 255)
	#( 93 179 255)
	#(143 161 255)
	#(200 144 255)
	#(247 133 250)
	#(255 131 192)
	#(255 138 127)
	#(239 154  73)
	#(189 172  44)
	#(133 188  47)
	#( 85 199  83)
	#( 60 201 140)
	#( 62 194 205)
	#( 78  78  78)
	#(  0   0   0)
	#(  0   0   0)

	#(254 254 255)
	#(188 223 255)
	#(209 216 255)
	#(232 209 255)
	#(251 205 253)
	#(255 204 229)
	#(255 207 202)
	#(248 213 180)
	#(228 220 168)
	#(204 227 169)
	#(185 232 184)
	#(174 232 208)
	#(175 229 234)
	#(182 182 182)
	#(  0   0   0)
	#(  0   0   0)))


(define palette_colors
  (let loop ((rgb_list palette_rgb_values)
	     (color_list (list)))
    (if (> (length rgb_list) 0)
	(let ((rgb (car rgb_list)))
	  (loop (cdr rgb_list)
		(cons (sdl2:make-color (vector-ref rgb 0)
				       (vector-ref rgb 1)
				       (vector-ref rgb 2))
		      color_list)))
	color_list)))


(define (process-palette x y state)
  (let loop ((p palette_colors)
	     (s (floor (* window_height 0.025))))
    
    (if (> (length p) 0)
	(begin
	  (sdl2:fill-rect!
	   (sdl2:window-surface window)
	   (sdl2:make-rect
	    (+ (* (modulo   (- (length p) 1) 16) s) x)
	    (+ (* (quotient (- (length p) 1) 16) s) y)
	    s s)
	   (car p))
	  (loop (cdr p) s))
	
	state)))


(define (process-active-color x y state)
  (begin
    (let ((s (floor (* window_height 0.025))))
      (sdl2:fill-rect!
       (sdl2:window-surface window)
       (sdl2:make-rect x y s s)
       (sdl2:make-color 255 255 255)))
    
    state))


(define (draw-background state)
  (begin
    (sdl2:fill-rect! (sdl2:window-surface window) #f dark_gray)
    state))
