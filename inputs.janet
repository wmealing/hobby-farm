(use jaylib)
(use ./utils) 

(defn handle-keys [game-state delta-time]

  (var pos (player-pos game-state))
  
  (var speed (* (get-in game-state [:player :speed]) delta-time))
  
  (var new-x (+ (pos :x) 
                (* speed (cond (key-down? :left) -1 
                               (key-down? :right) 1 
                               0))))
  (var new-y (+ (pos :y) 
                (* speed (cond (key-down? :up) -1 
                               (key-down? :down) 1 
                               0))))


  # set the last good to the current
  (put-in game-state [:player :last-good-position :x] (player-x game-state))
  (put-in game-state [:player :last-good-position :y] (player-y game-state))

  # update the current to the new calculated values.
  (put-in game-state [:player :position :x] (math/round new-x))
  (put-in game-state [:player :position :y] (math/round new-y))




  game-state)

