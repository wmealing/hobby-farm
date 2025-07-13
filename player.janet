(import jaylib :as "jaylib")
(use ./utils)

(var texture :not-loaded)
(var img-name :not-loaded)

(defn init [ game-state ]
  (var image-path (string/join ["resources/images/" (get-in game-state [:player :image])]))
  (set texture (load-image-to-texture image-path)))

(defn draw [game-state]
  (jaylib/draw-texture-ex texture [(- (player-x game-state) 20 )
				   (- (player-y game-state) 20 ) ] 0  1 :white))
			
(defn update-last-known-good [game-state]
  (var last-good-known-position (get-in game-state [:player :last-good-position]))
  game-state)
  
