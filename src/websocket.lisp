(in-package :cl-user)
(defpackage incita-notes.websocket
  (:use :cl)
  (:import-from :bordeaux-threads
                :make-lock
                :with-lock-held)
  (:import-from :websocket-driver
                :make-server
                :on
                :send
                :start-connection)
              
  (:export :websocket-handler
           :websocket-middleware))
(in-package :incita-notes.websocket)


;;
;; Connections

(defvar *connections* nil)
(defvar *connections-lock* (make-lock *connections*))

(defun add-connection (ws &key user)
  (with-lock-held (*connections-lock*)
    (push (list :ws ws :user user) *connections*)))

(defun remove-connection (ws)
  (with-lock-held (*connections-lock*)
    (setf *connections* 
          (remove-if (lambda (conn) 
                        (eq (getf conn :ws) ws)) 
                     *connections*))))


(defun get-user (env)
  (let ((session (getf env :lack.session)))
    (when session
      (gethash :user session))))


;;
;; Handlers

(defun websocket-handler (env)
  (let ((ws (make-server env))
        (user (get-user env)))
    
    (on :open ws
      (lambda ()
        (add-connection ws :user user)
        (send ws (format nil "<div id=\"ws-test\"><p>connection opened!<br>total connections: ~a</p></div>" (length *connections*)))
        (format t "[WS] Connection Opened! total connections: ~a~%~%~%" (length *connections*))))
  
    (on :message ws
      (lambda (msg)
        (format t "~%message received: ~a~%" msg)
        (send ws (format nil "<div id=\"answer\">Message received!<br>answering: ~a</div>" msg))))


    (on :close ws
      (lambda (&key code reason)
        (declare (ignore code reason))
        (remove-connection ws)))
    
    (lambda (responder)
      (declare (ignore responder))
      (start-connection ws))))


;;
;; Middleware

(defun websocket-middleware (app)
  (lambda (env)
    (if (string= (getf env :request-uri) "/ws")
        (websocket-handler env)
        (funcall app env))))

