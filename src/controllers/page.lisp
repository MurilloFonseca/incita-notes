(in-package :cl-user)
(defpackage incita-notes.controllers.page
  (:use :cl
        :incita-notes.controllers.middlewares
        :incita-notes.models.page
        :incita-notes.models.user
        :incita-notes.models.group
        :incita-notes.models.block)
  (:import-from :incita-notes.utils
                :parse-pages
                :get-session)
  (:import-from :incita-notes.view
                :render)
  (:import-from :mito
                :object-id)
  (:export :page-page
           :create-user-page-controller
           :create-group-page-controller))
(in-package :incita-notes.controllers.page)


;;
;; Page

(defun page-page ()
  (authenticated user
    (let ((page (get-session :page)))
      (render #P"page/index.html" (list :page-id (when page (object-id page))
                                        :username (user-name user)
                                        :pages (parse-pages (user-pages user)) 
                                        :groups (get-groups-with-pages user)
                                        :current-page (when page (list :title (page-title page)
                                                                       :blocks (get-blocks-if-can-see page :user user))))))))


;;
;; Create

(defun create-user-page-controller (title)
  (authenticated user
    (let ((page (create-page title user)))
      (render #P"components/group/group-page.html" (list :page-id (object-id page) :page-title title)))))

(defun create-group-page-controller (title group-id)
  (authenticated user
    (let* ((group (get-group-if-member group-id user))
           (page (create-page title group :user user)))
      (when page (render #P"components/group/group-page.html" (list :page-id (object-id page) :page-title title))))))


;;
;; Update

