#|
Base program logic
Copyright 2017, Sjors van Gelderen
|#

;; Imports
(declare (uses debug)
	 (uses gui))

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

;; NES palette - Refactor to loop on tuples?
(define palette
  (list (sdl2:make-color 0 0 0) ;; Not used?
	(sdl2:make-color 0 0 0) ;; Not used?
	(sdl2:make-color 0 0 0) ;; Not used?
	(sdl2:make-color 3 56 63)
	(sdl2:make-color 4 60 19)
	(sdl2:make-color 3 59 4)
	(sdl2:make-color 13 51 3)
	(sdl2:make-color 52 40 3)
	(sdl2:make-color 89 26 5)
	(sdl2:make-color 112 16 13)
	(sdl2:make-color 114 14 55)
	(sdl2:make-color 95 18 97)
	(sdl2:make-color 60 26 122)
	(sdl2:make-color 21 35 125)
	(sdl2:make-color 3 47 103)
	(sdl2:make-color 101 101 101)
	
	(sdl2:make-color 0 0 0) ;; Not used?
	(sdl2:make-color 0 0 0) ;; Not used?
	(sdl2:make-color 0 0 0) ;; Not used?
	(sdl2:make-color 0 114 125)
	(sdl2:make-color 0 121 61)
	(sdl2:make-color 7 119 4)
	(sdl2:make-color 54 109 0)
	(sdl2:make-color 109 92 0)
	(sdl2:make-color 159 74 0)
	(sdl2:make-color 189 60 48)
	(sdl2:make-color 192 52 112)
	(sdl2:make-color 167 54 169)
	(sdl2:make-color 120 65 204)
	(sdl2:make-color 64 81 208)
	(sdl2:make-color 15 99 179)
	(sdl2:make-color 174 174 174)

	(sdl2:make-color 0 0 0) ;; Not used?
	(sdl2:make-color 0 0 0) ;; Not used?
	(sdl2:make-color 78 78 78)
	(sdl2:make-color 62 194 205)
	(sdl2:make-color 60 201 140)
	(sdl2:make-color 85 199 83)
	(sdl2:make-color 133 188 47)
	(sdl2:make-color 189 172 44)
	(sdl2:make-color 239 154 73)
	(sdl2:make-color 255 138 127)
	(sdl2:make-color 255 131 192)
	(sdl2:make-color 247 133 250)
	(sdl2:make-color 200 144 255)
	(sdl2:make-color 143 161 255)
	(sdl2:make-color 93 179 255)
	(sdl2:make-color 254 254 255)
	
	(sdl2:make-color 0 0 0) ;; Not used?
	(sdl2:make-color 0 0 0) ;; Not used?
	(sdl2:make-color 182 182 182)
	(sdl2:make-color 175 229 234)
	(sdl2:make-color 174 232 208)
	(sdl2:make-color 185 232 184)
	(sdl2:make-color 204 227 169)
	(sdl2:make-color 228 220 168)
	(sdl2:make-color 248 213 180)
	(sdl2:make-color 255 207 202)
	(sdl2:make-color 255 204 229)
	(sdl2:make-color 251 205 253)
	(sdl2:make-color 232 209 255)
	(sdl2:make-color 209 216 255)
	(sdl2:make-color 188 223 255)
	(sdl2:make-color 254 254 255)))

;; Initialize SDL
(sdl2:set-main-ready!)
(sdl2:init! '(video))

;; Schedule clean quit
(on-exit sdl2:quit!)

;; If any unhandled exception should occur,  SDL2 subsystem will be terminated
(current-exception-handler
 (let ((original-handler (current-exception-handler)))
   (lambda (exception)
     (sdl2:quit!)
     (original-handler exception))))

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
      ( ;; Flush event stack
       (sdl2:flush-events! 'first 'last)
       
       ;; Draw the background
       (sdl2:fill-rect! (sdl2:window-surface window) #f dark_gray)
       
       ;; Process a label
       (gui-label 0 0 128 64 red "Hello, World!" 1)

       ;; Process a button
       (gui-button 0 128 128 64 blue "OK then" 1 (lambda () (print "OK")) 0)
       
       ;; Draw the NES compatible palette
       ;;(gui-draw-palette)
       
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
       (main-loop (+ theta 0.1)))))

;; Start the loop
(main-loop 0)
