(use jaylib)
(use ./vector)


(defn init [game-state screen-width screen-height]
   (var camera (camera-2d
                :target [(get-in game-state [:player :position :x])
			 (get-in game-state [:player :position :y])]
                :offset [(/ screen-width  2.0)
			 (/ screen-height 2.0)]
                :rotation 0
                :zoom 1)) 
)

(defn update [game-state screen-width screen-height delta-time]

  (var camera (get-in game-state [:camera]))

  (set (camera :zoom) (+ (camera :zoom) (* (get-mouse-wheel-move) 0.05)))

  (var min-speed 140)
  (var min-effect-length 10)
  (var fraction-speed 1.2)

  (set (camera :offset) [(/ screen-width 2.0)
                         (/ screen-height 2.0)])


  (var diff (Vector2Subtract (get-in game-state [:player :position])
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
