(in-package :cl-user)
(defpackage incita-notes.models.user
  (:use :cl :mito :sxql)
  (:import-from :mito-auth
                :has-secure-password
                :auth
                :password)
  (:export :users
           :user-name
           :user-email
           :user-members
           :user-pages
           :user-permissions
           
           :create-user
           :get-user
           :update-user
           :delete-user
           :auth-user))
(in-package :incita-notes.models.user)


;;
;; Model

(deftable users (has-secure-password)
  ((name :col-type (:varchar 128)
         :accessor user-name)
   (email :col-type (:varchar 256)
          :accessor user-email))
  (:unique-keys email)
  (:table-name "users"))


;;
;; Accessors

(defgeneric user-members (user))

(defgeneric user-pages (user))

(defgeneric user-permissions (user))


;;
;; Create

(defun create-user (name email password)
  "(name email password) -> #USER"
  (create-dao 'users :name name :email email :password password))


;;
;; Get

(defun get-user (flag value)
  "(flag value) -> #USER"
  (find-dao 'users flag value))


;;
;; Update

(defun update-user (user &key name email pw)
  "(user :name :email :pw) -> #USER"
  (when name (setf (user-name user) name))
  (when email (setf (user-email user) email))
  (when pw (setf (password user) pw))
  (save-dao user) user)


;;
;; Delete

(defun delete-user (user)
  "(user) -> NIL"
  (delete-dao user))


;;
;; Other

;; Auth
(defun auth-user (email password)
  "(email password) -> boolean #USER"
  (format t "~%reached model-function: 'auth-user' with args:~%email: ~a~%password: ~a~%~%" email password)
  (let ((user (get-user :email email)))
    (format t "~%Found user: ~a~%" user)
    (if user (values (auth user password) user)
             (values nil nil))))

