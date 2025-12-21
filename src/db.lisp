(in-package :cl-user)
(defpackage incita-notes.db
  (:use :cl)
  (:import-from :incita-notes.config
                :config)
  (:import-from :incita-notes.model.user
                :+user+)
  (:import-from :mito
                :connect-toplevel
                :disconnect-toplevel
                :ensure-table-exists
                :migrate-table)
  (:export :db-init
           :close-connection))
(in-package :incita-notes.db)

(defun db-init ()
  (apply #'connect-toplevel (config :database))
  (mapcar #'ensure-table-exists '(+user+))
  (mapcar #'migrate-table '(+user+)))

(defun close-connection ()
  (disconnect-toplevel))
