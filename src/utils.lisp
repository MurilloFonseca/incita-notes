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
  (:import-from :incita-notes.models.block
                :block-raw
                :block-compiled
                :block-position)
  (:import-from :3bmd
                :parse-string-and-print-to-stream
                :*smart-quotes*)
  (:import-from :3bmd-math
                :*math*)
  (:import-from :3bmd-code-blocks
                :*code-blocks*)
  (:import-from :3bmd-definition-lists
                :*definition-lists*)
  (:import-from :3bmd-tables
                :*tables*)
  (:import-from :3bmd-youtube
                :*youtube-embeds*)
  (:export :get-session
           :set-session
           :parse-pages
           :parse-block
           :parse-blocks
           :compile-md))
(in-package :incita-notes.utils)

(defun get-session (key)
  (gethash key *session*))

(defun set-session (key new-value)
  (setf (gethash key *session*) new-value))

(defun parse-page (page)
  (list :id (object-id page) :title (page-title page) :user (page-user page)))

(defun parse-block (b)
  (list :id (object-id b) :raw_content (block-raw b) :compiled_content (block-compiled b) :position (block-position b)))

(defun parse-pages (pages)
  (mapcar #'parse-page pages))

(defun parse-blocks (blocks)
  (mapcar #'parse-block blocks))

(defun valid-password-p (password)
  (and (>= (length password) 8)
       (scan "[A-Z]" password)
       (scan "[a-z]"  password)
       (scan "[0-9]" password)
       (scan "[~`!@#$%^&*()\\[\\]|\\\\:;\"'<>,.?/]" password)))

(defun compile-md (raw)
  (let ((*smart-quotes* t)
        (*math* t)
        (*code-blocks* t)
        (*definition-lists* t)
        (*tables* t)
        (*youtube-embeds* t))
    (with-output-to-string (s)
      (parse-string-and-print-to-stream raw s))))

