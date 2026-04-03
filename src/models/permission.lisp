(in-package :cl-user)
(defpackage incita-notes.models.permission
  (:use :cl :mito :sxql)
  (:import-from :incita-notes.models.user
                :users
                :user-permissions
                :user-members
                :user-pages)
  (:import-from :incita-notes.models.group
                :get-group-members)
  (:import-from :incita-notes.models.member
                :members
                :member-group
                :member-user)
  (:import-from :incita-notes.models.block
                :group_blocks
                :block-page
                :block-permissions)
  (:import-from :incita-notes.models.page
                :group_pages
                :page-group
                :page-permissions
                :page-blocks)
  (:export :permissions
           :permission-user
           :permission-block
           :permission-page
           :permission-statis
           
           :create-permission))
(in-package :incita-notes.models.permission)


;;
;; Model

(deftable permissions ()
  ((user :col-type users
         :accessor permission-user)
   (block :col-type (or group_blocks :null)
          :accessor permission-block)
   (page :col-type (or group_pages :null)
         :accessor permission-page)
   (status :col-type (:varchar 8)
           :accessor permission-status))
  (:table-name "permissions"))


;;
;; Queries

(defun pages-with-blocks-query (group-id)
  (select ((:as :p.id :page) 
           (:as (:array_agg :b.id) :blocks))
    (from (:as 'group_pages :p))
    (left-join (:as 'group_blocks :b) :on
      (:= :b.page_id :p.id))
    (where (:= :p.group_id group-id))
    (group-by :p.id)))


;;
;; Create

(defmethod create-permission (user (page group_pages) &key (status "readonly"))
  "(user page :status) -> #PERMISSION"
  (create-dao 'permissions :user user :page page :status status))

(defmethod create-permission (user (block group_blocks) &key (status "readonly"))
  "(user block :status) -> #PERMISSION"
  (create-dao 'permissions :user user :block block :status status))


;;
;; Definitions

(defmethod user-permissions ((user users))
  (select-dao 'permissions
    (where (:= :user user))))

(defmethod page-permissions ((page group_pages))
  (select-dao 'permissions
    (where (:= :page page))))

(defmethod block-permissions ((block group_blocks))
  (select-dao 'permissions
    (where (:= :block block))))


;;
;; Triggers

;; Insert
(defmethod insert-dao :after ((member members))
  (let ((user (member-user member))
        (pages (retrieve-by-sql (pages-with-blocks-query (object-id (member-group member))))))

    (mapcar (lambda (page)
              (create-dao 'permissions :page-id (getf page :page) :user user :status "readonly")
              (map 'vector 
                (lambda (block)
                  (create-dao 'permissions :block-id block :user user :status "readonly")) 
                (getf page :blocks))) 
            pages)))

(defmethod insert-dao :after ((page group_pages))
  (let ((users (get-group-members (page-group page))))
    (mapcar (lambda (user) (create-permission user page)) users)))

(defmethod insert-dao :after ((block group_blocks))
  (let ((users (get-group-members (page-group (block-page block)))))
    (mapcar (lambda (user) (create-permission user block)) users)))


;; Delete
(defmethod delete-dao :before ((user users))
  (let ((all-members (user-members user))
        (all-pages (user-pages user))
        (all-permissions (user-permissions user)))
    (mapcar #'delete-dao all-members)
    (mapcar #'delete-dao all-pages)
    (mapcar #'delete-dao all-permissions)))

(defmethod delete-dao :before ((page group_pages))
  (let ((all-blocks (page-blocks page))
        (all-permissions (page-permissions page)))
    (mapcar #'delete-dao all-blocks)
    (mapcar #'delete-dao all-permissions)))

(defmethod delete-dao :before ((block group_blocks))
  (let ((all-permissions (block-permissions block)))
    (mapcar #'delete-dao all-permissions)))

