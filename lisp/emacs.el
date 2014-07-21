(setq load-path (append
		 '("~che/lisp" "~che/extern/lisp"
		   "~chrekh/lisp" "~u0043002/lisp"
		   "~u0043002/extern/lisp")
		 load-path))

(load "loads")

(cond ((and window-system (not (featurep 'xemacs))) 
       (load "x-setup")
       (load-library "server")
       (setq server-window (lambda (buf) (switch-to-buffer-other-frame buf)))
       (add-hook 'server-done-hook (lambda () (delete-frame)))
       
       (if (fboundp 'server-running-p)
	   (and (not (server-running-p))
		(server-start))
	 (server-start))
       ))

(modify-syntax-entry ?_ "w")

(put 'set-fill-column 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'eval-expression 'disabled nil)
(setq load-home-init-file t) ; don't load init file from ~/.xemacs/init.el
