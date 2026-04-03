(in-package :cl-user)
(defpackage incita-notes.view
  (:use :cl)
  (:import-from :incita-notes.config
                :*template-directory*)
  (:import-from :caveman2
                :*response*
                :*session*
                :response-headers)
  (:import-from :djula
                :add-template-directory
                :compile-template*
                :render-template*
                :*template-package*)
  (:import-from :datafly
                :encode-json)
  (:export :render
           :render-json))
(in-package :incita-notes.view)


(djula:add-template-directory *template-directory*)

(defparameter *template-registry* (make-hash-table :test 'equal))

(defun render (template-path &optional env)
  (let ((template (gethash template-path *template-registry*)))
    (unless template
      (setf template (djula:compile-template* (princ-to-string template-path)))
      (setf (gethash template-path *template-registry*) template))
    (apply #'djula:render-template*
           template nil
           env)))

(defun render-json (object)
  (setf (getf (response-headers *response*) :content-type) "application/json")
  (encode-json object))


;;
;; Execute package definition

(defpackage incita-notes.djula
  (:use :cl)
  (:import-from :incita-notes.config
                :config
                :development-p
                :production-p)
  (:import-from :caveman2
                :url-for))


(setf djula:*template-package* (find-package :incita-notes.djula))

