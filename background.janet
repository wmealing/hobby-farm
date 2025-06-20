(import jaylib :as "jaylib")
(import json)

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

(defn load-tile-cache [map-data image-path]

  (print "LOAD TILE CACHE")
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


(defn init []
  (set map-data (load-map "resources/testmap.json"))
  (set tile-cache (load-tile-cache map-data "resources/images/grass.png"))
  (print "TILE CACHE LOADED: " tile-cache)
  (print "TILE CACHE SIZE: " (length tile-cache))
  )

(defn draw []
  (var c 0)
  (def scale 4)
  (print "BG DRAWING DRAW")

  (print "MAP WIDTH:  " map-width )
  (print "MAP HEIGHT: " map-height)

  (def layer-0 (-> (get map-data "layers")
		   (get 0)
		   (get "data")))

  (loop [j :range [0 (* tile-height map-height) tile-height ]
	 i :range [0 (* tile-width map-width)  tile-width   ]
	 ]

    (var map-val (get layer-0 c))
    (def t (get tile-cache (- map-val 1)))
    
    (print "MAP VAL: " (- map-val 1))
    (print "C1: " c)
    (print "T1: " t)

    (jaylib/draw-texture-ex t [(* i scale) (* j scale) ] 0 scale :ray-white)
    
    (print "I * SCALE: " (* i scale))

    (jaylib/draw-rectangle-lines (* i scale)
				 (* j scale)
				 (* tile-height scale)
				 (* tile-height scale) :black)

    (++ c)
    
    ))



