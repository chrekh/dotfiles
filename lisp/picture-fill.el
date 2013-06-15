(defun picture-fill-internal (ch bckgr)
  (let ((col (current-column))
	(rnd (random 4))
	(start (point)))
    (sit-for 0)
    
    (delete-char 1)
    (insert-char ch 1)

;*************   DOWN   ******************************
    (forward-line 1)
    (and (move-to-column col)
	 (= (or (char-after (point)) 0) bckgr)
	 (picture-fill-internal ch bckgr))
    (forward-line -1)
    
;*************   LEFT   ******************************
    (and (move-to-column (1+ col))
	 (= (or (char-after (point)) 0) bckgr)
	 (picture-fill-internal ch bckgr))

;*************   RIGHT  ******************************
    (and (> col 0)
	 (move-to-column (1- col))
	 (= (or (char-after (point)) 0) bckgr)
	 (picture-fill-internal ch bckgr))
    
;*************   UP     ******************************
    (if (not (save-excursion (beginning-of-line) (bobp)))
	(progn
	  (forward-line -1)
	  (and (move-to-column col)
	       (= (or (char-after (point)) 0) bckgr)
	       (picture-fill-internal ch bckgr))
	  (forward-line 1)))
   
    (goto-char start)))

(defun picture-fill (ch)
  (interactive "cChar to fill with: ")
  (let ((depth max-lisp-eval-depth)
	(specpdl-size max-specpdl-size))
    (if (= ch (char-after (point)))
	(error "cant fill with %c on %c's" ch ch)
      (unwind-protect
	  (progn
	    (if (< max-specpdl-size 10000)
		(setq max-specpdl-size 10000))
	    (if (< max-lisp-eval-depth 10000)
		(setq max-lisp-eval-depth 10000))
	    (untabify (point-min) (point-max))
	    (picture-fill-internal ch (char-after (point))))
	(setq max-lisp-eval-depth depth)
	(setq max-specpdl-size specpdl-size)))))
