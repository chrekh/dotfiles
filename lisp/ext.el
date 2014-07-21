;; Add some "file name suffix - mode command" pairs
(setq auto-mode-alist (append '(
				("\\(\\.\\|^\\)SCORE$" . emacs-lisp-mode)
                                ("\\.db$" . zone-mode)
				("\\.pp$" . puppet-mode)
				("\\.ya?ml$" . yaml-mode)
				)
			      auto-mode-alist))


