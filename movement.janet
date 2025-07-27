(use ./utils)

(defn calculate [game-state delta-time directions]


  (var [left right up down] directions)
  
  (var pos (player-pos game-state))

  (var speed (* (get-in game-state [:player :speed]) delta-time))

  (var new-x (+ (pos :x) 
                (* speed (cond left -1 
                               right 1 
                               0))))

  (var new-y (+ (pos :y) 
                (* speed (cond up -1 
                               down 1 
                               0))))

  # set the last good to the current
  (-> game-state
      (put-in [:player :last-good-position :x] (player-x game-state))
      (put-in  [:player :last-good-position :y] (player-y game-state))

      # update the current to the new calculated values.
      (put-in [:player :position :x] (math/round new-x))
      (put-in [:player :position :y] (math/round new-y))


      (put-in [:player :position :directions] directions)
      )
  )
