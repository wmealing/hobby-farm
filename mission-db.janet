(def missions {:introduction
	       {:status :incomplete
                :title "Visit the farmer"
                :description "say hello to the farmer, hes probably in his house"
                :objectives
                [{:type :goto
		  :area :farmers-house}]
                :rewards
                [{:type :skill
                  :skill :bark
                  :amount 1}]}
	       :collect-eggs
               {:id :collect-eggs
                :title "Egg Hunt"
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
