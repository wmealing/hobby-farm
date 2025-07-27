(import ./entity :as entity :fresh true)
(use ./utils)

# I spawn events tha the player can do.
(defn new [game-state delta-time]

  (var mission-state (get-in game-state [:mission]))

  (when (= mission-state :unset)

    (var items (get-in game-state [:env-location]))

    # how about a bunch of eggs to collect,should only be 1
    (var egg-holder (first (filter (fn [e] (= (e :name) "eggspawn-location")) items)))
    
    # generate 30 eggs, to hand in.
    (var entities
      (->> (range 30)
	   (map (fn [arg]
		  (var r (random-within-rect egg-holder))
		  (entity/make-entity {:width 20
				       :height 20
				       :scale 0.1
				       :x (r :x)
				       :y (r :y)
				       :type :item
				       :name "egg"
				       :image "resources/images/egg.png" })))))

    (put-in game-state [:mission] :eggs)

    # Find the existing , sprites..
    (var existing-entities (entity/fetch-all game-state))

    (put-in game-state [:entities] (array/concat @[] existing-entities entities)))

  game-state
  )

