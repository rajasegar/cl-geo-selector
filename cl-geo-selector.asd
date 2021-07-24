(defsystem "cl-geo-selector"
  :version "0.1.0"
  :author "Rajasegar Chandran"
  :license ""
  :depends-on ("clack"
               "lack"
               "caveman2"
               "envy"
               "uiop"

               ;; HTML Template
               "djula"

               ;; for DB
               "datafly"
               "sxql"
	       ;; Ajax
	       "dexador"
	       ;; JSON
	       "cl-json")
  :components ((:module "src"
                :components
                ((:file "main" :depends-on ("config" "view" "db"))
                 (:file "web" :depends-on ("view"))
                 (:file "view" :depends-on ("config"))
                 (:file "db" :depends-on ("config"))
                 (:file "config"))))
  :description ""
  :in-order-to ((test-op (test-op "cl-geo-selector-test"))))
