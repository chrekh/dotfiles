;;; Wormy worm game.
;; Originally written by Christer Ekholm, che@ludd.luth.se
;;
;; This file is NOT (yet) part of GNU Emacs.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY.  No author or distributor
;; accepts responsibility to anyone for the consequences of using it
;; or for whether it serves any particular purpose or works at all,
;; unless he says so in writing.  Refer to the GNU Emacs General Public
;; License for full details.

;; Everyone is granted permission to copy, modify and redistribute
;; GNU Emacs, but only under the conditions described in the
;; GNU Emacs General Public License.   A copy of this license is
;; supposed to have been given to you along with GNU Emacs so you
;; can know your rights and responsibilities.  It should be in a
;; file named COPYING.  Among other things, the copyright notice
;; and this notice must be preserved on all copies.

(require 'timer)

(defvar wormy-highscore-file "/tmp/wormy-high"
  "* File to store highscores in!")

(defvar wormy-message "

			******* Wormy *******
				   
			      Written by
			   Christer Ekholm
			  che@ludd.luth.se
				   
				   
	   Control the worm, eat * 's, look out for [] 's.
				   
			     j: turn right
			     l: turn left")

(defvar wormy-previous-buffer)
(defvar wormy-previous-vindow-config)
(defvar worm-max-length 800)
(defvar worm-max-hinders 50)
(defvar wormy-width)
(defvar wormy-height)
(defvar wormy-right)
(defvar wormy-down)
(defvar worm-counter 0)
(defvar wormy-delay)
(defvar worm-timer)

(defsubst wormy-topos (col row)
  "move to COL ROW"
  (goto-line row)
  (beginning-of-line)
  (forward-char col))

(defun wormy-init-screen ()
  "fill screen to WIDTH HEIGHT with blanks"
  (let ((line 0)
	(col 0))
    (while (< line (1- wormy-height))
      (while (< col (1- wormy-width))
	(insert 32)
	(setq col (1+ col)))
      (insert ?\[)(insert ?\])
      (setq col 0)
      (newline)
      (setq line (1+ line)))
    (while (<= col wormy-width)
      (insert ?\[)
      (if (< col wormy-width)
	  (insert ?\]))
      (setq col (+ 2 col)))))

(defsubst wormy-put-char-at (char col row)
  "put CHAR at COL ROW"
  (wormy-topos col row)
  (delete-char 1)
  (insert-char char 1)
  (wormy-topos 0 0))


(defsubst wormy-char-at-pos (col row)
  "Returns character at pos COL ROW"
  (wormy-topos col row)
  (char-after (point)))

(defsubst wormy-pos-to-remove (pointer worm-length)
  "Position to be removed when worm is moving"
  (if (= pointer worm-length) 0
    (1+ pointer)))

(defsubst wormy-make-hinder nil
  "Draw a [] at a not occupied random position"
  (let (tmpcol tmprow)
    (while (progn (setq tmpcol (*(/(random (1- wormy-width))2)2)
			tmprow (random wormy-height))
		  (or (/= (wormy-char-at-pos tmpcol tmprow) 32)
		      (/= (wormy-char-at-pos (1+ tmpcol)tmprow) 32))))
      
    (wormy-put-char-at ?\[ tmpcol tmprow)         ;; draw
    (wormy-put-char-at ?\] (1+ tmpcol) tmprow))) ;; hinder

(defsubst wormy-make-snack nil
  "Draw a * at a not occupied random position"
  (let (tmpcol tmprow)
    (while (progn (setq tmpcol (random (1- wormy-width))
			tmprow (random wormy-height))
		  (or (/= (wormy-char-at-pos tmpcol tmprow) 32))))

    (wormy-put-char-at ?* tmpcol tmprow)))      ;; draw snack



;; Changing of moving direction
(defsubst wormy-turn-left nil
  "turn current moving direction left"
  (if (= wormy-right 0)
      (progn (setq wormy-right wormy-down)(setq wormy-down 0))
    (setq wormy-down (- wormy-right))(setq wormy-right 0)))
  
(defsubst wormy-turn-right nil
  "turn current moving direction right"
  (if (= wormy-right 0)
      (progn (setq wormy-right (- wormy-down))(setq wormy-down 0))
    (setq wormy-down wormy-right)(setq wormy-right 0)))

(defun wormy-highscore (score length)
  (let (buffer)
    (unwind-protect
	(setq buffer (find-file wormy-highscore-file))
	(progn
	  (if buffer-read-only (toggle-read-only))
	  (goto-char (point-max))
	  (insert (format "%8d  %3d   %-8s  %s %s  on  %s\n"
			  score length
			  (user-login-name)
			  (substring (current-time-string) 4 9)
			  (substring (current-time-string) -4)
			  (system-name)))
	  (shell-command-on-region (point-min) (point-max) "sort -n -r" t)
	  (goto-line 21)
	  (move-to-column 0)
	  (delete-region (point) (point-max))
	  (save-buffer 0)
	  (switch-to-buffer "*wormy*")
	  (erase-buffer)
	  (insert-buffer buffer)
	  (goto-char (point-min))
	  (insert "   Score length name      when            where")
	  (newline)(newline))
	
      (kill-buffer buffer))))

(defun wormy-adjust-delay nil
  (if (> worm-counter 58)
      (setq wormy-delay (+ wormy-delay 0.01)))
  (if (< worm-counter 54)
      (setq wormy-delay (- wormy-delay 0.01)))
  (setq worm-counter 0))
    

(defun wormy nil
  "worm game."
  (interactive)
  (if (not(string-equal (buffer-name (current-buffer)) "*wormy*"))
      (setq wormy-previous-buffer (current-buffer)
	    wormy-previous-vindow-config (current-window-configuration)))
  
  (switch-to-buffer (get-buffer-create "*wormy*"))
  (make-variable-buffer-local 'global-mode-string)
  (random t)
  (let* (
	 (col 1)(pointer 0)
	 (worm-time (car (cdr (current-time))))
	 (snacs 8)(worm-length 4)(worm-hinders 0)(score 0)
	 game-over stop char row input
	 (sudd-vect (make-vector worm-max-length (vector 0 0))))
    
    (setq wormy-width (if (< (- (window-width) 2) 80) (- (window-width) 2)
		  80))
    (setq wormy-height (if (< (- (window-height) 1) 25) (- (window-height) 1)
		   25))
    (setq row (/ wormy-height 2))
    (setq wormy-down 0)
    (setq wormy-right 1)
    (setq wormy-delay 0.13)
    
    (erase-buffer)
    (insert-string wormy-message)
    (beginning-of-buffer)
    (sit-for 0)
    ; This should rather be some kind of "Press any key to continue"
    (while (not (y-or-n-p "Are you ready? ")))
    (message "Worm is running!")
    (erase-buffer)
    (sit-for 0)
    (wormy-init-screen)
    
    ;; Insert some snacs 
    (while (>= (setq snacs (1- snacs)) 0)
      (wormy-make-snack))

    (setq worm-timer (run-at-time 10 10 'wormy-adjust-delay))
    (unwind-protect
	(while (not game-over)
	  
	  ;;   Read terminal input and change moving direction
	  (if (not(input-pending-p)) nil
	    (setq input (read-char))
	    (cond ((= input ?j) (wormy-turn-left))
		  ((= input ?l) (wormy-turn-right))))
	  
	  (setq col (+ col wormy-right)  ;; next position
		row (+ row wormy-down))  ;; to draw a "O" in
	  
	  (setq char (wormy-char-at-pos col row))
	  (setq game-over (or (< col 0)(> col wormy-width)(< row 0)(> row wormy-height)
			      (= char ?O)(= char ?\[)(= char ?\])))
	  
	  (wormy-put-char-at ?O col row) ;; draw worm head
	  (wormy-put-char-at 32          ;; erase worm tail
			     (aref (aref sudd-vect
					 (wormy-pos-to-remove pointer
							      worm-length)) 0)
			     (aref (aref sudd-vect
					 (wormy-pos-to-remove pointer
							      worm-length)) 1))
	  
	  
	  ;; if char at this position is a "*" 
	  (if (not(= char ?*))
	      (setq score (1+ score))
	    (if (< worm-length (1- worm-max-length))
		(setq worm-length                    ;; increase worms length
		      (1+ worm-length)))
	    (setq score
		  (+ score 50
		     (* 2 worm-length)))          ;; increase score
	    (if (< worm-hinders worm-max-hinders)
		(progn (setq worm-hinders (1+ worm-hinders))
		       (wormy-make-hinder)))
	    (wormy-make-snack))
	  (setq global-mode-string (concat "Score: " (int-to-string score)
					   " length: " (int-to-string worm-length)))
	  (setq worm-counter (1+ worm-counter))
	  (sit-for wormy-delay)  ;; make changes visible, and delay a little.
	  (aset sudd-vect pointer (vector col row)) ;; store position for
	  ;; later erasing
	  (setq pointer (1+ pointer)) 
	  (if (> pointer worm-length)
	      (setq pointer 0)))
      (cancel-timer worm-timer))
    ;; Game over
    (message "Game over!")
    (wormy-topos 0 (/ wormy-height 2))
    (beep)
    (sit-for 1)
    (while (input-pending-p) (read-char))
    (forward-char 5) (delete-char 13)
    (insert-string "*************")
    (forward-line 1)
    (forward-char 5) (delete-char 13)
    (insert-string "* Game Over *")
    (forward-line 1)
    (forward-char 5) (delete-char 13)
    (insert-string "*************")
    (forward-line 1)
    (forward-char 5) (delete-char (+ 9 (length (int-to-string score))))  
    (insert-string " Score: " (int-to-string score) " ")
    (goto-char (point-min))
    (sit-for 3)
    (wormy-highscore score worm-length)
    (if (setq stop (y-or-n-p "Play again? "))
	(wormy))
    (message "")
    (set-window-configuration wormy-previous-vindow-config)
    (switch-to-buffer wormy-previous-buffer)
    
    (setq global-mode-string nil)))
