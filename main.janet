(use jaylib)

(import spork/netrepl)

(use ./vector)
(use ./utils)

(import ./loading-screen :as loading-screen :fresh true)
(import ./display-prompt :as display-prompt :fresh true)
(import ./background :as background :fresh true)
(import ./collision :as collision :fresh true)
(import ./sprite :as sprite :fresh true)
(import ./player :as pl :fresh true)
(import ./mission :as mission :fresh true)
(import ./hud :as hud :fresh true)
(import ./camera :as camera :fresh true)
(import ./inputs :as inputs :fresh true)
(import ./game-state :as "" :fresh true)

(var scale 4)
(var screen-width  800)
(var screen-height 800)

(defn debug-dot [x y]
  (draw-circle x y 10 :black))

(var game-state @{:boot-time :unset
		  :player :unset
                  :loaded true
                  :debug true
		  :camera :not-initiated
		  :debug-msg "hello world"
                  :mission {}})

# I can initialize it now.
(var player {:image "dog.png"
	     :speed 500
	     :position @{:x 0 :y 0 :height 100 :width 100}
	     :last-good-position @{:x 0 :y 0}})

(set game-state (merge game-state {:player player}))

(defn gamestate->player-position [player]
  (get-in game-state [:player :position]))

(def h 400)

(var env-items [])

(var sprite-items
  [{:type :static
    :solid true
    :scale 0.25
    :x 60 :y 60
    :height 200 :width 200
    :image "resources/images/doghouse.png" :action "cluck"}
   {:type :static
    :solid true
    :scale 0.5
    :x 460 :y -300
    :height 200 :width 200
    :image "resources/images/farmer-house.png" :action "cluck"}
   {:type :static
    :solid false
    :scale 0.25
    :x 130 :y 240
    :height 150 :width 200
    :image "resources/images/farmer.png" :action "cluck"}])

(defn item->location-arr [i]
    [(i :x)
     (i :y)
     (i :width)
     (i :height)])

(defn item->location [item]
  (get-in item [:location]))

(defn item->color [item]
  (get item :color :black))

(defn play-audio [sound-file]
  # (print "BEEP")
  )

(defn render-game [game-state]
    (clear-background :light-gray)
    (begin-mode-2d (get-in game-state [:camera]))

    # probably not ideal, but we'll see
    (background/draw)
    
    # honestly this is debugging.
    (each i (get-in game-state [:env-location])
      (draw-rectangle-rec [(* (i :x) scale)
			   (* (i :y) scale)
			   (* (i :width) scale)
			   (* (i :height) scale) ] :red))
    
    # draw the sprites.
    (each item sprite-items
	  (cond (= (item :type) :static) (sprite/draw item)))
    
    (pl/draw game-state)
    
    (end-mode-2d)
    (hud/draw game-state)
  )

(defn main [& args]

      (def repl-server
	   (netrepl/server "127.0.0.1" "9365" (fiber/getenv (fiber/current))))

      (init-window screen-width screen-height "HOBBY FARM")

      (loading-screen/init)
      (init-audio-device)
      (set-master-volume 1)

      (set game-state (background/init game-state))

      (background/init game-state)
      (hud/init)
      (display-prompt/init)
      (sprite/init sprite-items)
      (pl/init game-state)

      (set game-state (assoc-in game-state @[:camera] (camera/init game-state screen-width screen-height)))

      (set-target-fps 60)
  
      (set game-state (mission/start :start game-state))

      (while (not (window-should-close))
    
	(ev/sleep 0)		#repl
	(var delta-time (get-frame-time))

	# update phase
	(camera/update game-state screen-width screen-height delta-time)
	(set game-state (inputs/handle-keys game-state delta-time))
	(set game-state (collision/handle game-state))

	# render phase
	(render-game game-state)
    
	(begin-drawing)
	(end-drawing))
  
      (close-window))



