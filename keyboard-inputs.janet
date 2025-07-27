(use jaylib)
(use ./utils)
(import ./movement :as movement :fresh true)

(defn check-key [key]
  (if (key-down? key)
    key
    nil))

(defn handle-keys [game-state delta-time]

  (let [action (check-key :left-shift)
	left  (check-key :left)
	right (check-key :right)
	up    (check-key :up)
	down  (check-key :down)]

    (movement/calculate game-state
			delta-time
			[left right up down])))
