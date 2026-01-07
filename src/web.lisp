(in-package :cl-user)
(defpackage incita-notes.web
  (:use :cl
        :caveman2
        :incita-notes.controllers.login
        :incita-notes.controllers.register
        :incita-notes.controllers.page)
  (:import-from :incita-notes.config
                :*template-directory*)
  (:import-from :incita-notes.view
                :render-json
                :render)
  (:import-from :incita-notes.utils
                 :get-session)
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
  (if (get-session :id)
      (redirect "/page")
      (redirect "/login")))

;; Login
(defroute "/login" ()
  (login-page))

(defroute ("/login" :method :POST) (&key |email| |password|)
  (make-login |email| |password|))



;; Register
(defroute "/register" ()
  (register-page))

(defroute ("/register" :method :POST) (&key |name| |email| |password|)
  (register-user |name| |email| |password|))


;; Page
(defroute "/page" ()
  (default-page))

(defroute "/page/:id" (&key id)
  (id-page id))

(defroute ("/update-name" :method :PUT) (&key |name|)
  (format t "|name|: ~a~&" |name|)
  (save-name |name|))

(defroute ("/logout" :method :POST) ()
  (logout))

(defroute ("/add-page" :method :POST) (&key |title|)
  (add-page |title|))





;;
;; Other

;; TODO: Remove later
(defroute "/debug" ()
  (let ((ses-id (gethash :id *session*))
        (ses-name (gethash :name *session*))
        (ses-email (gethash :email *session*))
        (ses-page (gethash :page *session*)))
    (render "debug.html" (list :id ses-id :name ses-name :email ses-email :page_id ses-page))))



;;
;; Error pages

;; 404
(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))
