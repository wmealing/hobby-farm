(import jaylib :as "jaylib")
(import ./mission-db :as mission-db :fresh true)
(import ./hud :as hud)
(use ./utils)

# Table to hold the state of all current missions
(var completed-missions @{})

# Function to start a mission by its ID
(defn start [id game-state]
  (print "Starting mission: " id)
  (var mission-data (mission-db/missions id))
  (print "MISSION DATA") 
  (merge game-state @{:mission mission-data}))

(defn end [id game-state]
  (print "Ending mission: " id ))

# Function to notify the mission system of a game event
(defn notify [event-type event-data game-state]
  (print "NOTIFY FOR EVENT:" event-type  " with ")

  # find the current objective
  (var mission-obj (get-in game-state [:mission :objectives]))
  (print "MISSION OBJ: " )
  (pp mission-obj)

  (var state-change :nil)
  
  (case (0 mission-obj)
    {:area :farmers-house :type :goto} (set state-change {:debug-msg "MISSION COMPLETE"})
    "nothing" 
    )

  (pp state-change )
  (pp (merge game-state state-change ))
  (merge game-state state-change ))



(defn give-reward [reward game-state]
  (print "GIVING REWARD: " reward)
  )

# Function to check for mission completion
(defn check-complete [game-state]
  (print "ACTIVE MISSIONS"))

