(use jaylib)
(use ./vector)
(use ./utils)

(import ./loading-screen :as loading-screen :fresh true)
(import ./map :as map :fresh true)
(import ./background :as background :fresh true)
(import ./sprite :as sprite :fresh true)
(import ./player :as pl :fresh true)
(import ./mission :as mission :fresh true)
(import ./hud :as hud :fresh true)

(var screen-width 800)
(var screen-height 800)

(defn debug-dot [x y]
  (draw-circle x y 10 :black))

(var game-state {:boot-time :unset
                 :loaded false
                 :debug true
                 :mission {}})

(var G 400)
(var player-horizontal-speed 400)

# I can initialize it now.
(var player {:type "PLAYER" :image "dog.png" :position {:x 50 :y 50} :speed 0 :collisions-with []})

(defn player->position [player]
  (player :position))

(def h 400)

# (var env-items [{:location {:x 0   :y   0 :width  100 :height h} :blocking false   :color :light-gray :description "grey block"}
# 		{:location {:x 0   :y 200 :width  100 :height h} :blocking true    :color :green      :description "green block"}
# 		{:location {:x 0   :y 350 :width  200 :height h} :blocking true    :color :blue       :description "Blue block" :action "beep"}
#   		{:location {:x 350 :y 450 :width  400 :height h} :blocking true    :color :red        :description "red block"}
# 		{:location {:x 750 :y 500 :width  100 :height h} :blocking true    :color :white      :description "white block"}
# 		])

(var env-items [])

(var sprite-items
  [{:type :static
    :solid true
    :location {:x 60 :y 60 :height 200 :width 200}
    :image "resources/images/doghouse.png" :action "cluck"}
   {:type :static
    :solid true
    :location {:x 460 :y -50 :height 200 :width 200}
    :image "resources/images/farmer-house.png" :action "cluck"}
   {:type :static
    :solid false
    :location {:x 660 :y 180 :height 200 :width 200}
    :image "resources/images/farmer.png" :action "cluck"}])

(defn item->location-arr [item]
  (let [i (get-in item [:location])]
    [(get-in i [:x])
     (get-in i [:y])
     (get-in i [:width])
     (get-in i [:height])]))

(defn item->location [item]
  (get-in item [:location]))

(defn item->color [item]
  (item :color))

(defn is-collision? [point rect]
  (when (and (<= (rect :x) (point :x))
             (>= (+ (rect :x) (rect :width)) (point :x))
             (<= (rect :y) (point :y))
             (<= (point :y) (+ (rect :y) (rect :height))))
    true))

(defn play-audio [sound-file]
  # (print "BEEP")
  )

(defn resolve-interactions [player]

  (var collisions (get-in player [:collisions-with]))
  (var unresolved-collisions (array/new (length collisions)))

  (each object collisions
    (var action (object :action))

    (cond
      (= action "beep") (play-audio "beep-10.wav")
      (= action "cluck") (play-audio "chicken-cluck.wav")
      (array/push unresolved-collisions object))

    unresolved-collisions))

(defn update-player [player env-items delta-time]

  # resolve all collisions first, maybe this
  # might return something later, if it takes too long.. something like that.
  (resolve-interactions player)

  (var player-position (get-in player [:position]))
  (var player-x (player-position :x))
  (var player-y (player-position :y))

  # using when instead of cond as multiple keys are possible.
  (when (key-down? :left)
    (set player-x (- (get-in player [:position :x]) (* player-horizontal-speed delta-time))))

  (when (key-down? :right)
    (set player-x (+ (get-in player [:position :x]) (* player-horizontal-speed delta-time))))

  (when (key-down? :up)
    (set player-y (- (get-in player [:position :y]) (* 400 delta-time))))

  (when (key-down? :down)
    (set player-y (+ (get-in player [:position :y]) (* 400 delta-time))))

  # now we check for collisions with each object.
  (var hit-obstacle false)

  (var new-collisions
    (reduce (fn [acc el]
              (if (is-collision? player-position (get-in el [:location]))
                (tuple/join acc (tuple el))
                acc))
            '()
            env-items))

  (var sprite-collisions
    # skip the items that are non solid. WORKING
    (->> sprite-items
         (filter (fn [i] (not (get i :solid))))
         (reduce (fn [acc el]
                   (if (is-collision? player-position (get-in el [:location]))
                     (tuple/join acc (tuple el))
                     acc))
                 '())))

  (var all-collisions (tuple/join new-collisions sprite-collisions))

  (if (< 0 (length all-collisions))
    (do

      (var lg-x (get-in player [:last-good-position :x]))
      (var lg-y (get-in player [:last-good-position :y]))

      (merge player {:position {:x lg-x
                                :y lg-y}
                     :collisions-with all-collisions}))
    (do
      (var p (merge player {:position {:x (math/round player-x)
                                       :y (math/round player-y)}
                            :collisions-with all-collisions
                            :last-good-position {:x (math/round (get-in player [:position :x]))
                                                 :y (math/round (get-in player [:position :y]))}}))
      p)))

# UpdateCameraCenterSmoothFollow
(defn camera-update [camera delta-time]

  (set (camera :zoom) (+ (camera :zoom) (* (get-mouse-wheel-move) 0.05)))

  (var min-speed 40)
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

  (set game-state (assoc-in game-state [:boot-time] (os/time)))
  
  (init-window screen-width screen-height "HOBBY FARM")

  (loading-screen/init)

  (init-audio-device)

  (set-master-volume 1)

  (map/init)

  (background/init)
  (hud/init)
  (sprite/init sprite-items)
  (pl/init player)

  (var camera (camera-2d
                :target [((player :position) :x)
                         ((player :position) :y)]
                :offset [(/ screen-width 2.0)
                         (/ screen-height 2.0)]
                :rotation 0
                :zoom 1))

  (set-target-fps 60)

  (var last-second (os/time))

  (while (not (window-should-close))

    (var delta-time (get-frame-time))

    (set player (update-player player env-items delta-time))

    (camera-update camera delta-time)

    # reset on r keypress.
    (when (key-down? :r) (do
                           (set player (merge player {:location {:x 400 :y 280}}))
                           (set (camera :zoom) 2)))

    (when (key-down? :i) (do
                           (print "INFORMATION:")
                           (pp player)
                           (print "GAME STATE: ")
                           (pp game-state)))

    (when (key-down? :m) (do
			   (print "MISSION STARTING... ")
			   (mission/start :fetch-dog game-state)
			   ))

    (when (key-down? :q) (do
                           (debug)))


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

        # location areas.
        (loop [i :range [0 (length env-items)]]
          (draw-rectangle-rec (item->location-arr (i env-items))
                              (item->color (i env-items))))

        # sprites
        (loop [i :range [0 (length sprite-items)]]
          (var item (i sprite-items))
          (cond (= (item :type) :static) (sprite/draw item)))

	(pl/draw player)
	
        (end-mode-2d)

        (hud/draw)

        ))

    (end-drawing))

  (close-window))
