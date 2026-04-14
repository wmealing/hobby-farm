(import ./location :as location)
(import /items :as items)
(import pat :as pat)
(import /tasks :as tasks)

(use ./utils)


(defn notify [event-type event-data game-state]
  
  (pat/match [ event-type event-data ]
	     [:sprite-collision {:name "farmer"} ] (do
						     (when (<= 1 (items/fetch-by-count game-state :name "egg"))
						       (print "more than 1 eggs, handing them over to farmer")
 						       (tasks/push {:action :remove :item "egg"  })
  						       (tasks/push {:action :add    :item "money" :value 1}))
						     (print "HELLO FARMER"))
	     [:sprite-collision _ ]                (print "=> HIT SOMETHING ELSE" )
	     [:area  {:name "start-location"} ]    (print (length (tasks/all-tasks)))
	     (ev/sleep 0)
	     ))

	     



  
  




