;;; ...  -*- lexical-binding: t -*-

(add-hook 'calendar-load-hook
	  (lambda ()
	    (copy-face font-lock-constant-face 'calendar-iso-week-face)
	    (set-face-attribute 'calendar-iso-week-face nil)
	    (setq calendar-intermonth-spacing 7
		  calendar-left-margin 7
		  calendar-intermonth-text
		  '(propertize
		    (format "%2d"
			    (car
			     (calendar-iso-from-absolute
			      (calendar-absolute-from-gregorian (list month day year)))))
		    'font-lock-face 'calendar-iso-week-face))))
