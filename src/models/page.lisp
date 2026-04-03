(in-package :cl-user)
(defpackage incita-notes.models.page
  (:use :cl :mito :sxql)
  (:import-from :incita-notes.models.user
                :users
                :user-pages)
  (:import-from :incita-notes.models.group
                :groups
                :group-pages
                :group-members)
  (:import-from :incita-notes.models.member
                :members
                :member-admin
                :get-member
                :get-member-if-can-edit
                :get-member-if-can-see)
  (:export :user_pages
           :group_pages
           :page-user
           :page-title
           :page-group
           :page-blocks
           :page-permissions
           
           :user-pages
           :create-page
           :get-user-page-by-id))
(in-package :incita-notes.models.page)


;;
;; Model

;; Base
(defclass base-page ()
  ((title :col-type (:varchar 128)
          :accessor page-title))
  (:metaclass dao-table-mixin))


;; User
(deftable user_pages (base-page)
  ((user :col-type users
         :accessor page-user))
  (:table-name "user_pages"))


;; Group
(deftable group_pages (base-page)
  ((group :col-type groups
          :accessor page-group))
  (:table-name "group_pages"))


;;
;; Accessors

(defgeneric page-blocks (page))

(defgeneric page-permissions (page))


;;
;; Create

(defmethod create-page (title (group null) &key) nil)

(defmethod create-page (title (user users) &key)
  "(title user) -> #USER-PAGE"
  (create-dao 'user_pages :title title :user user))

(defmethod create-page (title (group groups) &key user)
  "(title group :user) -> #GROUP-PAGE"
  (let ((member (get-member user group)))
    (when (and member (member-admin member))
      (create-dao 'group_pages :title title :group group))))


;;
;; Get

(defun get-user-page-by-id (user page-id)
  "(user page-id) -> #USER-PAGE"
  (find-dao 'user_pages :id page-id :user user))

(defun get-group-page-if-can-see (user page-id)
  ())


;;
;; Update


;; 
;; Delete


;;
;; Definitions

(defmethod user-pages ((user users))
  (select-dao 'user_pages
    (where (:= :user user))))

(defmethod group-pages ((group groups))
  (select-dao 'group_pages
    (where (:= :group group))))

(defmethod get-member-if-can-edit (user (page group_pages))
  "(user page) -> #MEMBER"
  (car (select-dao 'members
    (inner-join (:as 'permissions :p) :on 
      (:and (:= :p.page_id (object-id page)) 
            (:= :p.user_id (object-id user))
            (:or (:= :p.status "editable") (:= :admin "true")))))))

(defmethod get-member-if-can-see (user (page group_pages))
  "(user page) -> #MEMBER"
  (car (select-dao 'members
    (inner-join (:as 'permissions :p) :on 
      (:and (:= :p.page_id (object-id page)) 
            (:= :p.user_id (object-id user))
            (:or (:!= :p.status "hidden") (:= :admin "true")))))))


;;
;; Triggers

(defmethod delete-dao :before ((group groups))
  (let ((all-pages (group-pages group)))
    (mapcar #'delete-dao all-pages)))

(defmethod delete-dao :before ((group groups))
  (let ((all-members (group-members group)))
    (mapcar #'delete-dao all-members)))

