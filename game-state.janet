

(defn get-state [game-state path] (get-in game-state path))
(defn set-state [game-state path value] (put-in game-state path value))
(defn update-state [game-state path fn] (update-in game-state path fn))
