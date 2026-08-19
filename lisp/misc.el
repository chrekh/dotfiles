;;; ...  -*- lexical-binding: t -*-

(defun alist-substitute-value (alist old new)
  "Return a new alist in which all (key . OLD) is replaced with (key . NEW)"
  (mapcar (lambda (pair)
            (if (eq old (cdr pair))
		(cons (car pair) new)
	      pair))
	  alist))

		   
(defun testfont ()
  (interactive)
  (let (from to)
    (save-excursion
      (beginning-of-line)
      (setq from (point))
      (end-of-line)
      (set-frame-font (buffer-substring from (point))))))

(defun string-substitute-char (string char1 char2)
  "In STRING, every occurance of CHAR1 is replaced with CHAR2."
  (let ((pos 0)
	(len (length string)))
    (while (< pos len)
      (if (= (aref string pos) char1)
	  (aset string pos char2))
      (setq pos (1+ pos)))))
	
(defun append-signature-long ()
  "Appends ~/.../signature last in current buffer."
  (interactive)
  (newline)
  (insert-file "~/.../signature"))

(defun append-signature-short ()
  "Appends my name last in current buffer."
  (interactive)
  (end-of-line)
  (newline)
  (insert "-- \n Christer"))
  
(defun save-buffers-kill-emacs-non-interactive ()
  "Save all buffers witout asking and then exit Emacs."
  (interactive)
  (save-buffers-kill-emacs t))

(defun save-buffers-suspend ()
  "Interactively save all buffers, and then suspend Emacs."
  (interactive)
  (save-some-buffers)
  (suspend-emacs))

(defun move-to-percent (perc)
  "Move point to PERCENT of current buffer"
  (interactive "Npercent: ")
  (if (= perc 0)
      (beginning-of-buffer)
    (goto-char (1+ (* (1- perc) (/ (point-max) 100))))))
  
(defun revert-region (beg end)
  "Reverse the order of the charaters in the region"
  (interactive "r")
  (let (old len)
    (setq old (buffer-substring beg end))
    (setq len (1- (length old)))
    (goto-char beg)
    (delete-region beg end)
    (while (>= len 0)
      (insert (aref old len))
      (-- len))))
  
(defun revert-line ()
  "Reverse the order of the charaters in the line point is in."
  (interactive)
  (beginning-of-line)
  (revert-region (point) (progn (end-of-line) (point))))

(defun revert-lines-region (beg end)
  "Revert every line in region."
  (interactive "r")
  (goto-char beg)
  (while (< (point) end)
    (revert-line)
    (forward-line 1)))

(defun delete-line ()
  "Delete the current line."
  (interactive)
  (let (( kill-whole-line t))
    (beginning-of-line)
    (kill-line)))
    
(defun insert-key-description ()
  "Read a character from the command input (keyboard or macro).
It is inserted as a pretty description of command character KEY.
Control characters turn into C-whatever, etc."
  (interactive)
  (insert (single-key-description (read-char)) " "))

(defun insert-documentation (def)
  "Insert, in current buffer, the documentation for DEF."
  (interactive (list (intern (completing-read
			      "Insert documentation for: "
			      obarray
			      (function (lambda (def)
					  "Functions and variables"
					  (or (fboundp def)
					      (boundp def))))
			      t))))
  (insert (prin1-to-string (documentation def))))

(defvar copy-above-char-from-line ()
  "Copy characters from this line at successive invokations
of copy-above-char.")

(defun P-clean ()
  "Eliminate whitespace at ends of lines and tabify
\(except within quoted strings possibly containing \\\")"
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "[ \t]+$" nil t)
      (delete-region (match-beginning 0) (point)))
    (goto-char (point-max))
    (skip-chars-backward " \t\n")
    (delete-region (point) (point-max))
    (let (next
	  (start (point-min)))
      (goto-char start)
      (while (re-search-forward "\"\\(\\\\\"\\|[^\"]\\)*\"" nil t)
	(setq next (- (point-max) (point)))
	(tabify start (match-beginning 0)) ; Shorten file (hopefully)
					; (point-max) will change
	(goto-char (- (point-max) next))
	(setq start (point)))
      (tabify start (point-max)))
    (message "Picture cleaned and tabified")))

(defun size-of-display () "Print size of your display."
  (interactive)
  (message "%d*%d."
	   (screen-height)
	   (screen-width)))

(defconst complete-distance '1000
  "*Longest distance to search for completions in complete-search-word")

(defvar complete-word-list '(nil)
  "complete-word-or-indent  will complete words according to contents
of this list.  To erase its contents, use  complete-word-empty-list.")

(defvar list-choices-functions
  '((complete-filename . complete-filename-list-choices)
    (complete-shell-command . complete-shell-command-choices)
    (complete-word-or-indent . complete-word-list-choices))
  "Alist of (COMPLETION-FUNCTION . LIST-CHOICES-FUNCTION)
delete-char-or-list runs a LIST-CHOICES-FUNCTION depending on
what COMPLETION-FUNCTION there is in last-command.
If value of last-command is not a member of this list
delete-char-or-list will call delete-char interactively.")

(defun skip-chars-backward-quoted (chars &optional lim)
  "Like skip-chars-backward but,
it is possible to quote (with \\) those characters that normally
would set the leftmost limit."
  (skip-chars-backward chars lim)	; back to start
  (while (eq (char-after (- (point) 2)) ?\\) ; quoted?
    (forward-char -2)			; continue backwards
    (skip-chars-backward chars lim)))

(defun complete-filename ()
  "Perform completion on filename preceding point.
file-name-stop-chars  control what characters not
to include in the filename."
  (interactive)
  (let* ((end (point))
	 (start (save-excursion (skip-chars-backward-quoted
				 (concat "^" file-name-stop-chars))
				(point)))
	 (file-name (unquote-string (buffer-substring start end) file-name-stop-chars))
	 (expansion (expand-file-name file-name))
	 (dir (file-name-directory expansion))
	 (file (file-name-nondirectory expansion))
	 (readp (file-readable-p dir))
	 (file (and readp (file-name-completion file dir))))
    (cond ((null readp)
	   (message "%s unreadable" dir))
	  ((null file)
	   (message "No completion for: %s" file-name))
	  ((eq t file)
	   (insert " ") t)
	  ((= start end)
	   (message "no file") nil)
	  ((stringp file)
	   (delete-region start end)
	   (insert (quote-string
		    (concat
		     (file-name-directory file-name) file)
		    file-name-stop-chars))
	   (if (eq t (file-name-completion file dir))
	       (insert " ")) t))))


(defun complete-filename-list-choices ()
  "List all completions to filename preceding point."
  (interactive)
  (let* ((end (point))
	 (start (save-excursion (skip-chars-backward-quoted
				 (concat "^" file-name-stop-chars))
				(point)))
	 (file-name (unquote-string (buffer-substring start end) file-name-stop-chars))
	 (expansion (expand-file-name file-name))
	 (dir (file-name-directory expansion))
	 (file (file-name-nondirectory expansion))
	 (readp (file-readable-p dir))
	 (file (and readp (file-name-completion file dir))))
    (cond ((null readp)
	   (message "%s unreadable" dir))
	  ((null file)
	   (message "No completion for: %s" file-name))
	  ((eq t file)
	   (message "(Sole completion)"))
	  ((= start end)
	   (message "no file") nil)
	  ((stringp file)
	   (if (eq t (file-name-completion file dir))
					; fully completed single file
	       (message "(Sole completion)")
	     (message "Making completion list...")
	     (with-output-to-temp-buffer "*Help*"
	       (display-completion-list
		(sort (file-name-all-completions file dir)
		      'string-lessp)))
	     (message "Directory: %s" dir))))))

(defun expand-file-name-interactive ()
  "Perform expansion on filename preceding point.
see expand-file-name"
  (interactive)
  (let* ((end (point))
	 (start (save-excursion
		  (skip-chars-backward-quoted
		   (concat "^" file-name-stop-chars))
		  (point)))
	 (file-name (unquote-string (buffer-substring start end) file-name-stop-chars))
	 (expansion (expand-file-name file-name)))
    (delete-region start end)
    (insert (quote-string expansion file-name-stop-chars))))

(defun complete-word-or-indent ()
  "If at end of word do dabbrev-expand. else do indent-for-tab-command"
  (interactive)
  (if (and (eq (char-syntax (preceding-char)) ?w)
	  (or  (eobp) (not (eq (char-syntax (char-after (point))) ?w))))
      (dabbrev-expand nil)
    (indent-for-tab-command)))

(defun complete-word-list-choices ()
  "Make completion list for word preceding point.
see. complete-word-or-indent"
  (interactive)
  (let* ((end (point))
	 (start (save-excursion (while (eq (char-syntax (preceding-char)) ?\w)
				  (forward-char -1)) (point)))
	 (word (buffer-substring start end))
	 (word-list (append
		     complete-word-list
		     (complete-search-words word)))
	 (completion (try-completion word word-list)))
    (cond ((null completion)
	   (message "No completion for %s" word))
	  ((eq t completion)
	   (message "(Sole completion)"))
	  ((= start end)
	   (message "no word"))
	  ((stringp completion)
	   (if (eq t (try-completion completion word-list))
	       (message "(Sole completion)")
	     (message "Making completion list...")
	     (with-output-to-temp-buffer "*Help*"
	       (display-completion-list
		(sort (all-completions completion word-list)
		      'string-lessp)))
	     (message "Making completion list...done"))))))


(defun complete-search-words (pattern)
  "Search backward for words starting as WORD and return them."
  (and (null (equal "" pattern))
       (let ((reg-exp (concat "\\b" (regexp-quote pattern) "\\w*"))
	     (far (- (point) complete-distance))
	     (word-list)
	     (word))
	 (if (< far (point-min)) (setq far (point-min)))
	 (save-excursion
	   (re-search-backward reg-exp far t)
	   (while (re-search-backward reg-exp far t)
	     (setq word (buffer-substring (match-beginning 0) (match-end 0)))
	     ;; don't add if already in list
	     (or (assoc word word-list) (assoc word complete-word-list)
		 (setq word-list (cons (list word) word-list))))
	   word-list))))


(defun complete-empty-list ()
  "Delete contents of  complete-word-list."
  (interactive)
  (setq complete-word-list '(nil)))


(defun delete-char-or-list ()
  "Make completion list or run delete-char.
If value of last-command is a member of list-choices-functions
run the corresponding listmaker.
Otherwise call delete-char interactively."
  (interactive)
  (call-interactively
   (or (cdr (assq last-command list-choices-functions))
       'delete-char)))

(defun unquote-string (complex chars)
  "Remove all \\ in STRING that quotes one of CHARS.
A single \\ at the end of STRING is never excluded."
  (let* ((regexp (concat "\\\\[" chars "]"))
	 (next (string-match regexp complex 0))
	 simple
	 (start 0)
	 (len (length complex)))
    (while next
      (setq simple (concat simple (substring complex start next)) ; up to before \
	    start (1+ next)  ; always take from next+1
			     ; start search at next+2
	    next (string-match regexp complex (1+ start)))) ; find next \.
    (concat simple (substring complex start))))

(defun quote-string (str chars)
  "Put a \\ before every character in STRING that is a member of CHARS."
  (let (next complex (start 0)
	(delimiter (concat "[" chars "]")))
    (while (setq next (string-match delimiter str start)) ; find 1st \
      (setq complex (concat complex (substring str start next) ; put in
			    "\\"	; quote
			    (substring str next (1+ next))) ; delimiter
	    start (1+ next)))
    (concat complex (substring str start))))

(defun skip-char-backward-quoted (chars &optional lim)
  "Like skip-chars-backward but,
it is possible to quote (with \\) thoose characters that normally
would set the leftmost limit."
  (skip-chars-backward chars lim)	; back to start
  (while (eq (char-after (- (point) 2)) ?\\) ; quoted?
    (forward-char -2)			; continue backwards
    (skip-chars-backward chars lim)))


(defvar file-name-stop-chars
  "( \t)\n<>&|;\"'`:="
  "*Characters that  complete-filename  wont accept as part of
filenames unless quoted with backslash \"\\\". These delimiters
must exist to ensure practical and simple use of a command
which read input from the current buffer.
Note: backslash itself dosen't need to be quoted unless it is
      included in this string.")
