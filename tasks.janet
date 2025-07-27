(var message-queue @[])

(defn all-tasks []
  message-queue)

(defn push [value]
  (array/push message-queue value))

(defn pop []
  (array/pop message-queue))

(defn next []

  (if (> (length message-queue)  0)
    (do
      (var a (get message-queue 0))
      (set message-queue  (slice message-queue 1 ))
      a)
    nil
    )
  )

(defn reset []
  (set message-queue []))


(defn debug []
  (print "TYPE: " (type message-queue))
  (pp (all-tasks)))
