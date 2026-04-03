(in-package :cl-user)
(defpackage incita-notes.models.member
  (:use :cl :mito :sxql)
  (:import-from :incita-notes.models.user
                :users
                :user-members)
  (:import-from :incita-notes.models.group
                :groups
                :group-creator)
  (:export :members
           :member-user
           :member-group
           :member-admin
           
           :create-member
           :get-member
           :get-member-if-can-edit
           :get-member-if-can-see))
(in-package :incita-notes.models.member)


;;
;; Model

(deftable members ()
  ((user :col-type users
         :accessor member-user)
   (group :col-type groups
          :accessor member-group)
   (admin :col-type :boolean
          :accessor member-admin
          :initform nil))
  (:table-name "members"))


;;
;; Queries

(defun groups-with-no-members-query ()
  (select (:g.*)
    (from (:as :groups :g))
    (inner-join (:as 'members :m) :on
      (:= :m.group_id :g.id))
    (group-by :g.id)
    (having (:= (:count :m.id) 0))))


;;
;; Create

(defun create-member (user group &key (admin nil))
  "(user group :admin) -> #MEMBER"
  (create-dao 'members :user user :group group :admin admin))


;;
;; Get

(defun get-member (user group)
  "(user group) -> #MEMBER"
  (find-dao 'members :user user :group group))

(defgeneric get-member-if-can-edit (user page-or-block))

(defgeneric get-member-if-can-see (user page-or-block))


;;
;; Update


;;
;; Delete


;;
;; Definitions

(defmethod user-members ((user users))
  (select-dao 'members
    (where (:= :user user))))

(defmethod group-members ((group groups))
  (select-dao 'members
    (where (:= :group group))))


;;
;; Triggers

(defmethod insert-dao :after ((group groups))
  (create-member (group-creator group) group :admin t))

(defmethod delete-dao :after ((member members))
  (let ((empty-groups (select-by-sql 'groups (groups-with-no-members-query))))
    (mapcar #'delete-dao empty-groups)))

