(defn Array2Vec [arr]
  {:x (get arr 0)
   :y (get arr 1)})



(defn Vector2Subtract [vec1 vec2]
  {:x (- (vec1 :x) (vec2 :x))
   :y (- (vec1 :y) (vec2 :y))})

(defn Vector2Add [vec1 vec2]
  {:x (+ (vec1 :x) (vec2 :x))
   :y (+ (vec1 :y) (vec2 :y)) }
  )

(defn Vector2Length [vec]
      (math/sqrt (+ (* (vec :x) (vec :x) )
	            (* (vec :y) (vec :y)))))

(defn Vector2Scale [vec scale]
  {:x (* (vec :x)  scale)
   :y (* (vec :y)  scale)})
