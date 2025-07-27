(use jaylib)
(use ./utils)
(import ./collision :as collision :fresh true)

(defn interactions [game-state]

  (var pos (player-pos game-state))
  (var items (get-in game-state [:env-location]))

  (var collision-list (collision/check-all-collisions pos :area items))

  (var state-changes
    (map (fn [c] (collision/handle-collision (c :type) c game-state)) collision-list))

  (if-not (= nil (first state-changes))
    (first state-changes)
    game-state)
  )

(defn draw [game-state]

  (var scale 4)

  (if (get-in game-state [:debug])
    
    (each i (get-in game-state [:env-location])
      (draw-rectangle-rec [(* (i :x) scale)
			   (* (i :y) scale)
			   (* (i :width) scale)
			   (* (i :height) scale) ]
			  (color 255 0 0 64))))

  game-state
  )
