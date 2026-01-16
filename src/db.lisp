(in-package :cl-user)
(defpackage incita-notes.db
  (:use :cl)
  (:import-from :incita-notes.config
                :config)
  (:import-from :incita-notes.models.user
                :+user+)
  (:import-from :incita-notes.models.page
                :+user-page+)
  (:import-from :incita-notes.models.block
                :+user-block+)
  (:import-from :mito
                :connect-toplevel
                :disconnect-toplevel
                :ensure-table-exists
                :migrate-table)
  (:export :db-init
           :close-connection))
(in-package :incita-notes.db)

(defparameter *tables* '(+user+ +user-page+ +user-block+))

(defun db-init ()
  (apply #'connect-toplevel (config :database))
  (mapcar #'ensure-table-exists *tables*)
  (mapcar #'migrate-table *tables*))

(defun close-connection ()
  (disconnect-toplevel))
