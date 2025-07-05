(import jaylib :as "jaylib")

(var texture :not-loaded)
(var img-name :not-loaded)

# probably should macro this.
(defn load-image-to-texture [img-path]
  (var image (jaylib/load-image-1 img-path))
  (var texture (jaylib/load-texture-from-image image))
  (jaylib/unload-image image)
  texture)

(defn init [ player ]
  (var image-path (string/join ["resources/images/" (get player :image)]))
  (set texture (load-image-to-texture image-path))
)

(defn draw [player]
    (jaylib/draw-texture-ex texture [ (- (get-in player [:position :x]) 20 )
				    (- (get-in player [:position :y]) 20 ) ] 0  1 :white))
				 


