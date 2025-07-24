(use jaylib)

(import spork/netrepl)

(use ./vector)
(use ./utils)

(import ./loading-screen :as loading-screen :fresh true)

(import ./background :as background :fresh true)
(import ./collision :as collision :fresh true)
(import ./sprite-manager :as sprite-manager :fresh true)
(import ./env-locations :as env-locations :fresh true)
(import ./player :as player :fresh true)
(import /entity :fresh true)

(import ./hud :as hud :fresh true)
(import ./camera :as camera :fresh true)

(import ./keyboard-inputs :as keyboard-inputs :fresh true)
(import ./touch-inputs :as touch-inputs :fresh true)

(import ./game-state :as "" :fresh true)
(import ./event-spawner :as es :fresh true)
(import ./default-state :as default-state)

(var scale 4)
(var screen-width  800)
(var screen-height 800)

(defn debug-dot [x y]
  (draw-circle x y 10 :black))

(var game-state (default-state/init))

(defn play-audio [sound-file]
  # (print "BEEP")
  )

(defn render-game [game-state delta-time]

  # state setup (maybe i should thread this at some point)
  (var new-game-state
    (-> game-state
	(camera/update screen-width screen-height delta-time)
	(keyboard-inputs/handle-keys delta-time)
	(touch-inputs/handle-touch delta-time)
	(es/new delta-time)))

  # drawing
  (begin-drawing)
  
  (clear-background :light-gray)
  
  (begin-mode-2d (get-in new-game-state [:camera]))

  # draw state.
  (set new-game-state
       (-> new-game-state
	   (background/draw)
	   (env-locations/draw)
	   (sprite-manager/draw)
	   (player/draw)

	   # technically interactions.
	   (env-locations/interactions)
	   (sprite-manager/interactions)
	   ))


  (end-mode-2d)

  # Draw this later because its 2d on top of game.

  # 2d controls
  (touch-inputs/draw game-state)

  # 2d huds
  (hud/draw game-state)
  
  (end-drawing)
  new-game-state)

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
  (player/init game-state)
  
  (set game-state (assoc-in game-state @[:camera] (camera/init game-state screen-width screen-height)))
  
  (set-target-fps 60)
  
  (set game-state (put-in game-state [:mission ] :unset ))
    
  (while (not (window-should-close))
    
    (ev/sleep 0)		# allow repl
    (var delta-time (get-frame-time))

    (set game-state (render-game game-state delta-time))
    
    ) 
  
  (close-window))

