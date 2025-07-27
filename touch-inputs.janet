(use jaylib)
(use ./utils)
(import ./movement :as movement :fresh true)

(def thumbpad-radius 80)
(def button-radius 50)

# may need to calculate these relative to screen size ?
(def thumbpad-center [150 650]) # bottom-left position
(def button-center [650 650]) # bottom-right position


(defn handle-touch [game-state delta-time ]

  # TODO: figure out if i need to use mouse or touch events.. fml.
  (var new-game-state game-state)
  
   (if (= (get-gesture-detected) :drag)
    (let [drag-vector (get-gesture-drag-vector)
	  drag-vector-x (get drag-vector 0)
	  drag-vector-y (get drag-vector 1)
	  dead-zone 0.05]

      (var left nil)
      (var right nil)
      (var up nil)
      (var down nil)

      # implement dead zone for x
      (cond
        (< drag-vector-x (- dead-zone)) (set left :left)
        (> drag-vector-x dead-zone)     (set right :right))

      # implement dead zone for y
      (cond
        (< drag-vector-y (- dead-zone)) (set up :up)
        (> drag-vector-y dead-zone)     (set down :down))

      (set new-game-state 
	   (movement/calculate game-state
			       delta-time
			       [left right up down]))))
  new-game-state)

(defn draw [game-state]

  (var tp-original-x (get thumbpad-center 0))
  (var tp-original-y (get thumbpad-center 1))

  (var change 30)

  (var [left right up down] (get-in game-state [:player :position :directions]))

  (var tp-x (+ tp-original-x (cond (= :left left) (* -1 change)
				   (= :right right ) change
				   0)))
  (var tp-y (+ tp-original-y (cond (= :up up) (* -1 change)
				   (= :down down ) change
				   0)))
  
  # Draw thumbpad base (outer circle, translucent white)
  (draw-circle (get thumbpad-center 0)
               (get thumbpad-center 1)
               thumbpad-radius
               (color 255 255 255 150))
  
  # Draw thumbpad inner circle (smaller, more opaque white)
  (draw-circle tp-x
               tp-y
               (- thumbpad-radius 20)
               (color 255 255 255 180))

    # Draw action button (outer circle, translucent white)
    (draw-circle (get button-center 0)
                 (get button-center 1)
                 button-radius
                 (color 255 255 255 100))

    # Draw button inner circle (smaller, more opaque white)
    (draw-circle (get button-center 0)
                 (get button-center 1)
                 (- button-radius 15)
                 (color 255 255 255 100))
  

  )

