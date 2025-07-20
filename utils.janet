(import jaylib :as jaylib)
(import spork/randgen :as randgen :fresh true)

(defn color [r g b a]
  [(/ r 255.0)
   (/ g 255.0)
   (/ b 255.0)
   (/ a 255.0)])


# return an x-y within rectangle.
(defn random-within-rect[rect]

  (var x (randgen/rand-int  (rect :x) (+ (rect :x) (rect :width))))
  (var y (randgen/rand-int  (rect :y) (+ (rect :y) (rect :height))))
  
  @{:x (math/round x ) :y (math/round y)}
  )


(defn load-image-to-texture [img-path]
  (var image (jaylib/load-image-1 img-path))
  (var texture (jaylib/load-texture-from-image image))
  (jaylib/unload-image image)
  texture)

(defn string-keys-to-keywords [tbl]
  (var newtbl @{})
  (each k (keys tbl)
    (var val (tbl k))
    (put newtbl (if (string? k) (keyword k) k) val))
  newtbl)

(defn assoc-in [m ks v]
  (if (empty? ks)
    m
    (do
      (def key (first ks))
      (def rest (slice ks 1))
      (def sub (get m key))
      (def new-sub
        (if (empty? rest)
          v
          (assoc-in (if (table? sub) sub (table)) rest v)))
      (def out (table))
      (each [k val] (pairs m)
        (put out k val))
      (put out key new-sub)
      out)))

(defn update-in [m ks f & args]
  (if (empty? ks)
    m
    (do
      (def key (first ks))
      (def rest (slice ks 1))
      (def sub (get m key))
      (def new-sub
        (if (empty? rest)
          (apply f (do
            (def callargs (array sub))
            (each a args (array/push callargs a))
            callargs))
          (apply update-in (if (table? sub) sub (table)) rest f args)))
      (def out (table))
      (each [k val] (pairs m)
        (put out k val))
      (put out key new-sub)
      out)))

(defn player-pos [game-state] (get-in game-state [:player :position]))
(defn player-x [game-state] (get-in game-state [:player :position :x]))
(defn player-y [game-state] (get-in game-state [:player :position :y]))
	 

(defn update-position [game-state x y]
  (print "UPDATING POSITION")
  (merge game-state {:player @{:position {:x x
					 :y y
					 :width  (get-in game-state [:player :position :width])
					 :height (get-in game-state [:player :position :height])
					 :speed  (get-in game-state [:player :speed])}
			      :image "dog.png"
			      :speed (get-in game-state [:player :speed])
			      :last-good-position @{:x (math/round (player-x game-state))
					  	    :y (math/round (player-y game-state))}}}))


(defn scale-rect [r factor]
    {:x        (* (r :x) factor)
     :y        (* (r :y) factor)
     :width    (* (r :width) factor)
     :height   (* (r :height) factor)})
