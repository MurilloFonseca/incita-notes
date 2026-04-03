(in-package :cl-user)
(defpackage incita-notes
  (:use :cl)
  (:import-from :incita-notes.config
                :config
                :load-config
                :development-p)
  (:import-from :clack
                :clackup)
  (:import-from :incita-notes.db
                :open-connection
                :close-connection
                :migrate)
  (:export :start
           :stop))
(in-package :incita-notes)

(defvar *appfile-path*
  (asdf:system-relative-pathname :incita-notes #P"app.lisp"))

(defvar *handler* nil)

(defun start (&rest args &key migrate server port debug &allow-other-keys)
  (declare (ignore args server port debug))

  ;; Server already running
  (when *handler*
    (restart-case (error "Server is already running.")
      (restart-server ()
        :report "Restart the server"
        (stop))))

  ;; Start new server
  (progn
    (load-config)
    (open-connection)
    (when migrate (migrate))
    (setf *handler*
          (apply #'clackup *appfile-path* (list :host (config :app-host) :port (config :app-port) :server (config :app-server) :debug (development-p))))))


(defun stop ()
  (prog1
    (clack:stop *handler*)
    (close-connection)
    (setf *handler* nil)))
