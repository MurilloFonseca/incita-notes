(in-package :cl-user)
(defpackage incita-notes.models.user
  (:use :cl :mito)
  (:import-from :mito-auth
                :has-secure-password
                :auth
                :password)
  (:export :+user+
           :user-name
           :user-email
           :user-id
           
           :create-user
           :auth-user
           :get-user-by-id
           :get-user-by-email
           :update-user))
(in-package :incita-notes.models.user)

(deftable +user+ (has-secure-password)
  ((name :col-type (:varchar 100)
         :accessor user-name)
   (email :col-type (:varchar 254)
          :accessor user-email))
  (:unique-keys email))

(defun create-user (name email password)
  (create-dao '+user+ :name name :email email :password password))

(defun auth-user (email password)
  (let ((user (find-dao '+user+ :email email)))
    (if user (values (auth user password) user)
             (values nil nil))))

(defun get-user-by-id (id)
  (find-dao '+user+ :id id))

(defun get-user-by-email (email)
  (find-dao '+user+ :email email))

(defun update-user (id &key name email pw)
  (let ((user (find-dao `+user+ :id id)))
    (when user
      (when name (setf (user-name user) name))
      (when email (setf (user-email user) email))
      (when pw (setf (password user) pw))
      (save-dao user))))

