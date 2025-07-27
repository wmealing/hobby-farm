(import pat :as pat)
(import /tasks :as :tasks)


(defn process [game-state]
  (print "TASK QUEUE LENGTH: " (length (tasks/all-tasks)))
  game-state
)
