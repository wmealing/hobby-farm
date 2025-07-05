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

(var scale 4)

(var screen-width 1000)
(var screen-height 800)

(defn debug-dot [x y]
  (draw-circle x y 10 :black))

(var game-state {:boot-time :unset
		 :player {:speed 700}
                 :loaded true
                 :debug true
		 :debug-msg "hello world"
                 :mission {}})

# I can initialize it now.
(var player {:type "PLAYER" :image "dog.png"
	     :position {:x 300 :y 0 :height 100 :width 100}
	     :last-good-position {:x 0 :y 0 :height 100 :width 100}
	     :speed 0 :collisions-with []})

(defn player->position [player]
  (player :position))

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

(defn resolve-interactions [player]

  (var collisions (get-in player [:collisions-with]))
  (var unresolved-collisions (array/new (length collisions)))

  (each object collisions
    (var action (object :action))

    (cond
      (= action "beep")  (play-audio "beep-10.wav")
      (= action "cluck") (play-audio "chicken-cluck.wav")
      (array/push unresolved-collisions object))

    unresolved-collisions))

(defn update-player [player game-state delta-time]

  (resolve-interactions player)

  (var player-position (player->position player))
  (var player-x (player-position :x))
  (var player-y (player-position :y))

  # using when instead of cond as multiple keys are possible.
  (when (key-down? :left)
    (set player-x (- player-x (* (get-in game-state [:player :speed])
				 delta-time))))

  (when (key-down? :right)
    (set player-x (+ player-x (* (get-in game-state [:player :speed])
				 delta-time))))

  (when (key-down? :up)
    (set player-y (- player-y (* (get-in game-state [:player :speed])
				 delta-time))))

  (when (key-down? :down)
    (set player-y (+ player-y (* (get-in game-state [:player :speed])
				delta-time))))

  (var env-items (get-in game-state [:env-location]))

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

      (map (fn [e] (mission/notify :in-area e game-state)) all-collisions)

      (merge player {:position {:x      (get-in player [:last-good-position :x] 10)
                                :y      (get-in player [:last-good-position :y] 10)
				:width  (get-in player [:position :width])
				:height (get-in player [:position :height])}
                     :collisions-with all-collisions}))
    (do
      (merge player {:position {:x (math/round player-x)
                                :y (math/round player-y)
				:width  (get-in player [:position :width])
				:height (get-in player [:position :height])}
                            :collisions-with all-collisions
                            :last-good-position {:x (math/round (get-in player [:position :x]))
                                                 :y (math/round (get-in player [:position :y]))}})
      )))

# UpdateCameraCenterSmoothFollow
(defn camera-update [camera delta-time]

  (set (camera :zoom) (+ (camera :zoom) (* (get-mouse-wheel-move) 0.05)))

  (var min-speed 140)
  (var min-effect-length 10)
  (var fraction-speed 1.2)

  (set (camera :offset) [(/ screen-width 2.0)
                         (/ screen-height 2.0)])


  (var diff (Vector2Subtract (get-in player [:position])
                             (Array2Vec (camera :target))))

  (var length (Vector2Length diff))

  (when (> length min-effect-length)

    (var speed (max (* length fraction-speed) min-speed))

    (def change-needed (Vector2Scale diff (* speed (/ delta-time length))))
    (def current-target (Array2Vec (camera :target)))
    (def new-camera-target (Vector2Add change-needed current-target))

    (set (camera :target) [(+ (new-camera-target :x) 0)
                           (- (new-camera-target :y) 0)]))

    # clamp camera zoom.
    (cond (>= (camera :zoom) 5.0) (set (camera :zoom) 5.0)
      (<= (camera :zoom) 0.25) (set (camera :zoom) 0.25))
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
  (pl/init player)

  (var camera (camera-2d
                :target [((player :position) :x) ((player :position) :y)]
                :offset [(/ screen-width 2.0)    (/ screen-height 2.0)]
                :rotation 0
                :zoom 1))

  (set-target-fps 60)
  
  (set game-state (mission/start :introduction game-state))

  (var last-second (os/time))

  (while (not (window-should-close))
    (ev/sleep 0)

    (var delta-time (get-frame-time))

    (set player (update-player player game-state delta-time))

    (camera-update camera delta-time)

    # reset on r keypress.
    (when (key-down? :r) (do
                           (set (camera :zoom) 2)))

    (when (key-down? :i) (do
                           (print "INFORMATION:")
                           (pp player)
                           (print "GAME STATE: ")
                           (pp game-state)))

    (when (key-down? :m) (do
			   (print "MISSION STATE... ")
			   (pp (get game-state :mission)) 
			   (print "WUT")
			   ))
    
    (when (key-down? :q) (do
			   (print "loaading.")
			   (import ./hud :as "hud" :fresh true)
			   (set game-state (put-in game-state [:debug-msg] ""))))
			   

    (begin-drawing)

    (clear-background :light-gray)

    (if (not (get game-state :loaded))
      (do # draw the loading screen
        (loading-screen/draw)
        (when (> (- (os/time)
                    (get game-state :boot-time)) 1)
          (set game-state (assoc-in game-state @[:loaded] true))))
      
      (do # do the main loop
        (var this-frame (os/time))
        (begin-mode-2d camera)

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

	(pl/draw player)
	
        (end-mode-2d)

        (hud/draw game-state)
	(display-prompt/draw game-state)
        ))

    (end-drawing))
  (:close repl-server)
  (close-window)
  )
