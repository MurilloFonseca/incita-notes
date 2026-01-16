(in-package :cl-user)
(defpackage incita-notes.models.block
  (:use :cl :mito :sxql)
  (:import-from :incita-notes.models.page 
                :+user-page+)
  (:export :+user-block+
           :block-raw
           :block-compiled
           :block-position
           :block-page
           
           :get-last-block
           :create-user-block
           :page-blocks
           :edit-block
           :delete-block))
(in-package :incita-notes.models.block)

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

(deftable +user-block+ (base-block)
  ((page :col-type +user-page+
         :accessor block-page)))

(defun get-last-block (page-id)
  (car (select-dao '+user-block+ 
    (where (:= :page-id page-id))
    (order-by (:desc :position))
    (limit 1))))

(defun create-user-block (page-id &key (raw-content "") (compiled-content ""))
  (let* ((last-block (get-last-block page-id))
         (new-block (make-instance '+user-block+ 
                      :page-id page-id 
                      :position (if last-block (1+ (block-position last-block)) 0) 
                      :raw-content raw-content
                      :compiled-content compiled-content)))
    (insert-dao new-block)))

(defun page-blocks (page-id)
  (select-dao '+user-block+ 
    (where (:= :page-id page-id))
    (order-by (:asc :position))))

(defun edit-block (block-id &key raw-content compiled-content)
  (let ((old-block (find-dao '+user-block+ :id block-id)))
    (when old-block
      (when raw-content (setf (block-raw old-block) raw-content))
      (when compiled-content (setf (block-compiled old-block) compiled-content))
      (save-dao old-block) old-block)))

(defun delete-block (block-id)
  (delete-by-values '+user-block+ :id block-id))

