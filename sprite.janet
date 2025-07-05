(import jaylib :as "jaylib")

(var sprite-textures  @{})

# probably should macro this.
(defn load-image-to-texture [img-path]
  (var image (jaylib/load-image-1 img-path))
  (var texture (jaylib/load-texture-from-image image))
  (jaylib/unload-image image)
  texture)

(defn init [sprite-list]
  (print "SPRITE INIT")
)

(defn draw [sprite]
  (var image (sprite :image))
  (var te (get sprite-textures image :unset))

  # when we cache miss, load it and set it.
  (when (= :unset te)
    (set te (load-image-to-texture image))
    (put sprite-textures image te))

  (jaylib/draw-texture-ex te
			  [(sprite :x) (sprite :y )]
			  0  (sprite :scale) :white))

