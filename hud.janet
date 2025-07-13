(import jaylib :as "jaylib")
(use ./utils)

(var hud-texture :not-loaded)
(var tx-02 :not-loaded)


(defn init []
  (set tx-02 (jaylib/load-font-ex "resources/font/TX-02-Regular.otf" 48))
  (set hud-texture (load-image-to-texture "resources/images/hud.png")))

(defn draw [game-state]
  (var mission-name (get-in game-state [:debug-msg]))
  (jaylib/draw-texture-ex hud-texture [20 720] 0  0.75 :white)
  (jaylib/draw-text-ex tx-02 mission-name [400 750] 48 1 :white))

