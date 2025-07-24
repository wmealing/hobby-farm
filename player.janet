(use jaylib)
(use ./utils)

(var texture :not-loaded)
(var img-name :not-loaded)

(defn init [ game-state ]
  (var image-path (string/join ["resources/images/" (get-in game-state [:player :image])]))
  (set texture (load-image-to-texture image-path)))

(defn draw [game-state]

  # ok, now if they are carrying something ?
  (var carrying (get-in game-state [:items]))

  (if-not (nil? carrying)
    # (print "Gotta draw stuff being carried")
    1
    )
  
  (draw-texture-ex texture [(- (player-x game-state) 20 )
			    (- (player-y game-state) 20 ) ] 0  1 :white)
  game-state)
			
(defn update-last-known-good [game-state]
  (var last-good-known-position (get-in game-state [:player :last-good-position]))
  game-state)
  
