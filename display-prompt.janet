(import jaylib :as "jaylib")
(use ./utils) 

(var display-texture :not-loaded)
(var ui-font :not-loaded)


(defn init []
  (set ui-font (jaylib/load-font-ex "resources/font/TX-02-Regular.otf" 48))
  (set display-texture (load-image-to-texture "resources/images/dialog.png")))

(defn draw [game-state]
 
(let [msg (get-in game-state [:debug-msg])]
  (when (not (empty? msg))
    (jaylib/draw-texture-ex display-texture [0   500] 0  1 :white)
    (jaylib/draw-text-ex ui-font msg [400 750] 48 1 :white))))
 

