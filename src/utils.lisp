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
                :user_blocks
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
  "(key) -> t"
  (gethash key *session*))

(defun set-session (key new-value)
  "(key new-value) -> new-value"
  (setf (gethash key *session*) new-value))

(defun parse-page (page)
  "(page) -> (:id :title :user)"
  (list :id (object-id page) :title (page-title page) :user (page-user page)))

(defun parse-block (b)
  "(b) -> (:id :raw-content :compiled-content :position)"
  (list :id (object-id b) :raw-content (block-raw b) :compiled-content (block-compiled b) :position (block-position b)))

(defun parse-pages (pages)
  "(pages) -> ((:id :title :user))"
  (mapcar #'parse-page pages))

(defun parse-blocks (blocks)
  "(blocks) -> ((:id :raw-content :compiled-content :position))"
  (mapcar #'parse-block blocks))

(defun valid-password-p (password)
  "(password) -> boolean"
  (and (>= (length password) 8)
       (scan "[A-Z]" password)
       (scan "[a-z]"  password)
       (scan "[0-9]" password)
       (scan "[~`!@#$%^&*()\\[\\]|\\\\:;\"'<>,.?/]" password)))

(defun compile-md (raw)
  "(raw) -> string"
  (let ((*smart-quotes* t)
        (*math* t)
        (*code-blocks* t)
        (*definition-lists* t)
        (*tables* t)
        (*youtube-embeds* t))
    (with-output-to-string (s)
      (parse-string-and-print-to-stream raw s))))

