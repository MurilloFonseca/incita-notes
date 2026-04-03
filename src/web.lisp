(in-package :cl-user)
(defpackage incita-notes.web
  (:use :cl
        :caveman2
        :incita-notes.controllers.user
        :incita-notes.controllers.group
        :incita-notes.controllers.member
        :incita-notes.controllers.page
        :incita-notes.controllers.block)
  (:import-from :incita-notes.config
                :*template-directory*)
  (:import-from :incita-notes.view
                :render-json
                :render)
  (:import-from :incita-notes.utils
                :get-session)

  (:import-from :mito
                :object-id)
  (:import-from :incita-notes.models.user
                :user-name
                :user-email)

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
  (if (get-session :user)
      (redirect "/page")
      (redirect "/login")))


;; Page
(defroute "/login" ()
  (login-page))

(defroute "/register" ()
  (register-page))

(defroute "/page" ()
  (page-page))


;; Login
(defroute ("/login" :method :POST) (&key |email| |password|)
  (format t "~%Reached route: '/login' with params: ~%email: ~a~%password: ~a~%" |email| |password|)
  (login |email| |password|))

(defroute ("/logout" :method :POST) ()
  (logout))


;; User
(defroute ("/user" :method :POST) (&key |name| |email| |password|)
  (create-user-controller |name| |email| |password|))

(defroute ("/user" :method :PUT) (&key |name|)
  (update-user-controller |name|))

(defroute ("/user" :method :DELETE) ()
  (delete-user-controller))


;; Page
(defroute ("/page" :method :POST) (&key |title|)
  (create-user-page-controller |title|))

(defroute ("/group/:group-id/page" :method :POST) (&key group-id |title|)
  (create-group-page-controller |title| group-id))


;; Block
(defroute "/page/:id/blocks" (&key id)
  (get-user-blocks-controller id))

(defroute "/group/:group-id/page/:id/blocks" (&key id group-id)
  (format nil "WIP- id: ~a group-id: ~a" id group-id))




#| TODO: Refactor
(defroute ("/page/:page-id/add-block" :method :POST) (&key page-id)
  (add-block page-id))

(defroute ("/block-content/:id" :method :PUT) (&key id |content|)
  (edit-content id |content|))

(defroute ("/auto-save/:id" :method :PUT) (&key id |content|)
  (auto-save id |content|))

(defroute ("/delete-block/:id" :method :DELETE) (&key id)
  (remove-block id))
|#


;;
;; Other

;; TODO: Remove later
(defroute "/debug" ()
  (let ((user (gethash :user *session*))
        (ses-page (gethash :page *session*)))
    (render "debug.html" (list :id (when user (object-id user) )
                               :name (when user (user-name user) )
                               :email (when user (user-email user) )
                               :page-id ses-page))))


;;
;; Error pages

;; 404
(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))
