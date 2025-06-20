(import jaylib :as "jaylib")

(var chicken-texture :not-loaded)

# probably should macro this.
(defn load-image-to-texture [img-path]
  (var image (jaylib/load-image-1 img-path))
  (var texture (jaylib/load-texture-from-image image))
  (jaylib/unload-image image)
  texture
  )

(defn init []
  (set chicken-texture (load-image-to-texture "resources/images/chicken.png")))

(defn draw [x y]
  #(jaylib/draw-texture-ex chicken-texture [x y] 0  0.25 :white)
  )

