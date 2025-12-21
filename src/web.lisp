(in-package :cl-user)
(defpackage incita-notes.web
  (:use :cl
        :caveman2
        :incita-notes.view
        :incita-notes.controller.login)
  (:import-from :incita-notes.config
                :*template-directory*)
  (:export :*web*))
(in-package :incita-notes.web)

;;
;; Application

(defclass <web> (<app>) ())
(defvar *web* (make-instance '<web>))
(clear-routing-rules *web*)

;;
;; Routing rules

(defroute "/" ()
  (if (gethash :id *session*)
      (redirect "/debug")
      (redirect "/login")))


(defroute ("/login" :method :POST) (&key |email| |password|)
  (login |email| |password|))


(defroute "/login" ()
  (render #P"login/page.html"))

(defroute "/debug" ()
  (let ((test (gethash :id *session*)))
    (format nil "~a" test)))


;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))
