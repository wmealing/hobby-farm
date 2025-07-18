(import ./entity :as entity :fresh true)

# I spawn events tha the player can do.
(defn new [game-state delta-time]

  # how about a bunch of eggs to collect.

  # generate 10 eggs, to hand in.
  (->> (range 10) (map (fn [arg]
			 (entity/make-entity {:position {:x 300 :y 0}
					      :sprite "egg.png" }))))

  # when there is a collion with the egg, add to inventory.

  game-state
  )
