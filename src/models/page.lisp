(in-package :cl-user)
(defpackage incita-notes.models.page
  (:use :cl :mito :sxql)
  (:import-from :incita-notes.models.user
                :+user+)
  (:export :+user-page+
           :page-user
           :page-title
           
           :user-pages))
(in-package :incita-notes.models.page)

(defclass page ()
  ((title :col-type (:varchar 60)
          :accessor page-title))
  (:metaclass dao-table-mixin))

(deftable +user-page+ (page)
  ((user :col-type +user+
         :accessor page-user)))

(defun user-pages (user-id)
  (select-dao '+user-page+ 
    (where (:= :user-id user-id))))


