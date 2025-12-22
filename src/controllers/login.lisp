(in-package :cl-user)
(defpackage incita-notes.controller.login
  (:use :cl
        :incita-notes.model.user)
  (:import-from :caveman2
                :*session*
                :redirect)
  (:import-from :incita-notes.view
                :render)
  (:import-from :mito
                :object-id)
  (:export :make-login
           :login-page))
(in-package :incita-notes.controller.login)

(defun login-page ()
  (let ((id (gethash :id *session*)))
    (if id (redirect "/debug")
           (render #P"login/page.html"))))

(defun make-login (email password)
  (multiple-value-bind (auth-p user) (auth-user email password)
    (if auth-p
      (progn (setf (gethash :id *session*) (object-id user))
             (setf (gethash :email *session*) (user-email user))
             (setf (gethash :name *session*) (user-name user))
             (redirect "/debug")) ;; TODO: Change later
      (redirect "/login"))))
