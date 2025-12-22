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

;; Main
(defroute "/" ()
  (if (gethash :id *session*)
      (redirect "/debug")
      (redirect "/login")))

;; Login
(defroute "/login" ()
  (login-page))

(defroute ("/login" :method :POST) (&key |email| |password|)
  (login |email| |password|))



(defroute "/debug" ()
  (let ((ses-id (gethash :id *session*))
        (ses-name (gethash :name *session*))
        (ses-email (gethash :email *session*))
        (ses-mode (gethash :dark-mode *session*)))
    (render "test.html" (list :id ses-id :name ses-name :email ses-email :darkmode ses-mode))))

;; dark mode
(defroute ("/dark-mode" :method :PUT) ()
  (setf (gethash :dark-mode *session*) (not (gethash :dark-mode *session*)))
  (render-json nil))

;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))
