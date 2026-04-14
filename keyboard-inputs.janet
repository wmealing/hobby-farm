(use jaylib)
(use ./utils)
(import ./movement :as movement :fresh true)

(defn check-key [key]
  (if (key-down? key)
    key
    nil))


(defn update-action [ game-state action-state ]

  (var new-game-state game-state)

  (var new-player-data (merge (get-in new-game-state [:player])
			      {:action action-state}))
  (merge
    new-game-state
    {:player new-player-data}))

(defn handle-keys [game-state delta-time]

  (var action-pressed nil)

  (let [action (check-key :left-shift)
	left  (check-key :left)
	right (check-key :right)
	up    (check-key :up)
	down  (check-key :down)]

    (set action-pressed
      (cond (= action :left-shift) true
	    false))

    (print "PRESSED: " action-pressed)

    (-> game-state
	(movement/calculate delta-time [left right up down])
	(update-action action-pressed)
	)))
    


  


