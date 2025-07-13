(import jaylib :as "jaylib")
(import spork/json)
(use ./utils)

(var background-texture :not-loaded)
(var tile-cache :not-loaded)
(var map-data :not-loaded)

(var tile-width  0)
(var tile-height 0)
(var map-width   0)
(var map-height  0)
(var image-width 0)
(var image-height 0)

(defn load [file-path]
    (slurp file-path))

(defn convert [raw]
  (json/decode raw))

(defn load-map [file-path]
  (-> file-path
      (load)
      (convert)))

(defn get-layer [map-data n]
  (-> (get-in map-data ["layers"])
      (get n)))

# i dont like this entirely, but what can i do.
(defn layer-objects [n]
  (map (fn [x] (string-keys-to-keywords x))
       (-> (get-in map-data ["layers"])
	   (get n)
	   (get "objects"))))

(defn load-tile-cache [map-data image-path]

  (def arr @[])

  (def full-image (jaylib/load-image-1 image-path))

  (set tile-width  (get map-data "tilewidth"))
  (set tile-height (get map-data "tileheight"))
  (set map-width   (get map-data "width"))
  (set map-height  (get map-data "height"))
  (set image-width  (get (jaylib/image-dimensions full-image) 0))
  (set image-height (get (jaylib/image-dimensions full-image) 1))

  (loop [y :range [0 image-height tile-height ]
	 x :range [0 image-width  tile-width   ]
	 ]

      (var rect [x y tile-width tile-height])
      (def image (jaylib/image-from-image full-image rect))
      (def texture (jaylib/load-texture-from-image image))
      (array/push arr texture)
    )
  arr)


(defn init [game-state]
  (set map-data (load-map "resources/testmap.json"))
  (set tile-cache (load-tile-cache map-data "resources/images/grass.png"))
    (merge game-state
	 {:env-location (layer-objects 2)}))


(defn draw [ ]
  (var c 0)
  (def scale 4)

  (var layer-0 (-> (get map-data "layers")
		   (get 0)
		   (get "data")))

  (var layer-1 (-> (get map-data "layers")
		   (get 1)
		   (get "data")))

  (var layer-2 (-> (get map-data "layers")
		   (get 2)
		   (get "data")))

  (var layers [layer-0 layer-1 ])
  # this draws every tile, i xdont think i need it.

  (loop [j :range [0 (* tile-height map-height) tile-height ]
	 i :range [0 (* tile-width map-width)  tile-width   ] ]

	(each layer layers
	  (var map-val (get layer c))

	  (if (not (= map-val 0))
	    (jaylib/draw-texture-ex (get tile-cache (- map-val 1))
				    [(* i scale) (* j scale) ] 0 scale :ray-white)))
	(++ c)
	))



