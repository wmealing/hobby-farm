(import jaylib :as "jaylib")
(use ./utils) 

(var sprite-textures  @{})

(defn get-texture [image-path]
  (var te (get sprite-textures image-path :unset))

  (when (= :unset te)
    (set te (load-image-to-texture image-path))
    (put sprite-textures image-path te))

  te
  )

(defn init [sprite-list]
  (print "SPRITE INIT")
)

(defn draw [sprite]

  (var image (sprite :image))
  (var te (get sprite-textures image :unset))
  (var scale 4 )

  # when we cache miss, load it and set it.
  (when (= :unset te)
    (set te (load-image-to-texture image))
    (put sprite-textures image te))

  # this is annoying.
  (let [new-x (* (sprite :x) scale) 
	new-y (* (sprite :y) scale)]
    
    (jaylib/draw-texture-ex te [new-x new-y]
			    0
			    (sprite :scale) :white)))


