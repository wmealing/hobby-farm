(defn fetch-all [game-state]
      (get-in game-state [:entities]))

(defn add [game-state entity]
  (merge game-state
         {:entities (array/concat @[]
				  (fetch-all game-state) entity)}))

(defn remove-entity [game-state entity-id]
  (print "REMOVING " entity-id)
  (var filtered (filter (fn [i] (not (= entity-id (i :id)))) (fetch-all game-state)))
  (merge game-state {:entities filtered}))



(defn make-entity [components]
  (var id (gensym))
  (var final (merge @[] components {:id id}))
  {:id id 
   :components final})

(defn make [components]
  (make-entity components))

(defn add-component [entity component-type data]
      (put-in entity [component-type] data))


# Usage
# (var player (make-entity {:position {:x 300 :y 0}
#                          :sprite {:image "dog.png"}
#                          :movement {:speed 500}}))
