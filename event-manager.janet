(import pat :as pat)

(import /tasks :as tasks)
(import /items)
(import /entity)



(defn process [game-state]
  
  (var new-game-state game-state)

  (var task-length (length (tasks/all-tasks)))

  (var counter 0)

  # realistically this should only be 2 interations.. but.. maybe there could be more ?
  (forever

    (var action (tasks/next))

    (when (= action nil)
      (break))

    (set counter (+ counter 1))
    
    (pat/match action
	       {:action :remove :entity id}   (set new-game-state (entity/remove-entity new-game-state id))
	       {:action :remove :item "egg"}  (set new-game-state (items/remove-first-by-key new-game-state :name "egg" ))
	       {:action :add :item "money"}   (set new-game-state (items/add game-state {:type :money}))
	       {:action :add :entity entity}  (set new-game-state (items/add new-game-state entity))

	       (ev/sleep 0)
	       ))
  new-game-state
)
