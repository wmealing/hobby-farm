# deprecate me maybe
(defn fetch [game-state]
  (get-in game-state [:items]))

# deprecate me maybe.
(defn fetch-all [game-state]
  (fetch game-state))

(defn fetch-by-key [game-state key name]
  (filter (fn [i] (= (i key) name))
	  (get-in game-state [:items])))

(defn remove-by-key [game-state key name]
  (filter (fn [i] (not (= (i key) name)))
	  (get-in game-state [:items])))



(defn remove-item
      "Removes an item from the players item list"
      [game-state item]
      (merge game-state
	     {:items (filter (fn [i] (not (= i item ))) (fetch game-state)) }))
  

(defn add [game-state item]
      (merge game-state
             {:items (array/concat @[]
				   (fetch game-state)
				   item)}))

(defn remove [game-state item]
  (merge game-state
	 {:items
	 (filter (fn [i] (not (= item i ))) (fetch-all game-state))}))
