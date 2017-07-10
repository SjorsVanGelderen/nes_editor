#|
Base program logic
Copyright 2017, Sjors van Gelderen
|#

;; Imports
(declare (uses debug)
	 (uses gui)
	 (uses math))

;; Prefixes
(use (prefix sdl2 sdl2:)
     (prefix sdl2-image img:)
     (only lolevel object-evict object-release))

;; Enable debugging
(debug-enable)

;; Program state
(define program-mode 'nametable)

;; Window properties
(define window_caption "NES Editor")
(define window_x 'centered)
(define window_y 'centered)
(define window_width 1280)
(define window_height 720)

;; Colors
(define black (sdl2:make-color 0 0 12))
(define dark_gray (sdl2:make-color 80 100 91))
(define gray (sdl2:make-color 202 216 203))
(define red (sdl2:make-color 255 1 1))
(define green (sdl2:make-color 0 200 0))
(define purple (sdl2:make-color 150 0 150))
(define blue (sdl2:make-color 0 0 200))

(define palette_rgb_values
  (list #(0 0 0)
	#(0 0 0) ;; Not used?
	#(0 0 0) ;; Not used?
	#(3 56 63)
	#(4 60 19)
	#(3 59 4)
	#(13 51 3)
	#(52 40 3)
	#(89 26 5)
	#(112 16 13)
	#(114 14 55)
	#(95 18 97)
	#(60 26 122)
	#(21 35 125)
	#(3 47 103)
	#(101 101 101)
	
	#(0 0 0) ;; Not used?
	#(0 0 0) ;; Not used?
	#(0 0 0) ;; Not used?
	#(0 114 125)
	#(0 121 61)
	#(7 119 4)
	#(54 109 0)
	#(109 92 0)
	#(159 74 0)
	#(189 60 48)
	#(192 52 112)
	#(167 54 169)
	#(120 65 204)
	#(64 81 208)
	#(15 99 179)
	#(174 174 174)
	
	#(0 0 0) ;; Not used?
	#(0 0 0) ;; Not used?
	#(78 78 78)
	#(62 194 205)
	#(60 201 140)
	#(85 199 83)
	#(133 188 47)
	#(189 172 44)
	#(239 154 73)
	#(255 138 127)
	#(255 131 192)
	#(247 133 250)
	#(200 144 255)
	#(143 161 255)
	#(93 179 255)
	#(254 254 255)
	
	#(0 0 0) ;; Not used?
	#(0 0 0) ;; Not used?
	#(182 182 182)
	#(175 229 234)
	#(174 232 208)
	#(185 232 184)
	#(204 227 169)
	#(228 220 168)
	#(248 213 180)
	#(255 207 202)
	#(255 204 229)
	#(251 205 253)
	#(232 209 255)
	#(209 216 255)
	#(188 223 255)
	#(254 254 255)))

;; NES palette
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

;; Initialize SDL
(sdl2:set-main-ready!)
(sdl2:init! '(video))

;; Schedule clean quit
;;(on-exit sdl2:quit!)

;; If any unhandled exception should occur,  SDL2 subsystem will be terminated
#|
(current-exception-handler
 (let ((original-handler (current-exception-handler)))
   (lambda (exception)
     (sdl2:quit!)
     (original-handler exception))))
|#

;; Create a window
(define window (sdl2:create-window!
		window_caption
		window_x
		window_y
		window_width
		window_height))

;; The main program loop
(define (main-loop theta)
  (if (not (sdl2:quit-requested?))
      (;; Flush event stack
       (sdl2:flush-events! 'first 'last)
       
       ;; Draw the background
       (sdl2:fill-rect! (sdl2:window-surface window) #f dark_gray)
       
       ;; Draw the NES compatible palette
       (gui-draw-palette)
       
       ;; Process a label
       ;;(gui-label (math-rect 0 0 128 64) red "Hello, World!" 1)
       
       ;; Process a button
       ;;(gui-button 0 128 128 64 blue "OK then" 1 (lambda () (print "OK")) 0)
       
       ;; Draw some buttons
       #|
       (gui-button 0 0
       (floor (/ window_width 4))
       (floor (/ window_height 10))
       red
       window)

       (gui-button (/ window_width 4) 0
       (/ window_width 4) (/ window_height 10)
       blue
       window)
       
       (gui-button (* (/ window_width 4) 2) 0
       (/ window_width 4) (/ window_height 10)
       green
       window)
       
       (gui-button (* (/ window_width 4) 3) 0
       (/ window_width 4) (/ window_height 10)
       purple
       window)
       |#
       
       ;; Flip the screen
       (sdl2:update-window-surface! window)
       
       ;; Let CPU rest
       (sdl2:delay! 10)
       
       ;; Get new events
       (sdl2:pump-events!)
       
       ;; Recursively loop
       (main-loop (+ theta 0.1)))
      
      (print "Quitting...")))

;; Start the loop
(main-loop 0)
