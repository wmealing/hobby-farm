# (import jaylib :as "jaylib")
(import ./mission-db :as mission-db :fresh true)
(import ./hud :as hud)
(import ./location :as location)
(use ./utils)

# Table to hold the state of all current missions
(var completed-missions @{})

# Function to start a mission by its ID
(defn start [id game-state]
  (print "Starting mission: " id)
  (merge game-state @{:mission id}))

(defn end [id game-state]
  (print "Ending mission: " id ))

# Function to notify the mission system of a game event
# doesn't return game state, returns something to merge into the gamestate.
(defn notify [event-type event-data game-state]

  (var new-game-state (location/handle event-data event-data game-state))

  (var mission-id (get-in new-game-state [:mission]))

  (if (not (= mission-id :none))
    (do 
      (var current-mission (mission-db/missions mission-id))
      (var objective-fn (get-in current-mission [:objectives]))
      (set new-game-state (objective-fn event-type event-data new-game-state))))
  new-game-state)

(defn give-reward [reward game-state]
  (print "GIVING REWARD: " reward)
  )

# Function to check for mission completion
(defn check-complete [game-state]
  (print "ACTIVE MISSIONS"))

