(use jaylib)
(use ./utils)

(import /mission :as "mission" :fresh true)
(import /items :as items)
(import /entity :as entity :fresh true)
(import /tasks :as tasks)

(def scale 4)

(defn rectangles-overlap? [r1 r2-orig]

  # required because we need to account for zoom.
  (var r2 (scale-rect r2-orig scale))

  (not (or
	 (> (r1 :x) (+ (r2 :x) (r2 :width)))
	 (> (r2 :x) (+ (r1 :x) (r1 :width)))
	 (> (r1 :y) (+ (r2 :y) (r2 :height)))
	 (> (r2 :y) (+ (r1 :y) (r1 :height))))))

(defn revert-player-position [game-state]
  (let [before-collisions-x (get-in game-state [:player :last-good-position :x])
	before-collisions-y (get-in game-state [:player :last-good-position :y])] 

    (put-in game-state [:player :position :x] (get-in game-state [:player :last-good-position :x]))
    (put-in game-state [:player :position :y] (get-in game-state [:player :last-good-position :y]))

    game-state
    ))

(defn trigger-event [event game-state]
  (print "Triggering event")
  game-state)

(defn collect-item [item-data game-state]

  (print "Collecting item")
  (tasks/push {:action :remove :entity :id})
  (tasks/push {:action :add    :entity item-data})
  
  (def filtered-game-state (entity/remove-entity game-state (item-data :id)))
  
  # add it to the players items
  (items/add filtered-game-state item-data))

# collision.janet
(defn check-all-collisions [player-rect object-type objects]

  (cond (= object-type :area)
	(filter (fn [obj] (rectangles-overlap?
			   player-rect obj)) objects)
	(= object-type :entities)
	(filter (fn [obj]
		  (rectangles-overlap?
		    player-rect
		    (get-in obj [:components]))) objects)
	
	# else
	(print "Collission for unknown object type")
	))


(defn handle-collision [collision-type collision-data game-state]


  (if (get-in game-state [:debug])
    (draw-rectangle-rec [(* (collision-data :x) scale)
			 (* (collision-data :y) scale)
			 (* (collision-data :width) scale)
			 (* (collision-data :height) scale)]
			(color 255 255 255 64)))
  
  (case collision-type
    :static (do
	      (mission/notify :sprite-collision collision-data game-state)
	      (revert-player-position game-state))
    :trigger (trigger-event collision-data game-state)
    :item (collect-item collision-data game-state)
    :location (mission/notify :area collision-data game-state)))


(defn handle [game-state]

  (var pos (player-pos game-state))
  
  (var collisions
    (check-all-collisions pos :area (get-in game-state [:env-location])))

  (var state-changes
    (map (fn [c] (handle-collision (c :type) c game-state)) collisions))

  (if (= nil (first state-changes))
    game-state
    (first state-changes))
  )




 

