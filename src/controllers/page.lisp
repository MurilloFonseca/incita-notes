(in-package :cl-user)
(defpackage incita-notes.controllers.page
  (:use :cl
        :incita-notes.models.user
        :incita-notes.models.page)
  (:import-from :caveman2
                :*session*
                :redirect)
  (:import-from :incita-notes.view
                :render
                :render-json)
  (:import-from :mito
                :object-id)
  (:import-from :incita-notes.utils
                :get-session
                :set-session
                :parse-pages)
  (:export :default-page
           :save-name))
(in-package :incita-notes.controllers.page)

(defun default-page ()
  (let ((id (get-session :id)))
    (when (not id) (redirect "/login"))
    (render #P"page/page.html" (list :username (get-session :name) :pages (parse-pages (user-pages id))))))

(defun save-name (name)
  (let ((id (get-session :id)))
    (when id  
      (update-user id :name name)
      (set-session :name name)
      (render-json nil))))


