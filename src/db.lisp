(in-package :cl-user)
(defpackage incita-notes.db
  (:use :cl)
  (:import-from :incita-notes.config
                :config)
  (:import-from :incita-notes.models.user
                :+user+)
  (:import-from :incita-notes.models.page
                :+user-page+)
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
  (mapcar #'ensure-table-exists '(+user+ +user-page+))
  (mapcar #'migrate-table '(+user+ +user-page+)))

(defun close-connection ()
  (disconnect-toplevel))
