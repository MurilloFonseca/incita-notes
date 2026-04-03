(in-package :cl-user)
(defpackage incita-notes.db
  (:use :cl)
  (:import-from :incita-notes.config
                :config
                :*database-directory*)
  (:import-from :incita-notes.models.user
                :users)
  (:import-from :incita-notes.models.page
                :user_pages
                :group_pages)
  (:import-from :incita-notes.models.block
                :user_blocks
                :group_blocks)
  (:import-from :incita-notes.models.group
                :groups)
  (:import-from :incita-notes.models.member
                :members)
  (:import-from :incita-notes.models.permission
                :permissions)
  (:import-from :mito
                :connect-toplevel
                :disconnect-toplevel
                :generate-migrations)
  (:export :open-connection
           :migrate
           :close-connection
           :migrate))
(in-package :incita-notes.db)

(defun migrate ()
  (generate-migrations *database-directory*)
  (mito:migrate *database-directory*))

(defun open-connection ()
  (apply #'connect-toplevel (config :database)))

(defun close-connection ()
  (disconnect-toplevel))
