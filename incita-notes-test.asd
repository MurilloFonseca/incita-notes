(asdf:defsystem "incita-notes-test"
  :defsystem-depends-on ("prove-asdf")
  :author "Murillo Perez da Fonseca"
  :license ""
  :depends-on ("incita-notes"
               "prove")
  :components ((:module "tests"
                :components
                ((:test-file "incita-notes"))))
  :description "Test system for incita-notes"
  :perform (test-op (op c) (symbol-call :prove-asdf :run-test-system c)))
