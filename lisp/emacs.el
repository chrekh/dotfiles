;(setq debug-on-error t)
(setq load-path (append '("~che/lisp") load-path))

(defvar using-x (eq window-system 'x) "
non nil if this emacs uses X ?")

(load "loads")

(menu-bar-mode -1)
(if using-x
    (load "x-setup"))

;; let - be part of words in emacs-lisp-mode
;(modify-syntax-entry ?- "w" emacs-lisp-mode-syntax-table)
(modify-syntax-entry ?_ "w")

(put 'set-fill-column 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'eval-expression 'disabled nil)

(load-library "server")
(setq server-window (lambda (buf) (switch-to-buffer-other-frame buf)))
(add-hook 'server-done-hook (lambda () (delete-frame)))
(and (fboundp 'server-running-p) (not (server-running-p)) (server-start))
