(in-package :cl-user)
(defpackage incita-notes.model.user
  (:use :cl :mito)
  (:import-from :mito-auth
                :has-secure-password
                :auth)
  (:export :+user+
           :user-name
           :user-email
           :user-id
           
           :create-user
           :auth-user))
(in-package :incita-notes.model.user)

(deftable +user+ (has-secure-password)
  ((name :col-type (:varchar 100)
         :accessor user-name)
   (email :col-type (:varchar 254)
          :accessor user-email))
  (:unique-keys email))

(defun create-user (&key name email password)
  (create-dao '+user+ :name name :email email :password password))

(defun auth-user (email password)
  (let ((user (find-dao '+user+ :email email)))
    (if user (values (auth user password) user)
             (values nil nil))))


