(in-package :cl-user)
(defpackage incita-notes.controllers.login
  (:use :cl
        :incita-notes.models.user)
  (:import-from :caveman2
                :*session*
                :redirect)
  (:import-from :incita-notes.view
                :render)
  (:import-from :mito
                :object-id)
  (:import-from :incita-notes.utils
                :get-session
                :set-session)
  (:export :make-login
           :login-page))
(in-package :incita-notes.controllers.login)

(defun login-page ()
  (let ((id (get-session :id)))
    (if id (redirect "/page")
           (render #P"login/page.html"))))

(defun make-login (email password)
  (multiple-value-bind (auth-p user) (auth-user email password)
    (if auth-p
      (progn (set-session :id (object-id user))
             (set-session :email (user-email user))
             (set-session :name (user-name user))
             (redirect "/page"))
      (redirect "/login"))))
