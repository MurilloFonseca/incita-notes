(in-package :cl-user)
(defpackage incita-notes.config
  (:use :cl)
  (:import-from :envy
                :config-env-var
                :defconfig)
  (:import-from :cl-dotenv
                :load-env)
  (:export :config
           :*application-root*
           :*static-directory*
           :*template-directory*
           :appenv
           :developmentp
           :productionp
           :load-config))
(in-package :incita-notes.config)

(defparameter *application-root*   (asdf:system-source-directory :incita-notes))
(defparameter *static-directory*   (merge-pathnames #P"static/" *application-root*))
(defparameter *template-directory* (merge-pathnames #P"templates/" *application-root*))

(defvar *config* (make-hash-table :test #'equal))

(defun load-config (&optional (env-file ".env"))
  (when (probe-file env-file)
    (.env:load-env env-file))
  
  ;; Database
  (let ((db-name (get-env "DB_NAME" "null-name"))
        (db-host (get-env "DB_HOST" "null-host"))
        (db-port (parse-integer (get-env "DB_PORT" "0")))
        (db-username (get-env "DB_USERNAME" "null-user"))
        (db-password (get-env "DB_PASSWORD" "null-pw")))
    (setf (gethash :database *config*)
          `(:postgres 
             :database-name ,db-name
             :host ,db-host
             :port ,db-port
             :username ,db-username
             :password ,db-password)))

  ;; Server
  (setf (gethash :app-port *config*) (parse-integer (get-env "APP_PORT" "0")))
  (setf (gethash :app-server *config*) (get-env "APP_SERVER" "null-srv"))
  (setf (gethash :app-env *config*) (get-env "APP_ENV" "null-env"))
  
  ;; JWT Secret
  (setf (gethash :secret *config*) 
        (ironclad:ascii-string-to-byte-array (get-env "JWT_SECRET" "placeholder"))))

(defun get-env (key &optional default)
  (or (uiop:getenv key) default))

(defun config (key)
  (gethash key *config*))

(defun developmentp ()
  (string= (config :app-env) "development"))

(defun productionp ()
  (string= (config :app-env) "production"))
