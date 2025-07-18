(import ./entity :as entity :fresh true)

# I spawn events tha the player can do.
(defn event-spawn [game-state]

  # how about a bunch of eggs to collect.
  (print "spawning an event")

  # generate 10 eggs
  (->> (range 10) (map (fn [arg]
			 (entity/make-entity {:position {:x 300 :y 0}
					      :sprite "egg.png" })
			 )))


  )
