(use jaylib)
(use ./utils)
(import /items)
(import /sprite)
(import /game-state)

(var texture :not-loaded)
(var action-texture :not-loaded)
(var img-name :not-loaded)

(defn init [ game-state ]
  (var image-path (string/join ["resources/images/" (get-in game-state [:player :image])]))
  (set action-texture (load-image-to-texture "resources/images/bark1.png"))
  (set texture (load-image-to-texture image-path)))

(defn draw [game-state]

  # Draw the dog
  (draw-texture-ex texture [(- (player-x game-state) 20 )
			    (- (player-y game-state) 20 ) ] 0  1 :white)

  (when (game-state/action? game-state)
    (print "GOT ACTION")
    # draw action ?
    (draw-texture-ex action-texture [(+ (player-x game-state) 70 )
				     (- (player-y game-state) 55 ) ] 0  .5 :white))
  
  # ok, now if they are carrying something ?
  (var carrying (get-in game-state [:items]))

  # should filter this for things i want to show.
  (var items-to-show (items/fetch-by-key game-state :name "egg"))

  # ok we got something
  (if-not (zero? (length items-to-show))
    (do
      (var img-stack-start 30)

      (each item items-to-show
	
	(set img-stack-start (+ img-stack-start 20))
	(var item-image (get-in item [:image]))
	(var item-scale (get-in item [:scale]))
	(var item-texture (sprite/get-texture item-image))
	(draw-texture-ex item-texture
			 [(- (player-x game-state) -80 )
			  (- (player-y game-state) img-stack-start ) ] 0  item-scale :white))))
  
    
  game-state)
			
(defn update-last-known-good [game-state]
  (var last-good-known-position (get-in game-state [:player :last-good-position]))
  game-state)
  
