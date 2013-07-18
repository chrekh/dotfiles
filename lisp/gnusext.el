; gus as maillist-reader
(setq gnus-select-method
      '(nntp "news.gmane.org")
      )

;If you're using Gnus, I'd suggest switching the HTML renderer to w3m or
;something, putting the Gwene groups in their own topic, and then edit
;the topic parameters to the following:
;
(setq mm-inline-text-html-with-images t
      mm-discouraged-alternatives nil
      mm-w3m-safe-url-regexp nil
      ;gnus-treat-wash-html '("gwene")
      gnus-treat-wash-html nil
      gnus-article-wash-function 'w3m
      w3m-goto-article-function 'browse-url
      browse-url-browser-function 'browse-url-netscape
      browse-url-netscape-program "firefox"
      )
      
(setq gnus-face-9 'font-lock-warning-face)
(setq gnus-face-10 'shadow)
(setq gnus-group-line-format "%M%S%p%P%5y %L: %(%g%)%l\n"
      gnus-summary-line-format "%U%R%5i %(%10{%B%}%[ %-20,20n %]%) %s\n")

(when window-system
  (setq gnus-sum-thread-tree-indent "  "
        gnus-sum-thread-tree-root "● "
        gnus-sum-thread-tree-false-root "o "
        gnus-sum-thread-tree-single-indent "o "
        gnus-sum-thread-tree-leaf-with-other "├─► "
        gnus-sum-thread-tree-vertical "│"
        gnus-sum-thread-tree-single-leaf "╰─► "))

(setq
 gnus-treat-display-smileys nil
 gnus-use-adaptive-scoring t
 gnus-score-interactive-default-score 300
 gnus-score-expiry-days 180
 gnus-use-cache t
 gnus-score-find-score-files-function 'gnus-score-find-hierarchical
 )

(defun gnus-score-find-hierarchical (group)
  "Return list of score files for GROUP.
This includes the score file for the group and all its parents."
  (let* ((prefix (gnus-group-real-prefix group))
	 (all (list nil))
	 (group (gnus-group-real-name group))
	 (start 0))
    (while (string-match "\\." group (1+ start))
      (setq start (match-beginning 0))
      (push (substring group 0 start) all))
    (push group all)
    (setq all
	  (nconc
	   (list (gnus-score-file-name (car all) gnus-adaptive-file-suffix))
	   (mapcar 'gnus-score-file-name all)))
    (if (equal prefix "")
	all
      (nconc all
	     (mapcar
	      (lambda (file)
		(nnheader-translate-file-chars
		 (concat (file-name-directory file) prefix
			 (file-name-nondirectory file))))
	      all)))))


(gnus-add-configuration
 '(article
   (frame 1.0
	  (vertical 1.0
		    (summary 0.25 point)
		    (article 1.0))
	  )))

; from subject message-id references xref lines chars date  followup
(setq gnus-default-adaptive-score-alist
      '((gnus-kill-file-mark)
	(gnus-ancient-mark)
	(gnus-low-score-mark)
	(gnus-unread-mark)
	(gnus-read-mark    (from  5) (subject   15) (followup  9) (message-id  5) (references  5) )
;	(gnus-ticked-mark  (from  7) (subject   9)  (followup  3) (message-id  2) (references  3) )
;	(gnus-dormant-mark (from  6) (subject   6)  (followup  4) (message-id  1) (references  2) )
	(gnus-catchup-mark (from -1) (subject  -1)  (followup -1) (message-id -1) (references -1) )
	(gnus-killed-mark  (from -5) (subject  -5)  (followup -3) (message-id -1) (references -1) )
	(gnus-del-mark     (from -5) (subject  -5)  (followup -3) (message-id -1) (references -1) )
		       ))
 
(setq
 nnmail-expiry-wait 60
 gnus-level-default-subscribed 3
 gnus-strict-mime nil
 gnus-use-trees t
 gnus-use-long-file-name t
 gnus-thread-sort-functions '(
			      gnus-thread-sort-by-date
			      gnus-thread-sort-by-number
			      gnus-thread-sort-by-subject
			      gnus-thread-sort-by-score
			      )
 gnus-visual '( highlight )
 gnus-use-nocem nil
 gnus-group-sort-function '(
			    gnus-group-sort-by-rank
;			    gnus-group-sort-by-alphabet
			    )
)

(defun gnus-group-score-increase (&optional n)
  "Increase the score of the current group by one.
If given numerical prefix, increase the N next groups."
  (interactive "P")
  (let ((groups (gnus-group-process-prefix n))
        group)
    (while groups
      (setq group (car groups)
            groups (cdr groups))
      (gnus-group-add-score group 1))))

(defun gnus-group-score-decrease (&optional n)
  "Decrease the score of the current group by one.
If given numerical prefix, decrease the N next groups."
  (interactive "P")
  (let ((groups (gnus-group-process-prefix n))
        group)
    (while groups
      (setq group (car groups)
            groups (cdr groups))
      (gnus-group-add-score group -1))))

(setq
 gnus-nntp-server nil
 gnus-interactive-exit nil
 gnus-auto-select-first nil
 gnus-interactive-catchup nil
 gnus-use-full-window t
 gnus-thread-ignore-subject t
 gnus-default-article-saver 'gnus-summary-save-in-mail
 gnus-author-copy "~/News/OUTPOST"
 gnus-user-full-name "Christer Ekholm"
 gnus-large-newsgroup 1000
 gnus-thread-indent-level 2
 ;; Site dependent variables.
 gnus-use-generic-path t
 gnus-use-generic-from t
 gnus-news-system 'Cnews
 gnus-subscribe-newsgroup-method (function gnus-subscribe-randomly)
 gnus-startup-file "~/.gnusrc"
)

(add-hook 'gnus-started-hook
	  '(lambda ()
	     (define-key gnus-summary-mode-map "n" 'gnus-summary-next-article)
	     (define-key gnus-summary-mode-map "p" 'gnus-summary-prev-article)
	     (define-key gnus-group-score-map "i" 'gnus-group-score-increase)
	     (define-key gnus-group-score-map "l" 'gnus-group-score-decrease)
	     ))

(setq gnus-select-group-hook
      '(lambda ()
         (cond ((string-match "^gwene"
                              gnus-newsgroup-name)
                (setq gnus-treat-wash-html t))
               (t
                (setq gnus-treat-wash-html nil))
               )))

(add-hook 'gnus-exit-group-hook
	  '(lambda ()
	     (gnus-summary-mark-below 0 "E")
	     ))

  
(defun gnus-summary-mark-below (score mark)
  "Mark articles with score below SCORE with MARK."
  (interactive "P\ncMark: ")
  (setq score (if score
		  (prefix-numeric-value score)
		(or gnus-summary-default-score 0)))
  (save-excursion
    (set-buffer gnus-summary-buffer)
    (goto-char (point-min))
    (while (and (progn
		  (when (< (gnus-summary-article-score) score)
		    (gnus-summary-mark-article nil mark))
		  t)
		(gnus-summary-find-next)))))
