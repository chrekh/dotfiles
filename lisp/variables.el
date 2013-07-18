(setq-default
 indicate-empty-lines t
 indicate-unused-lines t
 case-fold-search t
 )

(setq
 user-mail-address "che@chrekh.se"
 ispell-program-name "aspell"
 make-backup-files nil
 inhibit-startup-screen t
 initial-scratch-message nil
 calendar-week-start-day 1
 require-final-newline t
 next-line-add-newlines nil
 ;Info-enable-edit t
 dired-listing-switches "-al"
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

(global-font-lock-mode 1)

(fset 'yes-or-no-p 'y-or-n-p)
(fset 'j-or-n-p 'y-or-n-p)
(fset 'ja-or-nej-p 'y-or-n-p)
