(use testament) 
(import /items :as items)


# before any tests are run
(deftest gamestate-defaults
  (var game-state @{ :items @[]})
  (is (== (items/fetch-all game-state) @[])))


(deftest gamestate-basics
  (var game-state @{ :items @[]})
  (var new-game-state (items/add game-state {:a 2}))
  # make sure that the game state is still nil, aka not modified.
  (is (== (items/fetch-all game-state) @[]))
  # new game state should have only the added item
  (== (items/fetch-all new-game-state) {:a 2}))

(deftest gamestate-remove-test
  # remove-test-1
  (var game-state @{ :items @[{:a 2} {:b 3}]})
  (var remove-game-state (items/remove game-state {:a 2}))
  (== (items/fetch-all remove-game-state) @[{:b 3}]))

# remove test 2
(var game-state @{ :items @[{:a 1} {:b 2}]})
(var modified-game-state (items/remove game-state {:a 1}))

(deftest thing
(is (deep= (items/fetch-all modified-game-state) @[{:b 2}])))


# remove the item



(run-tests!)
