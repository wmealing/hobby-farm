(import jaylib :as "jaylib")
(use ./utils)

(var texture :not-loaded)


(defn init []
  (set texture (load-image-to-texture "resources/images/title-screen.png")))

(defn draw []
  (jaylib/draw-texture-ex texture [-50 0 ] 0  1 :white)
  )


