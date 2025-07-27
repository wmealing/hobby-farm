(import /sprite :as sprite :fresh true)
(import /collision :as collision :fresh true)
(import /items :as items :fresh true)

(use /utils)

(defn init [game-state]
  (print "SPRITE MANAGER INIT")
  game-state)

(defn interactions [game-state]

  (var pos (player-pos game-state))
  (var items (get-in game-state [:entities]))

  (var collision-list (collision/check-all-collisions pos :entities items))

  (var state-changes
    (map (fn [c] (collision/handle-collision (get-in c [:components :type]) (c :components) game-state)) collision-list))

  (if (= (length state-changes) 0)
    game-state
    (first state-changes)))

(defn draw [game-state]
  
  (var all-entities (get-in game-state [:entities]))

  (each item all-entities
    (sprite/draw (get-in item [:components])))
  
  game-state)

