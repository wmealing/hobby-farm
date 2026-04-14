# deprecate me maybe
(defn fetch [game-state]
  (get-in game-state [:items]))

# deprecate me maybe.
(defn fetch-all [game-state]
  (fetch game-state))

(defn fetch-by-key [game-state key name]
  (filter (fn [i] (= (i key) name))
	  (get-in game-state [:items])))

(defn fetch-by-count [game-state key name]
  (length (fetch-by-key game-state key name)))

(defn remove-by-key [game-state key name]
      (filter (fn [i] (not (= (i key) name)))
	      (get-in game-state [:items])))

(defn remove-item
      "Removes an item from the players item list"
      [game-state item]
      (merge game-state
	     {:items (filter (fn [i] (not (= i item ))) (fetch game-state)) }))

(defn remove-first-by-key [game-state key name]
  (var removed false)
  (let [items (get-in game-state [:items])
        new-items (filter
          (fn [i]
            (if (and (not removed) (= (i key) name))
              (do (set removed true) false) # skip first match
              true))
          items)]
    (put-in game-state [:items] new-items)))

#   (var game-state @{:items [{:name "foo"} {:name "bar"}] })
#   (pp(remove-first-by-key game-state :name "foo"))

(defn add [game-state item]
      (merge game-state
             {:items (array/concat @[]
				   (fetch game-state)
				   item)}))

(defn remove [game-state item]
  (merge game-state
	 {:items
	 (filter (fn [i] (not (= item i ))) (fetch-all game-state))}))
