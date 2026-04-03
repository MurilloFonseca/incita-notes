(in-package :cl-user)
(defpackage incita-notes.controllers.middlewares
  (:use :cl)
  (:import-from :incita-notes.utils
                :get-session)
  (:import-from :caveman2
                :redirect)
  (:export :authenticated
           :unauthenticated
           :user))
(in-package :incita-notes.controllers.middlewares)


(defmacro authenticated (user &body body)
  `(let ((,user (get-session :user)))
      (if (not user) (redirect "/login")
        (progn ,@body))))

(defmacro unauthenticated (&body body)
  `(if (get-session :user) (redirect "/page")
      (progn ,@body)))

