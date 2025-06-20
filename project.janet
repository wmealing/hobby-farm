(declare-project
  :name "my-project"
  :description ""
  :dependencies ["https://github.com/janet-lang/jaylib"]
  :author ""
  :license ""
  :url ""
  :repo "")

(phony "server" []
  (os/shell "janet main.janet"))

(declare-executable
  :name "app"
  :entry "main.janet")

