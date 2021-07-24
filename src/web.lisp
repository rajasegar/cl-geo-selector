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
  (let* ((subregion (cl-ppcre:regex-replace-all " " (get-param "subregion" _parsed) "%20"))
	 (countries (cl-json:decode-json-from-string (dex:get (format nil "https://restcountries.herokuapp.com/api/v1/subregion/~a" subregion)))))
  (print subregion)
  (print countries)
    (render #P"_countries.html" (list :countries countries)))
  )

(defroute ("/country" :method :POST) (&key _parsed)
  (let* ((code (get-param "code" _parsed))
	(country (cl-json:decode-json-from-string (dex:get (format nil "https://restcountries.eu/rest/v2/alpha/~a" code)))))
  (print _parsed)
   (print country)

  (render #P"_country.html" (list :country country))))
;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))
