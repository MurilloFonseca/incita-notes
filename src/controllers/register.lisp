(in-package :cl-user)
(defpackage incita-notes.controllers.register
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
                :set-session
                :valid-password-p)
  (:export :register-page
           :register-user))
(in-package :incita-notes.controllers.register)

(defun register-page ()
  (let ((id (get-session :id)))
    (if id (redirect "/page")
           (render #P"register/page.html"))))

(defun register-user (name email password)
  (let ((user (get-user-by-email email)))
    (if user (redirect "/login")
      (if (not (valid-password-p password)) (redirect "/register")
        (let ((new-user (create-user name email password)))
          (set-session :id (object-id new-user))
          (set-session :email (user-email new-user))
          (set-session :name (user-name new-user))
          (redirect "/page"))))))




