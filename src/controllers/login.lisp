(in-package :cl-user)
(defpackage incita-notes.controller.login
  (:use :cl
        :incita-notes.model.user)
  (:import-from :caveman2
                :*session*
                :redirect)
  (:import-from :mito
                :object-id)
  (:export :login))
(in-package :incita-notes.controller.login)

(defun login (email password)
  (multiple-value-bind (auth-p user) (auth-user email password)
    (if auth-p
      (progn (setf (gethash :id *session*) (object-id user))
             (setf (gethash :email *session*) (user-email user))
             (setf (gethash :name *session*) (user-name user))
             (redirect "/debug")) ;; TODO: Change later
      (redirect "/login"))))
