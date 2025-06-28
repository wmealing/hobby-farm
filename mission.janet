(import jaylib :as "jaylib")
(import ./mission-db :as mission-db :fresh true)
(use ./utils)

# Table to hold the state of all current missions
(var active-missions @{})
(var completed-missions @{})

# Function to start a mission by its ID
(defn start [id game-state]
  (print "Starting mission: " id)
  (var mission-data (mission-db/missions id))
  (put-in game-state [:mission] mission-data)
  )

(defn end [id game-state]
  (print "Ending mission: " id ))

# Function to notify the mission system of a game event
(defn notify [event-type event-data]
  (print "NOTIFY"))
    
   # Function to check for mission completion
(defn update []
  (print "ACTIVE MISSIONS")
  (pp active-missions)
  (loop [[id mission] :pairs active-missions]
    (print "ID" id )))

