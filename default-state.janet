(import /entity :as entity)

(defn init []
  (var game-state @{:boot-time :unset
		    :player :unset
                    :loaded true
                    :debug true
		    :camera :not-initiated
		    :items @[]
		    :debug-msg "hello world"
                    :mission {}})
  
  (var player {:image "dog.png"
	       :speed 500
	       :position @{:x 400 :y 0 :height 100 :width 100}
	       :last-good-position @{:x 0 :y 0}
	       :last-inputs @[]})

  (var entities
    @[(entity/make {:type :static
		    :solid true
		    :scale 0.25
		    :x 30 :y 30
		    :height 50 :width 50
		    :image "resources/images/doghouse.png" :action "cluck"})
      (entity/make {:type :static
		    :solid true
		    :scale 0.5
		    :x 460 :y -300
		    :height 200 :width 200
		    :image "resources/images/farmer-house.png" :action "cluck"})
      (entity/make {:name "farmer"
		    :type :static
		    :solid false
		    :scale 0.25
		    :x 100 :y 50
		    :height 40 :width 20
		    :has-mission true
		    :image "resources/images/farmer.png" :action "cluck"})
      (entity/make {:name "chicken house"
		    :type :static
		    :solid false
		    :scale 0.25
		    :x 250 :y 120
		    :height 60 :width 55
		    :has-mission false
		    :image "resources/images/chicken-coop.png" })])
  
  (merge game-state
	 {:entities entities}
	 {:player player}))
