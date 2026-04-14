(use ./utils)
(import /entity)
(import spork/randgen)


(var last-time-random 0)

(defn sheep-mission [game-state]

  (var locations (get-in game-state [:env-location]))
  
  (var sheep-start (first (filter (fn [e] (= (e :name) "sheepspawn-location")) locations)))

  (var entities
      (->> (range 30)
	   (map (fn [arg]
		  (var r (random-within-rect sheep-start))
		  (entity/make-entity {:width 20
				       :height 20
				       :scale 0.1
				       :x (r :x)
				       :y (r :y)
				       :type :animal
				       :name "sheep"
				       :image "resources/images/sheep1.png" })))))

  (var existing-entities (entity/fetch-all game-state))

  (put-in game-state [:entities] (array/concat @[] existing-entities entities))
  game-state
  )
    

(defn egg-mission [game-state]
    (var items (get-in game-state [:env-location]))

    # how about a bunch of eggs to collect,should only be 1
    (var egg-holder (first (filter (fn [e] (= (e :name) "eggspawn-location")) items)))
    
    # generate 30 eggs, to hand in.
    (var entities
      (->> (range 30)
	   (map (fn [arg]
		  (var r (random-within-rect egg-holder))
		  (entity/make-entity {:width 20
				       :height 20
				       :scale 0.1
				       :x (r :x)
				       :y (r :y)
				       :type :item
				       :name "egg"
				       :image "resources/images/egg.png" })))))

    # Find the existing , sprites..
    (var existing-entities (entity/fetch-all game-state))

    (put-in game-state [:entities] (array/concat @[] existing-entities entities))

  game-state
  )



# I spawn events tha the player can do.
(defn new [game-state delta-time]

  (var now (os/time))

  (when (<= 5 (- now last-time-random))
	     
    (var mission-list [:egg-mission :sheep-mission :none])
    (var r (randgen/rand-int 0 (length mission-list)))
    (var choice (get mission-list r))
    (print "RANDOM IS: " choice " - " now )
    (set last-time-random now)

    (cond 
	  (= choice :egg-mission) (egg-mission game-state)
	  (= choice :sheep-mission) (sheep-mission game-state)
	  (print "NO MISSION")))
  
  game-state)

