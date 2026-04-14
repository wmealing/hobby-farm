(use jaylib)
(use /utils)

(import /mission :as mission)
(import /items :as items)
(import /entity :as entity)
(import /tasks :as tasks)

(def scale 4)
(var last-collision nil)

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


  (var id1 (get-in item-data [:id]))
  (var id2 last-collision)

  (if (= (get-in item-data [:id]) last-collision)
    (do
      (print "EXISTING ITEM COLLISION"))
    (do
      (print "NEW ITEM COLLECTED")
      (tasks/push {:action :remove  :entity (item-data :id)})
      (tasks/push {:action :add     :entity item-data}))
    )


  (set last-collision (get-in item-data [:id]))

  
  game-state)

(defn move-animal [game-state collision-data ]
  (var new-game-state game-state)

  (var updated-entity collision-data)

  # remove the existing item
  (set new-game-state
       (entity/remove-entity new-game-state (collision-data :id)))

  (var player-direction (get-in game-state [:player :position :directions]))

  (pp player-direction)


  (var new-x (+ (updated-entity :x) 
                (* 5 (cond (get player-direction 0) -1 
                           (get player-direction 1)  1
                               0))))

  (var new-y (+ (updated-entity :y) 
                (* 5 (cond (get player-direction 2) -1 
                           (get player-direction 3)  1
                           0))))


  (var new-entity (-> updated-entity
		      (put :x new-x)
		      (put :y new-y)
		      # more to update here.
		      ))


  (entity/add new-game-state {:components new-entity :id (new-entity :id)})
  )



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
	(print "Collision for unknown object type")
	))


(defn handle-collision [collision-type collision-data game-state]


  (if (get-in game-state [:debug])
    (draw-rectangle-rec [(* (collision-data :x) scale)
			 (* (collision-data :y) scale)
			 (* (collision-data :width) scale)
			 (* (collision-data :height) scale)]
			(color 255 255 255 64)))


  (print "COLLISION TYPE: " collision-type)
  
  (case collision-type
    :static (do
	      (mission/notify :sprite-collision collision-data game-state)
	      (revert-player-position game-state))
    :animal (do (print "BEEP BEEP") (move-animal game-state collision-data ))
    :trigger (trigger-event collision-data game-state)
    :item (collect-item collision-data game-state)
    :location (mission/notify :area collision-data game-state))
  )


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




 

