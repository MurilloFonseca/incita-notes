(in-package :cl-user)
(defpackage incita-notes.controllers.user
  (:use :cl
        :incita-notes.controllers.middlewares
        :incita-notes.models.user)
  (:import-from :caveman2
                :redirect)
  (:import-from :incita-notes.view
                :render)
  (:import-from :incita-notes.utils
                :valid-password-p
                :set-session)
  (:export :login-page
           :register-page
           
           :create-user-controller
           :update-user-controller
           :delete-user-controller
           
           :login
           :logout))
(in-package incita-notes.controllers.user)


;;
;; Page

(defun login-page ()
  (unauthenticated
    (render #P"login/index.html")))

(defun register-page ()
  (unauthenticated
    (render #P"register/index.html")))


;;
;; Create

(defun create-user-controller (name email password)
  (let ((user (get-user :email email)))
    (cond (user (redirect "/login"))
          ((not (valid-password-p password)) (redirect "/login"))
          (t (let ((new-user (create-user name email password)))
                (set-session :user new-user)
                (redirect "/page"))))))


;;
;; Update

(defun update-user-controller (name)
  (authenticated user
    (let ((new-user (update-user user :name name)))
      (set-session :user new-user)
      (format nil "~a" name))))


;;
;; Delete

(defun delete-user-controller ()
  (authenticated user
    (delete-user user)))


;;
;; Auth

(defun login (email password)
  (format t "~%Reached controller login!~%")
  (multiple-value-bind (auth-p user) (auth-user email password)
    (format t "~%Auth results: ~a ~%" auth-p)
    (if (not auth-p) (redirect "/login")
      (progn (set-session :user user)
             (redirect "/page")))))

(defun logout ()
  (set-session :user nil)
  (redirect "/login"))

