(in-package :cl-user)
(defpackage incita-notes.controllers.member
  (:use :cl
        :incita-notes.controllers.middlewares
        :incita-notes.models.member)
  (:import-from :incita-notes.view
                :render)
  (:export))
(in-package incita-notes.controllers.member)