(import ./entity :as entity :fresh true)
(use ./utils)

# I spawn events tha the player can do.
(defn new [game-state delta-time]

  (var mission-state (get-in game-state [:mission]))

  (when (= mission-state :unset)

    (var items (get-in game-state [:env-location]))

    # how about a bunch of eggs to collect,should only be 1
    (var egg-holder (first (filter (fn [e] (= (e :name) "eggspawn-location")) items)))
    
    # generate 10 eggs, to hand in.
    (var entities
      (->> (range 10) (map (fn [arg]
			     (var r (random-within-rect egg-holder))
			     (entity/make-entity {:width 10
						  :height 10
						  :x (r :x)
						  :y (r :y)
						  :sprite "resources/images/egg.png" })))))
    (put-in game-state [:mission] :eggs)

    # Find the existing , sprites..
    (var sprite-items (get-in game-state [:sprite-items]))

    (put-in game-state [:sprite-items] (array/concat sprite-items entities))

    )

  game-state
  )

