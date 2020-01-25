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
 
 mu4e-view-show-addresses t

 mu4e-confirm-quit nil
 )
