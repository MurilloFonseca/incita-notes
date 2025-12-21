(in-package :cl-user)
(defpackage incita-notes
  (:use :cl)
  (:import-from :incita-notes.config
                :config
                :load-config)
  (:import-from :clack
                :clackup)
  (:import-from :incita-notes.db
                :db-init
                :close-connection)
  (:import-from :incita-notes.model.user
                :+user+)
  (:export :start
           :stop))
(in-package :incita-notes)

(defvar *appfile-path*
  (asdf:system-relative-pathname :incita-notes #P"app.lisp"))

(defvar *handler* nil)

(defun start (&rest args &key server port debug &allow-other-keys)
  (declare (ignore server port debug))

  ;; Server already running
  (when *handler*
    (restart-case (error "Server is already running.")
      (restart-server ()
        :report "Restart the server"
        (stop))))

  ;; Start new server
  (progn
    (load-config)
    (db-init)
    (setf *handler*
          (apply #'clackup *appfile-path* args))))

(defun stop ()
  (prog1
    (clack:stop *handler*)
    (close-connection)
    (setf *handler* nil)))
