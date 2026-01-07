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
  (:import-from :cl-ppcre
                :scan)
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

(defun valid-password-p (password)
  (and (>= (length password) 8)
       (scan "[A-Z]" password)
       (scan "[a-z]"  password)
       (scan "[0-9]" password)
       (scan "[~`!@#$%^&*()\\[\\]|\\\\:;\"'<>,.?/]" password)))





