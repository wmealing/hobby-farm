(import jaylib :as "jaylib")
(import spork/json)
(import ./utils :as utils)
(use ./utils)

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

(defn get-layer [n]
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
	     x :range [0 image-width  tile-width  ]]

	    (var rect [x y tile-width tile-height])
	    (def image (jaylib/image-from-image full-image rect))
	    (def texture (jaylib/load-texture-from-image image))
	    (array/push arr texture))
      arr)

(defn init [game-state]
  (set map-data (load-map "resources/testmap.json"))

  (merge game-state
	 {:env-location (layer-objects 2)}))


