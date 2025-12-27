(in-package :cl-user)
(defpackage incita-notes.utils
  (:use :cl)
  (:import-from :caveman2
                :*session*)
  (:import-from :mito
                :object-id)
  (:import-from :incita-notes.models.page
                :page-title
                :page-user)
  (:export :get-session
           :set-session
           :parse-pages))
(in-package :incita-notes.utils)

(defun get-session (key)
  (gethash key *session*))

(defun set-session (key new-value)
  (setf (gethash key *session*) new-value))

(defun parse-page (page)
  (list :id (object-id page) :title (page-title page) :user (page-user page)))

(defun parse-pages (pages)
  (mapcar #'parse-page pages))







