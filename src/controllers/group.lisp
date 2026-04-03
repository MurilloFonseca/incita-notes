(in-package :cl-user)
(defpackage incita-notes.controllers.group
  (:use :cl
        :incita-notes.controllers.middlewares
        :incita-notes.models.group)
  (:import-from :incita-notes.view
                :render)
  (:import-from :mito
                :object-id)
  (:export))
(in-package incita-notes.controllers.group)


;;
;; Create

(defun create-group-controller (name)
  (authenticated user
    (let ((group (create-group name user)))
      (render #P"components/group/index.html" (list :group-id (object-id group) :group-name name)))))


;;
;; Update

(defun update-group-controller (name group-id)
  (authenticated user
    (let ((group (get-group-if-admin group-id user)))
      (when group
        (update-group group :name name)))))


