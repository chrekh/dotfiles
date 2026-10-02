;;; ...  -*- lexical-binding: t -*-

;;; swedkey.el

;;; Commentary:

;; Function `swedish-keys-mode' activates a minor mode in which old style
;; ISO-646-SE 7bit "}{|" are translated into ISO-8859-1 8bit "åäö".
;;
;; This file is derived from `swe728.el'
;; which in turn was derived from `iso-acc.el'.
;;
;; In `swedish-keys-mode', the following keys are re-mapped (both ways):
;;
;;   }  <->  å
;;   {  <->  ä
;;   |  <->  ö
;;   ]  <->  Å
;;   [  <->  Ä
;;   \  <->  Ö

(provide 'swedkey)

;; List that define what key should be switched to what.
(defvar swedish-keys-keylist '(
			 (?\[ . ?\304) ; 7bit->8bit
			 (?\\ . ?\326)
			 (?\] . ?\305)
			 (?{  . ?\344)
			 (?|  . ?\366)
			 (?}  . ?\345)
			 (?\304 . ?\[) ; and back...
			 (?\326 . ?\\)
			 (?\305 . ?\])
			 (?\344 . ?{)
			 (?\366 . ?|)
			 (?\345 . ?}))
  "List of key-substitutions for swedish-keys-mode

Each element of the list is of the form

    (7BIT-CHAR 8BIT-CHAR)
    (8BIT-CHAR 7BIT-CHAR)

The net effect is that the key 7BIT-CHAR is mapped
to 8BIT-CHAR on input. And back.")

;; Clear ev previous entry for swedish-keys-key in key-translation-map
(if key-translation-map
    (substitute-key-definition
     'swedish-keys-key nil key-translation-map))

;; Set the function swedish-keys-key to the affected keys in key-translation-map
(let ((keylist swedish-keys-keylist))
  (while keylist
    (define-key key-translation-map (vector (car (car keylist))) 'swedish-keys-key)
    (setq keylist (cdr keylist))))

;; The variable which determine if the mode is in effect.
(defvar swedish-keys-mode nil
  "*Non-nil enables swedish-keys-mode.
Setting this variable makes it local to the current buffer.
See the function `swedish-keys-mode'.")
(make-variable-buffer-local 'swedish-keys-mode)

;; The key-switching function
(defun swedish-keys-key (prompt)
  "Remap the typed character to its 8bit counterpart."
  (vector (if swedish-keys-mode
	      (cdr (assq last-input-event swedish-keys-keylist))
	    last-input-event)))

;; The mode. This is easy. Just change the value of the variable with the same name.
(defun swedish-keys-mode (&optional arg)
  "Swedish keys.
With arg, turn Swedish keys on if arg is not nil, on else.

This minor mode binds keys [\\]{|} to insert Swedish letters.
"
  (interactive "P")
  (if (if arg
	  ;; Negative arg means switch it off.
	  (<= (prefix-numeric-value arg) 0)
	;; No arg means toggle.
	swedish-keys-mode)
      (setq swedish-keys-mode nil)
    (setq swedish-keys-mode t)))

;; Indicate the minor-mode in the mode-line
(or (assq 'swedish-keys-mode minor-mode-alist)
    (setq minor-mode-alist
 	  (append minor-mode-alist
 		  '((swedish-keys-mode " ÅÄÖ")))))

;; Function to set the mode in minibuffer ( if active in previous buffer )
(defun swedish-keys-minibuf-setup ()
  (setq swedish-keys-mode
	(save-excursion
	  (set-buffer (window-buffer minibuffer-scroll-window))
	  swedish-keys-mode)))

;; And run that when entering the minibuffer
(add-hook 'minibuffer-setup-hook 'swedish-keys-minibuf-setup)

;;; swedkey.el ends here
