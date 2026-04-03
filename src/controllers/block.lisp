(in-package :cl-user)
(defpackage incita-notes.controllers.block
  (:use :cl
        :incita-notes.controllers.middlewares
        :incita-notes.models.page
        :incita-notes.models.block)
  (:import-from :incita-notes.utils
                :set-session)
  (:import-from :incita-notes.view
                :render)
  (:import-from :mito
                :object-id)
  (:export :get-user-blocks-controller))
(in-package :incita-notes.controllers.block)


;;
;; Get

(defun get-user-blocks-controller (page-id)
  (authenticated user
    (let ((page (get-user-page-by-id user page-id)))
      (when page
        (set-session :page page)
        (render #P"page/main.html" (list :page-id (object-id page) 
                                         :current-page (list :title (page-title page) 
                                                             :blocks (get-blocks-if-can-see page :user user))))))))

(defun get-group-blocks-controller (page-id)
  (authenticated user
    (let ((page (get-group-page-by-id user page-id)))
      (when page
        (set-session :page page)
        (render #P"page/main.html" (list :page-id (object-id page) 
                                         :current-page (list :title (page-title page) 
                                                             :blocks (get-blocks-if-can-see page :user user))))))))


;;
;; Create


;;
;; Update


;;
;; Delete

