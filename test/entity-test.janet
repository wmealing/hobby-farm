(use testament) 
(import /items :as items)
(import /entity :as entity)

# silly default.

(deftest entity-defaults
  (var game-state @{:entities @[ {:a 1 } {:b 2} ]})
  (is (== (entity/fetch-all game-state) @[{:a 1} {:b 2}])))
  
(deftest entity-add
  (var game-state @{:entities @[{:a 1}]})
  (var new-game-state (entity/add game-state {:b 2}))
  (is (== (entity/fetch-all new-game-state) @[{:a 1} {:b 2}])))

# make sure that the game state is still nil, aka not modified.

(deftest entity-remove
  (var game-state @{:entities @[ {:a 1} {:b 2} ]})
  (var remove-game-state (entity/remove-entity game-state {:a 1}))
  (is (== (entity/fetch-all remove-game-state) @[{:b 2}])))

(run-tests!)
