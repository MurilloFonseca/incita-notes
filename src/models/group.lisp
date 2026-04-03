(in-package :cl-user)
(defpackage incita-notes.models.group
  (:use :cl :mito :sxql)
  (:import-from :incita-notes.models.user
                :users)
  (:export :groups
           :group-name
           :group-creator
           :group-members
           :group-pages
           
           :create-group
           :get-groups-with-pages
           :get-group-members
           :get-group-if-member
           :get-group-if-admin
           :update-group))
(in-package :incita-notes.models.group)


;;
;; Model

(deftable groups ()
  ((name :col-type (:varchar 128)
         :accessor group-name)
   (creator :col-type users
            :accessor group-creator))
  (:table-name "groups"))


;;
;; Accessors

(defgeneric group-members (group))

(defgeneric group-pages (group))


;;
;; Queries

(defun get-groups-with-pages-query (user-id)
  (select ((:as :g.id :id) 
           (:as :g.name :name) 
           (:as (:array_agg (:raw "'(:id \"' || p.id || '\" :title \"' || p.title || '\" :status \"' || permissions.status || '\")'")) :pages))
    (from (:as 'groups :g))
    (inner-join (:as 'members :m) :on
      (:and (:= :m.user_id user-id) (:= :m.group_id :g.id))) 
    (left-join (:as 'group_pages :p) :on
      (:= :p.group_id :g.id)) 
    (inner-join 'permissions :on
      (:and (:= :permissions.user_id user-id) (:= :permissions.page_id :p.id))) 
    (where
      (:or (:= :m.admin "true") (:!= :permissions.status "hidden"))) 
    (group-by :g.id)))


;;
;; Create

(defun create-group (name user)
  "(name user) -> #GROUP"
  (create-dao 'groups :name name :creator user))


;;
;; Get

(defun get-groups-with-pages (user)
  "(user) -> ((:id :name :pages=(:id :title)))"
  (let* ((user-id (object-id user))
         (result (retrieve-by-sql (get-groups-with-pages-query user-id))))
    (mapcar (lambda (group)
              (setf (getf group :pages) 
                    (map 'list #'read-from-string (getf group :pages)))
              group) 
            result)))

(defun get-group-members (group)
  "(group) -> (#USER)"
  (select-dao 'users
    (inner-join (:as 'members :m) :on
      (:and (:= :m.user_id :users.id) 
            (:= :m.group_id (object-id group))))))

(defun get-group-if-member (group-id user)
  (car (select-dao 'groups
          (inner-join (:as 'members :m) :on
            (:and (:= :m.group_id :groups.id) (:= :m.user_id (object-id user))))
          (where (:= :groups.id group-id)))))

(defun get-group-if-admin (group-id user)
  (car (select-dao 'groups
          (inner-join (:as 'members :m) :on
            (:and (:= :m.group_id :groups.id) (:= :m.user_id (object-id user)) (:= :m.admin "true")))
          (where (:= :groups.id group-id)))))


;;
;; Update

(defun update-group (group &key name)
  (when name (setf (group-name group) name))
  (save-dao group) group)


;;
;; Delete

