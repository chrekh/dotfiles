(dolist (dir '("~u0043002/extern/lisp" "~u0043002/lisp"
	       "~chrekh/extern/lisp" "~chrekh/lisp"
	       "~che/extern/lisp" "~che/lisp"
	       "~/extern/lisp" "~/extern/lisp/magit" "~/lisp"))
  (when (file-accessible-directory-p dir)
    (add-to-list 'load-path (expand-file-name dir))))


(load "loads")

(menu-bar-mode -1)
(cond ((and window-system (not (featurep 'xemacs))) 
       (load "x-setup")
       (load-library "server")
       (setq server-window (lambda (buf) (switch-to-buffer-other-frame buf)))
       (add-hook 'server-done-hook (lambda () (delete-frame)))
       
       (and (fboundp 'server-running-p)
	    (not (server-running-p))
	    (server-start))
       (when (and (require 'edit-server nil t)
		  (not (process-status "edit-server")))
	 (setq edit-server-new-frame t)
	 (edit-server-start))
       ))

(modify-syntax-entry ?_ "w")

(put 'set-fill-column 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'eval-expression 'disabled nil)
(setq load-home-init-file t) ; don't load init file from ~/.xemacs/init.el
