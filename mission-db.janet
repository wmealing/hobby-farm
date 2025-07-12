(import ./mission-display :as mission-display :fresh true)


(defn start-game [event-type event-data game-state]
  (print "STARTING GAME")

  (if (= (event-data :name) "start-location")
    (merge game-state {:mission :introduction :debug-msg "Walk to the farmer"})
    game-state
    ))

(defn start-game-complete [game-state]
  (print "STARTING GAME COMPLETE")
  game-state
  )

(defn introduction-mission [event-type event-data game-state]

  (print "INTRODUCTION MISSION")
  (pp event-data)

  (if (= (event-data :name) "farmer-location")
    (do
      (merge game-state  {:mission :none :debug-msg "MISSION-COMPLETE"}))
    game-state))

(defn introduction-complete [game-state]
  (print "INTRODUCTION COMPLETE")
  game-state)

(def missions {:start {:title "placeholder"
		       :objectives start-game
		       :on-completion start-game-complete }
	       :introduction
	       {:title "Visit the farmer"
                :description "say hello to the farmer, hes probably in his house"
                :objectives introduction-mission
		:on-completion introduction-complete }
	       :collect-eggs
               {:title "Egg Hunt"
                :description "Collect 5 eggs for the farmer's breakfast."
                :status :inactive # :inactive, :active, :completed, :failed
                :objectives
                [{:type :collect
                  :item :egg
                  :current-amount 0
                  :required-amount 5}]
                :rewards
                [{:type :item
                  :item :egg-carton
                  :amount 1}]}
               :find-dog
               {:id :find-dog
                :title "Find the Lost Dog"
                :description "The farmer's dog is missing. Find him near the old rocks."
                :status :inactive
                :objectives
                [{:type :goto
                  :area :rocky-area # An identifier for a location on your map
                  :completed false}]
                :rewards
                [{:type :reputation
                  :points 10}]}
	       })
