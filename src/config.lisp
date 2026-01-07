(in-package :cl-user)
(defpackage incita-notes.config
  (:use :cl)
  (:import-from :cl-dotenv
                :load-env)
  (:export :*application-root*
           :*static-directory*
           :*template-directory*
           :load-config
           :config
           :development-p
           :production-p))
(in-package :incita-notes.config)

(defparameter *application-root* (asdf:system-source-directory :incita-notes))
(defparameter *static-directory* (merge-pathnames #P"static/" *application-root*))
(defparameter *template-directory* (merge-pathnames #P"templates/" *application-root*))

(defvar *config* (make-hash-table :test #'equal))

(defun load-config (&optional (env-file ".env"))
  (when (probe-file env-file)
    (.env:load-env env-file))

  ;; Database
  (let ((db-name (get-env "DB_NAME" "incita-notes"))
        (db-host (get-env "DB_HOST" "localhost"))
        (db-port (parse-integer (get-env "DB_PORT" "5432")))
        (db-username (get-env "DB_USERNAME" "postgres"))
        (db-password (get-env "DB_PASSWORD" "")))
    (setf (gethash :database *config*) 
          `(:postgres 
            :database-name ,db-name 
            :host ,db-host 
            :port ,db-port 
            :username ,db-username 
            :password ,db-password)))

  ;; Server
  (setf (gethash :app-host *config*) (get-env "APP_HOST" "localhost"))
  (setf (gethash :app-port *config*) (parse-integer (get-env "APP_PORT" "5000")))
  (setf (gethash :app-server *config*) (alexandria:make-keyword (string-upcase (get-env "APP_SERVER" "null-srv"))))
  (setf (gethash :app-env *config*) (get-env "APP_ENV" "null-env")))

(defun get-env (key &optional default)
  (let ((var (or (uiop:getenv key) default)))
    (string-trim '(#\space #\newline #\return #\linefeed) var)))

(defun config (key)
  (gethash key *config*))

(defun development-p ()
  (string= (config :app-env) "development"))

(defun production-p ()
  (string= (config :app-env) "production"))
