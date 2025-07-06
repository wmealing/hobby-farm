(use jaylib)

(import spork/netrepl)

(use ./vector)
(use ./utils)

(import ./loading-screen :as loading-screen :fresh true)
(import ./display-prompt :as display-prompt :fresh true)
(import ./map :as map :fresh true)
(import ./background :as background :fresh true)
(import ./sprite :as sprite :fresh true)
(import ./player :as pl :fresh true)
(import ./mission :as mission :fresh true)
(import ./hud :as hud :fresh true)
(import ./camera :as camera :fresh true)
(import ./inputs :as inputs :fresh true)

(var scale 4)

(var screen-width 1000)
(var screen-height 800)

(defn debug-dot [x y]
  (draw-circle x y 10 :black))

(var game-state {:boot-time :unset
		 :player {:speed 700}
                 :loaded true
                 :debug true
		 :camera :not-initiated
		 :debug-msg "hello world"
                 :mission {}})

# I can initialize it now.
(var player {:type "PLAYER" :image "dog.png"
	     :speed 500
	     :position {:x 300 :y 0 :height 100 :width 100}
	     :last-good-position {:x 0 :y 0 :height 100 :width 100}
	     :collisions-with []})


(set game-state (merge game-state {:player player}))

(defn gamestate->player-position [player]
  (get-in game-state [:player :position]))

(def h 400)

(var env-items [])

(var sprite-items
  [{:type :static
    :solid true
    :scale 0.25
    :x 60 :y 60
    :height 200 :width 200
    :image "resources/images/doghouse.png" :action "cluck"}
   {:type :static
    :solid true
    :scale 0.5
    :x 460 :y -300
    :height 200 :width 200
    :image "resources/images/farmer-house.png" :action "cluck"}
   {:type :static
    :solid false
    :scale 0.25
    :x 660 :y 380
    :height 200 :width 200
    :image "resources/images/farmer.png" :action "cluck"}])

(defn item->location-arr [i]
    [(i :x)
     (i :y)
     (i :width)
     (i :height)])

(defn item->location [item]
  (get-in item [:location]))

(defn item->color [item]
  (get item :color :black))

(defn scale-rect [r factor]
    {:x        (* (r :x) factor)
     :y        (* (r :y) factor)
     :width    (* (r :width) factor)
     :height   (* (r :height) factor)})

(defn is-collision? [r1 r2-orig]

  # required because we need to account for zoom.
  (var r2 (scale-rect r2-orig scale))

  (not (or
	 (> (r1 :x) (+ (r2 :x) (r2 :width)))
	 (> (r2 :x) (+ (r1 :x) (r1 :width)))
	 (> (r1 :y) (+ (r2 :y) (r2 :height)))
	 (> (r2 :y) (+ (r1 :y) (r1 :height))))))

(defn play-audio [sound-file]
  # (print "BEEP")
  )

(defn update-player [game-state delta-time]

  (print "UPDATE PLAYER")
  (pp game-state)
  (var player-position (get-in game-state [:player :position]))
  
  (var player-x (get-in player-position [:x]))
  (var player-y (get-in player-position [:y]))

  (var new-collisions
    (reduce (fn [acc el]
              (if (is-collision? player-position el)
                  (tuple/join acc (tuple el))
                acc))
            '()
            env-items))

  (var sprite-collisions [])

  (var all-collisions (tuple/join new-collisions sprite-collisions))

  (if (< 0 (length all-collisions))
    (do
      (merge game-state {:player {:position {:x      (get-in player [:last-good-position :x] 10)
					     :y      (get-in player [:last-good-position :y] 10)
					     :width  (get-in player [:position :width])
					     :height (get-in player [:position :height])}
				  :speed (get-in player [:speed])
				  :collisions-with all-collisions}}))
    (do
      (merge game-state  {:player {:position {:x (math/round player-x)
					      :y (math/round player-y)
					      :width  (get-in player [:position :width])
					      :height (get-in player [:position :height])
					      :speed (get-in player [:speed])}
				   :speed (get-in player [:speed])
				   :collisions-with all-collisions
				   :last-good-position {:x (math/round (get-in player [:position :x]))
							:y (math/round (get-in player [:position :y]))}}}))))

(defn main [& args]

  (def repl-server
    (netrepl/server "127.0.0.1" "9365" (fiber/getenv (fiber/current))))

  (print repl-server)

  (set game-state (assoc-in game-state [:boot-time] (os/time)))
    
  (init-window screen-width screen-height "HOBBY FARM")

  (loading-screen/init)
  (init-audio-device)
  (set-master-volume 1)

  (set game-state (map/init game-state))

  (background/init)
  (hud/init)
  (display-prompt/init)
  (sprite/init sprite-items)
  (pl/init (get-in game-state [:player]))

  (set game-state (assoc-in game-state @[:camera] (camera/init game-state screen-width screen-height)))

  (set-target-fps 60)
  
  (set game-state (mission/start :introduction game-state))

  (while (not (window-should-close))

    (var delta-time (get-frame-time))

    (set game-state (inputs/handle-keys game-state delta-time))
    
    (ev/sleep 0)

    (set game-state (update-player game-state delta-time))

    (camera/update (get-in game-state [:camera])
		   game-state screen-width screen-height delta-time)

    (begin-drawing)
    (clear-background :light-gray)

    (if (not (get game-state :loaded))
      (do # draw the loading screen
        (loading-screen/draw)
        (when (> (- (os/time)
                    (get game-state :boot-time)) 1)
          (set game-state (assoc-in game-state @[:loaded] true))))
      
      (do # do the main loop
        (begin-mode-2d (get-in game-state [:camera]))

        # probably not ideal, but we'll see
        (background/draw)

	(var env-items (get-in game-state [:env-location]))

	(each i env-items
	  (draw-rectangle-rec [(* (i :x) scale)
			       (* (i :y) scale)
			       (* (i :width) scale)
			       (* (i :height) scale) ] :red))

        # sprites
        (loop [i :range [0 (length sprite-items)]]
          (var item (i sprite-items))
          (cond (= (item :type) :static) (sprite/draw item)))

	(pl/draw (get-in game-state [:player]))
				
        (end-mode-2d)

        (hud/draw game-state)
	(display-prompt/draw game-state)
        
      (end-drawing))))
  (close-window))
1
