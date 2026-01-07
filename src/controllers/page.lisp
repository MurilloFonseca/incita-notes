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
           :save-name
           :logout
           :add-page
           :id-page))
(in-package :incita-notes.controllers.page)

(defun default-page ()
  (let ((id (get-session :id))
        (page-id (get-session :page)))
    (when (not id) (redirect "/login"))
    (let ((params (list :username (get-session :name) :pages (parse-pages (user-pages id)))))
      (when page-id (push page-id params) (push :page_id params))
      (format t "~a~&" params)
      (render #P"page/page.html" params))))

(defun save-name (name)
  (format t "name: ~a~&" name)
  (let ((id (get-session :id)))
    (format t "id: ~a~&" id)
    (when id  
      (update-user id :name name)
      (set-session :name name)
      (format nil "~a" name))))

(defun logout ()
  (progn (set-session :id nil)
         (set-session :name nil)
         (set-session :email nil)
         (redirect "/login")))

(defun add-page (title)
  (let ((id (get-session :id)))
    (if (not id) (redirect "/login")
      (let ((page (create-user-page title id)))
        (render #P"components/group/group-page.html" (list :page_id (object-id page) :page_title title))))))

(defun id-page (page-id)
  (let ((id (get-session :id)))
    (when (not id) (redirect "/login"))
    (let ((page (get-page-by-id page-id)))
      (set-session :page page-id)
      (render #P"page/main.html" (list :page_title (page-title page))))))




