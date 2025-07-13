

(defn handle [event-type event-data game-state]
  # mutate this.
  (var new-game-state game-state)
  
  (when (= (event-data :name) "reset-location")
    (print "RESET")
    (set new-game-state (put-in new-game-state :mission nil))
    (set new-game-state (put-in game-state :debug-msg "")))
  new-game-state)



