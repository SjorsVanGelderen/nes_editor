#|
Base program logic
Copyright 2017, Sjors van Gelderen
|#

;; Imports
(declare (uses debug))
(declare (uses gui))

;; Prefixes
(use (prefix sdl2 sdl2:)
     (prefix sdl2-image img:)
     (only lolevel
	   object-evict object-release))

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
(define dark-gray (sdl2:make-color 80 100 91))
(define gray (sdl2:make-color 202 216 203))
(define red (sdl2:make-color 255 1 1))

;; Palette
(define palette
  (list (sdl2:make-color 101 101 101)
	(sdl2:make-color 3 47 103)
	(sdl2:make-color 21 35 125)
	(sdl2:make-color 60 26 122)
	(sdl2:make-color 95 18 97)
	(sdl2:make-color 114 14 55)
	(sdl2:make-color 112 16 13)
	(sdl2:make-color 89 26 5)
	(sdl2:make-color 52 40 3)
	(sdl2:make-color 13 51 3)
	(sdl2:make-color 3 59 4)
	(sdl2:make-color 4 60 19)
	(sdl2:make-color 3 56 63)
	(sdl2:make-color 0 0 0) ;; Not used?
	(sdl2:make-color 0 0 0) ;; Not used?
	(sdl2:make-color 0 0 0))) ;; Not used?

;; Initialize SDL
(sdl2:set-main-ready!)
(sdl2:init! '(video))

;; Schedule clean quit
(on-exit sdl2:quit!)

;; If any unhandled exception should occur,  SDL2 subsystem will be terminated
;; (current-exception-handler
;;  (let ((original-handler (current-exception-handler)))
;;    (lambda (exception)
;;      (sdl2:quit!)
;;      (original-handler exception))))

;; Create a window
(define window (sdl2:create-window!
		window_caption
		window_x
		window_y
		window_width
		window_height))

;; Loop for drawing the palette
(define draw-palette
  (lambda (list)
    (let loop ((l list) (w (floor (* window_height 0.1))))
      (when (> (length list) 0)
	(sdl2:fill-rect!
	 (sdl2:window-surface window)
	 (sdl2:make-rect (* (- 16 (length list)) w) w w w)
	 (car list))
	(loop ((tail list) w))))))

;; The main program loop
(define (main-loop theta)
  ;; Get new events
  (sdl2:pump-events!)
  
  (if (not (sdl2:quit-requested?))
      ( ;; Draw the background
       (sdl2:fill-rect! (sdl2:window-surface window)
			#f ;; Entire target(false)
			dark-gray)
       
       (if (eq? program-mode 'nametable)
	   ;; Draw a rectangle
	   (sdl2:fill-rect!
	    (sdl2:window-surface window)
	    (sdl2:make-rect
	     (floor (- (+ (/ window_width 2)
			  (* (/ window_height 5) (cos theta)))
		       50))
	     (floor (- (+ (/ window_height 2)
			  (* (/ window_height 5) (sin theta)))
		       50))
	     100 100)
	    gray))

       (draw-palette palette)
       
       ;; Draw some buttons
       (gui-button 0 0 128 128 red window)
       (gui-button 128 128 128 64 black window)
       
       ;; Flip the screen
       (sdl2:update-window-surface! window)
       
       ;; Let CPU rest
       (sdl2:delay! 10)
       
       ;; Flush event stack
       (sdl2:flush-events! 'first 'last)
       
       ;; Recursively loop
       (main-loop (+ theta 0.1)))))

;; Start the loop
(main-loop 0)

;; Terminate the SDL2 subsystem
(sdl2:quit!)
