(setq-default
 indicate-empty-lines t
 indicate-unused-lines t
 case-fold-search t
 fill-column 79
 ;; Intentation
 indent-tabs-mode nil
 sh-basic-offset 2
 sh-indentation 2
 )

(custom-set-variables
 '(js-indent-level 2)
 )

(setq
 focus-follows-mouse t
 user-mail-address "che@chrekh.se"
 add-log-full-name "Christer Ekholm"
 send-mail-function 'sendmail-send-it
 ispell-program-name "aspell"
 make-backup-files nil
 inhibit-startup-screen t
 initial-scratch-message nil
 confirm-nonexistent-file-or-buffer nil
 calendar-week-start-day 1
 line-move-visual nil
 require-final-newline t
 next-line-add-newlines nil
 ;Info-enable-edit t
 dired-listing-switches "-al"
 dired-auto-revert-buffer t
 dired-recursive-deletes 'always
 mouse-yank-at-point t
 dired-no-confirm '(byte-compile
                    chgrp chmod chown compress
                    copy delete hardlink load move
                    print shell symlink uncompress)
 dired-deletion-confirmer (lambda (dummy) t)
 mail-yank-prefix 		"> "
 mail-archive-file-name 	"~/Mail/sent"
 calendar-latitude 59.742
 calendar-longitude 18.2
 calendar-location-name "Stockholm"
 calendar-standard-time-zone-name "MET"
 calendar-daylight-time-zone-name "MET-DST"
 indicate-empty-lines t
 c-default-style '((c-mode . "linux")
                   (java-mode . "java")
                   (awk-mode . "awk")
                   (other . "gnu"))
 browse-url-browser-function 'browse-url-chrome
 )

(add-hook 'mail-setup-hook
	  (lambda ()
	    (auto-fill-mode)
	    (fset 'mail-signature 'append-signature-short)))

(add-hook 'text-mode-hook
	  (lambda ()
	    (auto-fill-mode 1)
	    (swedish-keys-mode t)))

(add-hook 'mail-setup-hook 'mail-abbrevs-setup)

(if (fboundp 'global-font-lock-mode)  (global-font-lock-mode 1))
(if (fboundp 'global-auto-revert-mode) (global-auto-revert-mode 1))

(fset 'yes-or-no-p 'y-or-n-p)
(fset 'j-or-n-p 'y-or-n-p)
(fset 'ja-or-nej-p 'y-or-n-p)
