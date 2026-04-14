(def global-message-queue @[])

(defn all-tasks []
  global-message-queue)

(defn push [value]
  (array/push global-message-queue value))

(defn pop []
  (array/pop global-message-queue))

(defn next []
  (when (> (length global-message-queue) 0)
    (var x (get global-message-queue 0))
    (array/remove global-message-queue 0)
    x
    ))

(defn peek-next []
  (when (> (length global-message-queue) 0)
    (get global-message-queue 0))
    )


(defn reset []
  (array/clear global-message-queue))


(defn debug []
  (print "TYPE: " (type global-message-queue))
  (pp (all-tasks)))
