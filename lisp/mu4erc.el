(load-library "mu4e")

(setq
 ;; use mu4e for e-mail in emacs
 mail-user-agent 'mu4e-user-agent

 ;; general emacs mail settings; used when composing e-mail
 ;; the non-mu4e-* stuff is inherited from emacs/message-mode
 mu4e-compose-reply-to-address "che@chrekh.se"
 user-mail-address "che@chrekh.se"
 user-full-name  "Christer Ekholm"
 mu4e-compose-signature " Christer\n"

 ;; use 'fancy' non-ascii characters in various places in mu4e
 ;mu4e-use-fancy-chars t

 mu4e-headers-fields '((:human-date . 12)
		       (:flags . 6)
		       (:from-or-to . 22)
		       (:subject))
 mu4e-maildir-shortcuts '( ("/" . ?i)
			   ("/sent" . ?s)
			   ("/dmarc" . ?d)
			   )
 
 mu4e-view-show-addresses t
 mu4e-headers-sort-field :date
 mu4e-headers-sort-direction 'ascending
 mu4e-headers-full-search t
 mu4e-confirm-quit nil
 )

(defun my-create-maildir (dir)
  (interactive "MDir: ")
  (mu4e-create-maildir-maybe (expand-file-name dir mu4e-maildir)))
(define-key mu4e-main-mode-map "N" 'my-create-maildir)
(define-key mu4e-headers-mode-map "N" 'my-create-maildir)

(defun my-mu4e-mark-spam ()
  "Mark this mail as spam"
  (interactive)
  (mu4e-view-pipe "/usr/bin/sa-learn --spam -")
  (delete-other-windows))

(defun my-mu4e-mark-ham ()
  "Mark this mail as ham"
  (interactive)
  (mu4e-view-pipe "/usr/bin/sa-learn --ham -")
  (delete-other-windows))

(setq mu4e-spam-map (make-sparse-keymap))
(define-key mu4e-headers-mode-map "o" mu4e-spam-map)
(define-key mu4e-view-mode-map "o" mu4e-spam-map)
(define-key mu4e-spam-map "h" 'my-mu4e-mark-ham)
(define-key mu4e-spam-map "s" 'my-mu4e-mark-spam)
