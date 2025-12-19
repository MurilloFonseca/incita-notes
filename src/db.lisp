(in-package :cl-user)
(defpackage incita-notes.db
  (:use :cl)
  (:import-from :incita-notes.config
                :config)
  (:import-from :datafly
                :*connection*)
  (:import-from :cl-dbi
                :connect-cached)
  (:export :connection-settings
           :db
           :with-connection))
(in-package :incita-notes.db)

(defun connection-settings ()
  (config :database))

(defun db ()
  (apply #'connect-cached (connection-settings)))

(defmacro with-connection (conn &body body)
  `(let ((*connection* ,conn))
     ,@body))
