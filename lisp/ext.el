;;; ...  -*- lexical-binding: t -*-

;; Add some "file name suffix - mode command" pairs
(setq auto-mode-alist (append '(
				("\\(\\.\\|^\\)SCORE$" . emacs-lisp-mode)
                                ("\\.db$" . zone-mode)
				("\\.pp$" . puppet-mode)
				("Puppetfile$" . puppetfile-mode)
				("Jenkinsfile" . javascript-mode)
				("\\.ya?ml$" . yaml-mode)
				("\\.eml$" . text-mode)
				("\\.\\(pm?\\|pod\\|t\\)6$" . perl6-mode)
				("\\.raku\\(mod\\|doc\\|test\\)?$" . perl6-mode)
                                ("/tmp/tmp$" . swedish-keys-mode)
                                ("\\.nft\\(?:ables\\)?\\'" . nftables-mode)
				)
			      auto-mode-alist))


