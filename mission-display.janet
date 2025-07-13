(import jaylib :as "jaylib")
(use ./utils)

# probably should macro this.
(var texture :nil)

(defn init [ ]
  (var image-path (string/join ["resources/images/mission-static.png"] ))
  (set texture (load-image-to-texture image-path)))

(defn draw [player]
  (var x 0)
  (var y 0)
  
  (jaylib/draw-texture-ex texture [ x y 
				     ] 0  1 :white))
				 

