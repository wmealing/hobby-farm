(import jaylib :as "jaylib")
(import /items)
(use ./utils)


(var hud-texture :not-loaded)
(var tx-02 :not-loaded)
(var coin-graphic :not-loaded)

(defn init []
  (set tx-02 (jaylib/load-font-ex "resources/font/TX-02-Regular.otf" 48))
  (set hud-texture (load-image-to-texture  "resources/images/hud.png"))
  (set coin-graphic (load-image-to-texture "resources/images/hud-coin.png"))
  )


(defn draw [game-state]

  (var mission-name (get-in game-state [:debug-msg]))
  (var money (items/fetch-by-count game-state :type :money))

  
  (jaylib/draw-texture-ex hud-texture [20 720] 0  0.75 :white)
  (jaylib/draw-text-ex tx-02 mission-name [400 750] 48 1 :white)
  (jaylib/draw-texture-ex coin-graphic [40 720] 0 0.5 :white)
  (jaylib/draw-text-ex tx-02 (string/format "%d" money) [90 725] 48 1 :white)
  )

