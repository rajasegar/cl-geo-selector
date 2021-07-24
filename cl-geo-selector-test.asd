(defsystem "cl-geo-selector-test"
  :defsystem-depends-on ("prove-asdf")
  :author "Rajasegar Chandran"
  :license ""
  :depends-on ("cl-geo-selector"
               "prove")
  :components ((:module "tests"
                :components
                ((:test-file "cl-geo-selector"))))
  :description "Test system for cl-geo-selector"
  :perform (test-op (op c) (symbol-call :prove-asdf :run-test-system c)))
