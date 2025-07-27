

(declare-project
  :name "my-project"
  :description ""
  :dependencies ["https://github.com/janet-lang/jaylib"
		 "https://github.com/pyrmont/testament"
		 "https://github.com/janet-lang/spork.git"
		{:url "https://github.com/ianthehenry/pat.git"
		 :tag "v2.0.1"} ]
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

