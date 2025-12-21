(asdf:defsystem "incita-notes"
  :version "0.1.0"
  :author "Murillo Perez da Fonseca"
  :license ""
  :depends-on ("clack"
               "lack"
               "caveman2"
               "cl-ppcre"
               "uiop"

               ;; HTML Template
               "djula"

               ;; .env
               "cl-dotenv"

               ;; for DB
               "mito"
               "mito-auth"
               "datafly"
               "sxql")
  :components ((:module "src"
                :components
                ((:file "main" :depends-on ("config" "view" "db" "models"))
                 (:file "web" :depends-on ("view" "controllers"))
                 (:file "view" :depends-on ("config"))
                 (:file "db" :depends-on ("config" "models"))
                 (:file "config")
                 (:module "models"
                  :components ((:file "user")))
                 (:module "controllers" :depends-on ("models")
                  :components ((:file "login"))))))
  :description "Aplicativo de notas")
