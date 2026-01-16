(in-package :cl-user)
(defpackage incita-notes.controllers.page
  (:use :cl
        :incita-notes.models.user
        :incita-notes.models.page
        :incita-notes.models.block)
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
                :parse-pages
                :parse-blocks
                :parse-block
                :compile-md)
  (:export :default-page
           :save-name
           :logout
           :add-page
           :id-page
           :add-block
           :edit-content
           :auto-save
           :remove-block))
(in-package :incita-notes.controllers.page)

(defun default-page ()
  (let ((id (get-session :id))
        (page-id (get-session :page)))
    (when (not id) (redirect "/login"))
    (render #P"page/page.html" (list :page_id page-id :username (get-session :name) :pages (parse-pages (user-pages id))))))

(defun save-name (name)
  (let ((id (get-session :id)))
    (when id  
      (update-user id :name name)
      (set-session :name name)
      (format nil "~a" name))))

(defun logout ()
  (set-session :id nil)
  (set-session :name nil)
  (set-session :email nil)
  (redirect "/login"))

(defun add-page (title)
  (let ((id (get-session :id)))
    (if (not id) (redirect "/login")
      (let ((page (create-user-page title id)))
        (render #P"components/group/group-page.html" (list :page_id (object-id page) :page_title title))))))

(defun id-page (page-id)
  (let ((id (get-session :id)))
    (when (not id) (redirect "/login"))
    (let* ((page (get-page-by-id id page-id))
           (args (when page (list :page_id (if page page-id nil)
                                  :page_title (page-title page) 
                                  :page_blocks (parse-blocks (page-blocks page-id))))))
      (set-session :page (if page page-id nil))
      (render #P"page/main.html" args))))

(defun add-block (page-id)
  (let ((new-block (create-user-block page-id)))
    (render #P"page/block.html" (list :block new-block :edit_state "true"))))

(defun edit-content (block-id raw-content)
  (let* ((compiled-content (compile-md raw-content))
         (new-block (edit-block block-id :raw-content raw-content :compiled-content compiled-content)))
    (render #P"page/block.html" (list :block (parse-block new-block)))))

(defun auto-save (block-id raw-content)
  (let ((compiled-content (compile-md raw-content)))
    (edit-block block-id :raw-content raw-content :compiled-content compiled-content)
    compiled-content))

(defun remove-block (block-id)
  (delete-block block-id))


