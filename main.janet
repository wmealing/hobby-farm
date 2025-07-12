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

(var screen-width  800)
(var screen-height 800)

(defn debug-dot [x y]
  (draw-circle x y 10 :black))

(var game-state {:boot-time :unset
		 :player :unset
                 :loaded true
                 :debug true
		 :camera :not-initiated
		 :debug-msg "hello world"
                 :mission {}})

# I can initialize it now.
(var player {:type "PLAYER" :image "dog.png"
	     :speed 500
	     :position {:x 300 :y 0 :height 100 :width 100}
	     :last-good-position {:x 0 :y 0 :height 100 :width 100}})

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
    :x 130 :y 240
    :height 150 :width 200
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

  (var player-position (get-in game-state [:player :position]))

  (var locations (get-in game-state [:env-location]))

  (var new-collisions
    (reduce (fn [acc el]
              (if (is-collision? player-position el)
                  (tuple/join acc (tuple el))
                acc))
            '()
            locations))

  (merge game-state {:collisions new-collisions}))

(defn resolve-collisions [game-state]

  (var collisions (get-in game-state [:collisions]))
  (var new-state game-state)
  
  (case collisions
    '() (set new-state game-state)
    (let [before-collisions-x (get-in game-state [:player :last-good-position :x])
	  before-collisions-y (get-in game-state [:player :last-good-position :y])]

      (each collision collisions
	(case (collision :type)
	  "location" (do
		       # okay so we get a new status here.
		       (set  new-state (mission/notify :area collision game-state))
		       # (print (math/floor (get-time))  " - UPDATE MISSION STATE: " )
		       )
	  (set new-state (pl/update-location game-state before-collisions-x before-collisions-y))))))
  new-state

  )

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
  
  (set game-state (mission/start :start game-state))

  (while (not (window-should-close))
    
    (ev/sleep 0)
    (var delta-time (get-frame-time))
    
    (camera/update game-state screen-width screen-height delta-time)
    
    (set game-state (inputs/handle-keys game-state delta-time))
    (set game-state (update-player game-state delta-time))
    (set game-state (resolve-collisions game-state))
    
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

	# honestly this is debugging.
	(each i (get-in game-state [:env-location])
	  (draw-rectangle-rec [(* (i :x) scale)
			       (* (i :y) scale)
			       (* (i :width) scale)
			       (* (i :height) scale) ] :red))

	# draw the sprites.
	(each item sprite-items
	  (cond (= (item :type) :static) (sprite/draw item)))

	(pl/draw (get-in game-state [:player]))
				
        (end-mode-2d)
        (hud/draw game-state)
	(end-drawing))))
  
  (close-window))

