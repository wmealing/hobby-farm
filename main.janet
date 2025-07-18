(use jaylib)

(import spork/netrepl)

(use ./vector)
(use ./utils)

(import ./loading-screen :as loading-screen :fresh true)

(import ./background :as background :fresh true)
(import ./collision :as collision :fresh true)
(import ./sprite-manager :as sprite-manager :fresh true)
(import ./env-locations :as env-locations :fresh true)
(import ./player :as pl :fresh true)
(import ./mission :as mission :fresh true)

(import ./hud :as hud :fresh true)
(import ./camera :as camera :fresh true)

(import ./keyboard-inputs :as keyboard-inputs :fresh true)
(import ./touch-inputs :as touch-inputs :fresh true)

(import ./game-state :as "" :fresh true)
(import ./event-spawner :as es :fresh true)

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
	     :last-good-position @{:x 0 :y 0}
	     :last-inputs @[]})

(set game-state (merge game-state {:player player}))

(defn gamestate->player-position [player]
  (get-in game-state [:player :position]))

(var sprite-items
  @[{:type :static
    :solid true
    :scale 0.25
    :x 30 :y 30
    :height 50 :width 50
    :image "resources/images/doghouse.png" :action "cluck"}
   {:type :static
    :solid true
    :scale 0.5
    :x 460 :y -300
    :height 200 :width 200
    :image "resources/images/farmer-house.png" :action "cluck"}
   {:name "The farmer"
    :type :static
    :solid false
    :scale 0.25
    :x 100 :y 50
    :height 40 :width 20
    :has-mission true
    :image "resources/images/farmer.png" :action "cluck"}
   {:name "chicken house"
    :type :static
    :solid false
    :scale 0.25
    :x 250 :y 120
    :height 60 :width 55
    :has-mission false
    :image "resources/images/chicken-coop.png" }])

(set game-state (merge game-state {:sprite-items sprite-items}))

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

(defn render-game [game-state delta-time]

  # state setup (maybe i should thread this at some point)
  (var new-game-state game-state)
  (camera/update game-state screen-width screen-height delta-time)
  (set new-game-state (keyboard-inputs/handle-keys game-state delta-time))
  (set new-game-state (touch-inputs/handle-touch game-state delta-time))

  # deprecating collisions,
  
  # drawing
  (begin-drawing)
  
  (clear-background :light-gray)
  
  (begin-mode-2d (get-in new-game-state [:camera]))


  # probably not ideal, but we'll see
  (background/draw)

  (env-locations/draw game-state)
  (sprite-manager/draw game-state)

  (pl/draw new-game-state)

  # probably should move this.
  (set new-game-state (collision/handle game-state))
  (set new-game-state (env-locations/interactions game-state))
  (set new-game-state (sprite-manager/interactions game-state))

  
  (end-mode-2d)

  # Draw this later because its 2d on top of game.
  (touch-inputs/draw game-state)
  (hud/draw game-state)
  
  (end-drawing)
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
  (sprite-manager/init game-state)
  (pl/init game-state)
  (set game-state (assoc-in game-state @[:camera] (camera/init game-state screen-width screen-height)))
  
  (set-target-fps 60)
  
  (set game-state (mission/start :introduction game-state))
    
  (while (not (window-should-close))
    
    (ev/sleep 0)		#repl
    (var delta-time (get-frame-time))

    # main game screen.
    (render-game game-state delta-time)
    
    )
  
  (close-window))

