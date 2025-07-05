

(declare-project
  :name "my-project"
  :description ""
  :dependencies ["https://github.com/janet-lang/jaylib"
		{:url "https://github.com/janet-lang/spork.git"
                  :tag "641b27238e073c5f5f963ec16c79b51643d3e66f"}]
  :dev-dependencies ["https://github.com/janet-lang/spork"]
  :author ""
  :license ""
  :url ""
  :repo ""
  )

(phony "server" []
  (os/shell "janet main.janet"))

(declare-executable
  :name "app"
  :entry "main.janet")

