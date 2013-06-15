;;; swe728.el --- minor mode providing map from 7bit to 8bit Swedish keys

;;; Commentary:

;; Function `swe728-mode' activates a minor mode in which old style
;; ISO-646-SE 7bit "}{|" are translated into ISO-8859-1 8bit "והצ".
;;
;; This file is derived from `iso-acc.el'.
;;
;; In `swe728-mode', the following keys are re-mapped (both ways):
;;
;;   }  <->  ו
;;   {  <->  ה
;;   |  <->  צ
;;   ]  <->  ֵ
;;   [  <->  ִ
;;   \  <->  ײ

;;; Code:

(provide 'swe728)

(defgroup swe728 nil
  "Minor mode providing Swedish 8bit keys."
  :prefix "swe728-"
  :group 'i18n)

(defvar swe728-languages
  '(("swedish"
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
    ("norwegian"
     (?\[ . ?\306)
     (?\\ . ?\330)
     (?\] . ?\305)
     (?{  . ?\346)
     (?|  . ?\370)
     (?}  . ?\345)
     (?\306 . ?\[)
     (?\330 . ?\\)
     (?\305 . ?\])
     (?\346 . ?{)
     (?\370 . ?|)
     (?\345 . ?})))
  "List of language-specific customizations for the Swe728 mode.

Each element of the list is of the form

    (LANGUAGE
     (7BIT-CHAR 8BIT-CHAR)
     (7BIT-CHAR 8BIT-CHAR)
     ...)

LANGUAGE is a string naming the language.
7BIT-CHAR is a char specifying a 7bit key.
8BIT-CHAR is a char specifying the corresponding 8bit key.

The net effect is that the key 7BIT-CHAR is mapped
to 8BIT-CHAR on input.")

(defvar swe728-language nil
  "Language for which Swe728 mode is currently customized.
Change it with the `swe728-customize' function.")

(defvar swe728-list nil
  "Association list for mapping 7bit }{| to 8bit והצ.")

(defcustom swe728-mode nil
  "*Non-nil enables Swe728 mode.
Setting this variable makes it local to the current buffer.
See the function `swe728-mode'."
  :type 'boolean
  :group 'swe728)
(make-variable-buffer-local 'swe728-mode)

(defun swe728-key (prompt)
  "Remap the typed character to its 8bit counterpart."
  (vector (if swe728-mode
	      (cdr (assq last-input-char swe728-list))
	    last-input-char)))

;; It is a matter of taste if you want the minor mode indicated
;; in the mode line...
;; If so, uncomment the next four lines.
 (or (assq 'swe728-mode minor-mode-alist)
     (setq minor-mode-alist
 	  (append minor-mode-alist
 		  '((swe728-mode " ִֵײ")))))

;;;###autoload
(defun swe728-mode (&optional arg)
  "Toggle Swe728 mode, in which 7bit }{| are mapped into 8bit והצ.
This permits easy insertion of Swedish characters according to ISO-8859-1.
When swe728 mode is enabled, the character keys
\({, |, }, [, \\ and ]) inserts an ISO 8bit letter.

You can customize Swe728 mode to a particular language
with the command `swe728-customize'.

With an argument, a positive argument enables Swe728 mode,
and a negative argument disables it."
  (interactive "P")
  (if (if arg
	  ;; Negative arg means switch it off.
	  (<= (prefix-numeric-value arg) 0)
	;; No arg means toggle.
	swe728-mode)
      (setq swe728-mode nil)
    (setq swe728-mode t)))

(defun swe728-customize (language)
  "Customize the Swe728 machinery for a particular language.
It selects the customization based on the specifications in the
`swe728-languages' variable."
  (interactive (list (completing-read "Language: " swe728-languages nil t)))
  (let ((table (cdr (assoc language swe728-languages)))
	tail)
    (if (not table)
	(error "Unknown language `%s'" language)
      (setq swe728-language language
	    swe728-list table)
      (if key-translation-map
	  (substitute-key-definition
	   'swe728-key nil key-translation-map)
	(setq key-translation-map (make-sparse-keymap)))
      ;; Set up translations for all the characters that are used as
      ;; remapped 7bit characters in this language.
      (setq tail swe728-list)
      (while tail
	(define-key key-translation-map (vector (car (car tail))) 'swe728-key)
	(setq tail (cdr tail))))))

;; Set up the default settings.
(swe728-customize "swedish")

;; Use Swe728 mode in the minibuffer
;; if it was in use in the previous buffer.
(defun swe728-minibuf-setup ()
  (setq swe728-mode
	(save-excursion
	  (set-buffer (window-buffer minibuffer-scroll-window))
	  swe728-mode)))

(add-hook 'minibuffer-setup-hook 'swe728-minibuf-setup)

;;; swe728.el ends here
