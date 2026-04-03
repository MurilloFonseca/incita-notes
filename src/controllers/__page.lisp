(in-package :cl-user)
(defpackage incita-notes.controllers.page++
  (:use :cl
        :incita-notes.models.user
        :incita-notes.models.page
        :incita-notes.models.block
        :incita-notes.models.group
        :sxql)
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
           :add-page
           :id-page
           :add-block
           :edit-content
           :auto-save
           :remove-block))
(in-package :incita-notes.controllers.page++)

;;
;; Page

; (defun default-page ()
;   (let ((user (get-session :user))
;         (page-id (get-session :page)))
;     (when (not user) (redirect "/login"))
;     (render #P"page/index.html" (list :page_id page-id 
;                                       :username (user-name user) 
;                                       :pages (parse-pages (user-pages user)) ;;TODO: change user-pages
;                                       :groups (get-groups-with-pages user))))) 




; (defun save-name (name)
;   (let ((user (get-session :user)))
;     (when user
;       (let ((new-user (update-user user :name name)))
;         (set-session :user new-user)
;         (format nil "~a" name)))))





; (defun add-page (title)
;   (let ((user (get-session :user)))
;     (if (not user) (redirect "/login")
;       (let ((page (create-page title user)))
;         (render #P"components/group/group-page.html" (list :page_id (object-id page) :page_title title))))))





(defun id-page (page-id)
  (let ((user (get-session :user)))
    (when (not user) (redirect "/login"))
    (let* ((page (get-page-by-id user page-id))
           (args (when page (list :page_id (if page page-id nil)
                                  :page_title (page-title page) 
                                  :page_blocks (parse-blocks (page-blocks page-id))))))
      (set-session :page (if page page-id nil))
      (render #P"page/main.html" args))))





(defun add-block (page)
  (let* ((user (get-session :user))
         (new-block (create-block page user)))
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


