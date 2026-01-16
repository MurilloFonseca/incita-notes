(in-package :3bmd-grammar)
(defrule tickbox (and #\[ (or #\x #\X #\space) #\]) (:text t))

(defrule bullet-with-tick (and (! horizontal-rule) nonindent-space
                               (or #\+ #\* #\-)
                               (+ space-char)
                               (+ tickbox)
                               (+ space-char))
  (:destructure (hr ns bullet sp tick sp2)
    (declare (ignore hr ns bullet sp sp2))
    (list :bullet-with-tick :checked (or (string= (car tick) "[x]") (string= (car tick) "[X]")))))

(defrule bullet-list (and (& (or bullet-with-tick bullet)) 
                          (or list-tight list-loose))
  (:destructure (a b)
    (declare (ignore a))
    (cons :bullet-list b)))

(defrule list-item-tight (and (or bullet-with-tick bullet enumerator)
                              list-block
                              (* (and (! blank-line)
                                      list-continuation-block))
                              (! list-continuation-block))
  (:destructure (b block cont e)
    (declare (ignore e))
    (let ((tick-info (when (listp b) (list :checked (caddr b)))))
      (list* :list-item
             (when tick-info tick-info)
             (mapcan (lambda (a)
                        (parse-doc (text a)))
                     (split-sequence:split-sequence
                        :split (cons block (mapcan 'second cont))
                        :remove-empty-subseqs t))))))

(defrule list-item (and (or bullet-with-tick bullet enumerator)
                        list-block
                        (* list-continuation-block))
  (:destructure (b block cont)
    (let ((tick-info (when (listp b) (list :checked (caddr b)))))
      (list* :list-item
             (when tick-info tick-info)
             (mapcan (lambda (a)
                        (parse-doc (text a)))
                     (split-sequence:split-sequence
                        :split (append (cons block (mapcan 'identity cont))
                                       (list "

"))
                        :remove-empty-subseqs t))))))

(in-package :3bmd)



(defmethod print-tagged-element ((tag (eql :list-item)) stream rest)
  (let ((has-tick (caar rest))
        (paragraph-p (equal :paragraph (caadr rest))))
    (padded (1 stream 2)
      (format stream (if has-tick "<li class=\"task-list-item\">~%" "<li>~%")))

    (when paragraph-p (format stream "<p>"))

    (when has-tick
      (if (cadar rest)
        (format stream "<input type=\"checkbox\" class=\"task-list-item-checkbox\" checked disabled>~%")
        (format stream "<input type=\"checkbox\" class=\"task-list-item-checkbox\" disabled>~%")))

    (print-element (cons :plain (cdadr rest)) stream)

    (when paragraph-p (format stream "</p>"))

    (format stream "</li>")
    (setf *padding* 0)))

