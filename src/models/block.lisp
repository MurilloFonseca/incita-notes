(in-package :cl-user)
(defpackage incita-notes.models.block
  (:use :cl :mito :sxql)
  (:import-from :incita-notes.models.page 
                :user_pages
                :group_pages
                :page-user
                :page-group
                :page-blocks)
  (:import-from :incita-notes.models.member
                :get-member-if-can-edit
                :get-member-if-can-see
                :member-admin)
  (:export :user_blocks
           :group_blocks
           :block-raw
           :block-compiled
           :block-position
           :block-page
           :block-permissions
           
           :get-last-block
           :get-blocks-if-can-see
           :create-block
           :update-block
           :delete-block))
(in-package :incita-notes.models.block)


;;
;; Model

;; Base
(defclass base-block ()
  ((raw-content :col-type :varchar
                :accessor block-raw
                :initform "")
   (compiled-content :col-type :varchar
                     :accessor block-compiled
                     :initform "")
   (position :col-type :int
             :accessor block-position))
  (:metaclass dao-table-mixin))


;; User
(deftable user_blocks (base-block)
  ((page :col-type user_pages
         :accessor block-page))
  (:table-name "user_blocks"))


;; Group
(deftable group_blocks (base-block)
  ((page :col-type group_pages
          :accessor block-page))
  (:table-name "group_blocks"))


;;
;; Accessors

(defgeneric block-permissions (block))


;;
;; Queries

(defun get-group-blocks-if-can-see-query (user-id page-id)
  (select ((:as :b.id :id)
           (:as :b.raw_content :raw-content)
           (:as :b.compiled_content :compiled-content)
           (:as :b.position :position)
           (:as :p.status :status))
    (from (:as 'group_blocks :b))
    (inner-join (:as 'permissions :p) :on
      (:and (:= :p.block_id :b.id) (:= :p.user_id user-id)))
    (inner-join (:as 'members :m) :on
      (:and (:= :m.user_id user-id) 
            (:= :m.group_id (select (:group_id) 
                              (from 'group_pages) 
                              (where (:= :id page-id))))))
    (where (:and (:= :b.page_id page-id) 
                      (:or (:= :m.admin "true") 
                           (:!= :p.status "hidden"))))
    (order-by (:asc :b.position))))

(defun get-user-blocks-if-can-see-query (user-id page-id)
  (select ((:as :b.id :id) 
           (:as :b.raw_content :raw-content) 
           (:as :b.compiled_content :compiled-content) 
           (:as :b.position :position))
    (from (:as 'user_blocks :b))
    (inner-join (:as 'user_pages :p) :on
      (:and (:= :p.user_id user-id) 
            (:= :p.id :b.page_id)))
    (where (:= :b.page_id page-id))
    (order-by (:asc :b.position))))


;;
;; Create

(defmethod create-block ((page user_pages) user &key (raw-content "") (compiled-content ""))
  "(page user :raw-content :compiled-content) -> #USER-BLOCK"
  (when (object= (page-user page) user)
    (let ((last-block (get-last-block page)))
      (create-dao 'user_blocks :page page 
                               :raw-content raw-content 
                               :compiled-content compiled-content 
                               :position (if last-block (1+ (block-position last-block)) 0)))))

(defmethod create-block ((page group_pages) user &key (raw-content "") (compiled-content ""))
  "(page user :raw-content :compiled-content) -> #GROUP-BLOCK"
  (let ((member (get-member-if-can-edit user page)))
    (when member
      (let ((last-block (get-last-block page)))
        (create-dao 'group_blocks :page page
                                  :raw-content raw-content
                                  :compiled-content compiled-content
                                  :position (if last-block (1+ (block-position last-block)) 0))))))


;;
;; Get

(defmethod get-last-block ((page user_pages))
  "(page) -> #USER-BLOCK"
  (car (select-dao 'user_blocks 
    (where (:= :page page))
    (order-by (:desc :position))
    (limit 1))))

(defmethod get-last-block ((page group_pages))
  "(page) -> #GROUP-BLOCK"
  (car (select-dao 'group_blocks 
    (where (:= :page page))
    (order-by (:desc :position))
    (limit 1))))

(defmethod get-blocks-if-can-see ((page user_pages) &key user)
  (retrieve-by-sql (get-user-blocks-if-can-see-query (object-id user) (object-id page))))

(defmethod get-blocks-if-can-see ((page group_pages) &key user)
  (retrieve-by-sql (get-group-blocks-if-can-see-query (object-id user) (object-id page))))


;;
;; Update

; TODO: change
(defun update-block (block-id &key raw-content compiled-content)
  "(block-id :raw-content :compiled-content) -> #USER-BLOCK"
  (let ((old-block (find-dao 'user_blocks :id block-id)))
    (when old-block
      (when raw-content (setf (block-raw old-block) raw-content))
      (when compiled-content (setf (block-compiled old-block) compiled-content))
      (save-dao old-block) old-block)))


;;
;; Delete

; TODO: change
(defun delete-block (block-id)
  "(block-id) -> NIL"
  (delete-by-values 'user_blocks :id block-id))


;;
;; Definitions

(defmethod page-blocks ((page user_pages))
  (select-dao 'user_blocks
    (where (:= :page page))
    (order-by (:asc :position))))

(defmethod user-pages ((page group_pages))
  (select-dao 'group_blocks
    (where (:= :page page))
    (order-by (:asc :position))))

(defmethod get-member-if-can-edit (user (block group_blocks))
  "(user block) -> #MEMBER"
  (car (select-dao 'members
    (inner-join (:as 'permissions :p) :on 
      (:and (:= :p.block_id (object-id block)) 
            (:= :p.user_id (object-id user))
            (:or (:= :p.status "editable") (:= :admin "true")))))))

(defmethod get-member-if-can-see (user (block group_blocks))
  "(user block) -> #MEMBER"
  (car (select-dao 'members
    (inner-join (:as 'permissions :p) :on 
      (:and (:= :p.block_id (object-id block)) 
            (:= :p.user_id (object-id user))
            (:or (:!= :p.status "hidden") (:= :admin "true")))))))


;;
;; Triggers

(defmethod delete-dao :before ((page user_pages))
  (let ((all-blocks (page-blocks page)))
    (mapcar #'delete-dao all-blocks)))

