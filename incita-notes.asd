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
               "sxql"
               
               ;; markdown parser
               "3bmd"
               "3bmd-ext-math"
               "3bmd-ext-code-blocks"
               "3bmd-ext-definition-lists"
               "3bmd-ext-tables"
               "3bmd-youtube"
               
               ;; websocket
               "websocket-driver")
  :components ((:module "src"
                :components
                ((:file "main" :depends-on ("config" "view" "db" "models"))
                 (:file "web" :depends-on ("view" "controllers"))
                 (:file "view" :depends-on ("config"))
                 (:file "db" :depends-on ("config" "models"))
                 (:file "config")
                 (:file "extensions")
                 (:file "utils" :depends-on ("models" "extensions"))
                 (:module "models"
                  :components ((:file "user")
                               (:file "page")
                               (:file "block")))
                 (:module "controllers" :depends-on ("models" "utils")
                  :components ((:file "login")
                               (:file "register")
                               (:file "page"))))))
  :description "Aplicativo de notas")
