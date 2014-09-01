;; from /usr/share/emacs/site-lisp/site-gentoo.d/50vm-gentoo.el
(add-to-list 'load-path "/usr/share/emacs/site-lisp/vm")
(setq vm-toolbar-pixmap-directory "/usr/share/pixmaps/vm")
(setq vm-image-directory "/usr/share/pixmaps/vm")
(require 'vm-autoloads)
(require 'dired)
(autoload 'vm-delete-message "vm-delete")
(autoload 'vm-sort-compare-xxxxxx "vm-sort")

;; gpg
(load-library "mailcrypt") ; provides "mc-setversion"
(mc-setversion "gpg")
(add-hook 'vm-mode-hook 'mc-install-read-mode)
(add-hook 'vm-summary-mode-hook 'mc-install-read-mode)
(add-hook 'vm-virtual-mode-hook 'mc-install-read-mode)
(add-hook 'vm-mail-mode-hook 'mc-install-write-mode)


(setq
 vm-spool-files			'("/var/mail/che")
 vm-folder-directory    	"~/Mail/"
 vm-primary-inbox 		"~/Mail/received"
 vm-crash-box           	"~/Mail/vm.crash"
 
 vm-move-messages-physically	t
 vm-thread-using-subject	nil
 vm-auto-displayed-mime-content-types t
 vm-skip-deleted-messages	t
 vm-crash-box-suffix		"crash"
 vm-delete-empty-folders	nil
 vm-summary-show-threads	t
 vm-display-using-mime 		t
 vm-reply-subject-prefix	"Re: "
 vm-frame-per-folder		nil
 vm-imap-expunge-after-retrieving t
 vm-preview-lines       	nil
 vm-delete-after-saving 	t
 vm-circular-folders 		t
 vm-startup-with-summary 	t
 vm-move-after-deleting		t
 vm-move-after-undeleting 	t
 vm-follow-summary-cursor 	t
 pop-up-windows			nil
 vm-forwarding-digest-type      nil
)

(setq vm-auto-folder-alist
      '(
	("From"
	 ("^che" . '(("To" ("[ 	<]*\\([^ 	]+\\)@" .
			       (buffer-substring
				(match-beginning 1) (match-end 1))))))
	 ("[ 	<]*\\([^ 	]+\\)@" . (buffer-substring
					   (match-beginning 1) (match-end 1)))
	 )))


(defun vm-sa-register-ham ()
       "Register this mail as ham"
       (interactive)
       (vm-pipe-message-to-command "/usr/bin/sa-learn --ham -" 0))

(defun vm-sa-register-spam ()
       "Register this mail as spam"
       (interactive)
       (vm-pipe-message-to-command "/usr/bin/sa-learn --spam -" 0))

(defun vm-dont-backup-this-buffer ()
  "Just sets backup inhibited locally to t."
  (make-local-variable 'backup-inhibited)
  (setq backup-inhibited t))

(defun dired-vm-visit-file ()
  ""
  (interactive)
  (vm-visit-folder (dired-get-file-for-visit)))

(define-key dired-mode-map "F" 'dired-vm-visit-file)

(setq vm-sa-map (make-sparse-keymap))

(define-key vm-summary-mode-map "x" 'vm-expunge-folder)
(define-key vm-summary-mode-map "O" vm-sa-map)
(define-key vm-summary-mode-map "Q" 'vm-quit-no-change)
(define-key vm-sa-map "s" 'vm-sa-register-spam)
(define-key vm-sa-map "h" 'vm-sa-register-ham)

(add-hook 'vm-mode-hook 'vm-dont-backup-this-buffer)
(add-hook 'vm-quit-hook 'vm-expunge-folder)
