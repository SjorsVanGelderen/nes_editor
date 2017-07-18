#|
Copyright 2017, Sjors van Gelderen
|#

(declare (uses debug)
	 (uses math)
	 (uses state)
	 (uses mail)
	 (uses gui))


(debug-enable)


(use (prefix sdl2 sdl2:)
     (prefix sdl2-image img:)
     (only lolevel object-evict object-release))


;; Initialize SDL2
(sdl2:set-main-ready!)
(sdl2:init! '(video))
(on-exit sdl2:quit!)
(current-exception-handler
 (let ((original-handler (current-exception-handler)))
   (lambda (exception)
     (sdl2:quit!)
     (original-handler exception))))


(define window_caption "NES Editor")
(define window_x 'centered)
(define window_y 'centered)
(define window_width 1024)
(define window_height 768)
(define window (sdl2:create-window!
		window_caption
		window_x
		window_y
		window_width
		window_height))


#|
Requires rewriting

(define (process-events state)
  (begin
    (let poll-loop ((s state)
		    (e (sdl2:wait-event!)))
      
      (case (sdl2:event-type e)
	((mouse-button-down)
	 (print (mouse-button-event-x e)))))
    
    state))
|#

(define (process-events state)
  state)


(define (update-window ms state)
  (begin
    (sdl2:update-window-surface! window)
    (sdl2:delay! ms)
    state)) ;; Throttle CPU


;; Creates a pipeline of functions and threads the state through it when provided
(define (bind sequence state)
  (let loop ((q sequence)
	     (s state))
    (if (> (length q) 0)
	(loop (cdr q) ((car q) s))
	s)))


;; Defines the sequence of instructions to perform at every iteration
(define throttle_ms 10)
(define sequence
  (list process-events
	draw-background
	(lambda (state) (process-palette 32 32 state))
	(lambda (state) (process-active-color 32 256 state))
	(lambda (state) (update-window throttle_ms state))))


;; Keeps executing the sequence, each time feeding the new state
(define (main-loop)
  (let loop ((s state_zero))
    (unless (sdl2:quit-requested?)
	(loop (bind sequence s)))))


(main-loop)
