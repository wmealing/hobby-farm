(import jaylib :as "jaylib")

(var texture :not-loaded)

# probably should macro this.
(defn load-image-to-texture [img-path]
  (var image (jaylib/load-image-1 img-path))
  (var texture (jaylib/load-texture-from-image image))
  (jaylib/unload-image image)
  texture)

(defn init []
  (set texture (load-image-to-texture "resources/images/dog.png"))
)

(defn draw [x y]
  (jaylib/draw-texture-ex texture [x y] 0  1 :white))

(defn collides-with [object]
  )

