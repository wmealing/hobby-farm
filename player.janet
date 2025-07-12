(import jaylib :as "jaylib")
(use ./utils)

(var texture :not-loaded)
(var img-name :not-loaded)


(defn init [ player ]
  (var image-path (string/join ["resources/images/" (get player :image)]))
  (set texture (load-image-to-texture image-path))
)

(defn draw [player]
    (jaylib/draw-texture-ex texture [ (- (get-in player [:position :x]) 20 )
				      (- (get-in player [:position :y]) 20 ) ] 0  1 :white))
				 

(defn update-location [game-state x y]
  (merge game-state {:player {:position {:x x
					 :y y
					 :width  (get-in game-state [:player :position :width])
					 :height (get-in game-state [:player :position :height])
					 :speed  (get-in game-state [:player :speed])}
			      :speed (get-in game-state [:player :speed])
			      :last-good-position {:x (math/round (get-in game-state [:player :position :x]))
						   :y (math/round (get-in game-state [:player :position :y]))}}})

  )
