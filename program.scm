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
(define window_width 1024)
(define window_height 768)

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
(define (main-loop)
  (let logic ((theta 0))
    
    (let poll-loop ()
      (if (not (eq? (sdl2:poll-event!) #f))
	  (poll-loop)))
    
    (sdl2:fill-rect! (sdl2:window-surface window) #f dark_gray)
    (gui-draw-palette 32 32)
    (sdl2:update-window-surface! window)
    
    (sdl2:delay! 10) ;; Throttle CPU

    (if (not (sdl2:quit-requested?))
	(logic (+ theta 0.1)))))

;; Start the loop
(main-loop)
