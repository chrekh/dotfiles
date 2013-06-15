;; Exchange bindings for "RETURN" and "LINEFEED" to support indentation.
(define-key global-map "\C-j" 'newline)
(define-key global-map "\C-m" 'reindent-then-newline-and-indent)

;(define-key global-map " " 'insert-or-scroll)
(define-key global-map "\C-x\C-o" 'bury-buffer)
(define-key global-map "\C-m" 'newline-and-indent)
(define-key global-map "\C-d" 'delete-char-or-list)
(define-key global-map "\C-u" 'delete-line)
;(define-key global-map "\C-z" 'save-buffers-suspend)
(define-key global-map "\C-cw" 'append-signature-long)
(define-key global-map "\C-c\C-w" 'append-signature-short)
(define-key global-map "\M-g" 'goto-line)
(define-key global-map "\C-ci" 'isearch-toggle-case-fold)

(define-key text-mode-map "\e\t" 'lisp-complete-symbol)

(cond ((>= emacs-major-version 21)
       (define-key global-map [home] 'beginning-of-buffer)
       (define-key global-map [end] 'end-of-buffer)
       ))
