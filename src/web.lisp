(in-package :cl-user)
(defpackage cl-geo-selector.web
  (:use :cl
        :caveman2
        :cl-geo-selector.config
        :cl-geo-selector.view
        :cl-geo-selector.db
        :datafly
        :sxql)
  (:export :*web*))
(in-package :cl-geo-selector.web)

;; for @route annotation
(syntax:use-syntax :annot)

;;
;; Application

(defclass <web> (<app>) ())
(defvar *web* (make-instance '<web>))
(clear-routing-rules *web*)

(defun get-param (name parsed)
  (cdr (assoc name parsed :test #'string=)))

;;
;; Routing rules

(defroute "/" ()
  (render #P"index.html"))

(defroute ("/subregions" :method :POST) (&key _parsed)
  (let* ((region (get-param "region" _parsed))
	 (response (cl-json:decode-json-from-string (dex:get (format nil "https://restcountries.eu/rest/v2/region/~a?fields=subregion" region))))
	 (subregions  (remove-duplicates (mapcar #'(lambda (subregion)
		       (cdr (car subregion))) response) :test #'string=)))
  (print _parsed)
    (print subregions)
    
  (render #P"_sub-regions.html" (list :subregions subregions))))

(defroute ("/countries" :method :POST) (&key _parsed)
  (let* ((subregion (get-param "subregion" _parsed))
	 (countries (cl-json:decode-json-from-string (dex:get (format nil "https://restcountries.herokuapp.com/api/v1/subregion/~a" subregion)))))
  (print _parsed)
  (print countries)
  (render #P"_countries.html")))

(defroute ("/country" :method :POST) (&key _parsed)
  (print _parsed)
  (render #P"_country.html"))
;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))
