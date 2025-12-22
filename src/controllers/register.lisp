(in-package :cl-user)
(defpackage incita-notes.controller.register
  (:use :cl
        :incita-notes.model.user)
  (:import-from :caveman2
                :*session*
                :redirect)
  (:import-from :incita-notes.view
                :render)
  (:import-from :mito
                :object-id)
  (:export :register-page
           :register-user))
(in-package :incita-notes.controller.register)

(defun register-page ()
  (let ((id (gethash :id *session*)))
    (if id (redirect "/debug")
           (render #P"register/page.html"))))

(defun register-user (name email password)
  (let ((user (get-user-by-email email)))
    (if user (redirect "/login")
      (let ((new-user (create-user name email password)))
        (setf (gethash :id *session*) (object-id new-user))
        (setf (gethash :email *session*) (user-email new-user))
        (setf (gethash :name *session*) (user-name new-user))
        (redirect "/debug")))))



