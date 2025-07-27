(import ./location :as location)
(import /items :as items)
(import pat :as pat)
(import /tasks :as tasks :fresh true)

(use ./utils)


(defn notify [event-type event-data game-state]
  
  (match [ event-type event-data ]
    [:sprite-collision {:name "farmer"} ] (do
					    (print "HELLO FARMER")
					    (tasks/push {:action :remove :entity "3"})
					    (print "TASKS PUSHED")
					    )
    
    [:sprite-collision _ ]                  (print "=> HIT SOMETHING ELSE" )
    [:area _ ] (prin "" )
    [:multiply x y] (* x y)
    [:divide x y] (/ x y)
    (print "->>>>>>>>> NO MATCH: " event-type)))

  
  


(defn give-reward [reward game-state]
  (print "GIVING REWARD: " reward)
  )

# Function to check for mission completion
(defn check-complete [game-state]
  (print "ACTIVE MISSIONS"))

