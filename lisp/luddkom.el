;; Set variables before loading lyskom. To prevent them to be loaded from user-area
(setq-default
   kom-mercial "Starting KOM" ; placeholder until we can set the real value
   kom-url-viewer-preferences '("emacs" "default")
   kom-remember-password t
   kom-deferred-printing t
   kom-read-related-first nil
   kom-read-depth-first nil
   kom-show-since-and-when t
   kom-relogin-behaviour t
   kom-show-sync-messages t
   kom-follow-attachments nil
   kom-audio-player ""
   kom-autowrap nil
   kom-bury-buffers t
   kom-continuous-scrolling t
   kom-created-texts-are-read nil
   kom-customize-in-window 'new-frame
   kom-default-language 'sv
   kom-default-mark nil
   kom-ding-on-personal-messages 0
   kom-ding-on-group-messages 0
   kom-ding-on-common-messages 0
   kom-ding-on-no-subject 0
   kom-ding-on-wait-done 0
   kom-ding-on-new-letter 0
   kom-ding-on-priority-break 0
   kom-do-when-done '(kom-display-time)
   kom-do-when-starting '(kom-list-news)
   kom-emacs-knows-iso-8859-1 t
   kom-follow-comments-outside-membership t
   kom-format-html-authors '((t))
   kom-highlight-dashed-lines t
   kom-highlight-text-body t
   kom-idle-hide 30
   kom-max-overlays nil
   kom-membership-default-message-flag t
   kom-membership-default-priority 80
   kom-netscape-command "firefox"
   kom-permissive-completion nil
   kom-pop-personal-messages nil
   kom-print-relative-dates nil
   kom-print-seconds-in-time-strings t
   kom-prioritize-in-window 'new-frame
   kom-read-depth-first t
   kom-server-priority-breaks 'after-conf
   kom-show-creating-software t
   kom-show-footnotes-immediately nil
   kom-show-personal-messages-in-buffer t
   kom-smileys nil
   kom-user-prompt-format "%s: %[%c% %m%] -"
   kom-user-prompt-format-executing "%s: %[%c% %m%] ~"
   kom-write-texts-in-window 'other
   lyskom-inhibit-mode-line-unread t
   lyskom-prompt-text " > "
   kom-text-body-face 'kom-face--text-body-face
   kom-dashed-lines-face 'kom-face--dashed-lines-face
   kom-async-dashed-lines-face 'kom-face--async-dashed-lines-face
   kom-async-text-body-face 'kom-face--async-text-body-face
   kom-server-aliases '(("city.dll.nu" . "SnoppKOM")
			("plutten.dnsalias.org" . "PluttenKOM"))
   )


(defun set-kom-mercial ()
  (interactive)
  (let ((ver
	 (cond ((string-match "\\(Git .*\\))" lyskom-clientversion)
		(match-string 1 lyskom-clientversion))
	       (t "hej"))))
    (setq
     kom-mercial (concat "Kör lyskom.el [" ver "] i Emacs " emacs-version))))

(let ((lyskom-elc "/usr/local/src/lyskom-elisp-client/src/lyskom.elc"))
  (if (file-exists-p lyskom-elc)
      (load-file lyskom-elc)
    (require 'lyskom)))

(set-kom-mercial)

(cond ((not (featurep 'xemacs))
       (copy-face 'default 'kom-face--text-body-face)
       (copy-face 'default 'kom-face--dashed-lines-face)
       (copy-face 'default 'kom-face--async-dashed-lines-face)
       (copy-face 'default 'kom-face--async-text-body-face)
       (modify-face 'kom-face--dashed-lines-face nil "#ffe0c0" nil nil nil nil)
       (set-face-attribute 'kom-face--dashed-lines-face nil :extend t)
       (modify-face 'kom-face--text-body-face nil "#ffe0b8" nil nil nil nil)
       (set-face-attribute 'kom-face--text-body-face nil :extend t)
       (modify-face 'kom-face--async-dashed-lines-face "#000000" "#ffe8d0" nil nil nil nil)
       (modify-face 'kom-face--async-text-body-face "#006020" "#ffe0d0" nil nil nil nil)
       ))
; Read my passwords
(load-file "~/hemligt/kom-passwords.el")

(defun koms-with-wait ()
  (interactive)
  (sit-for 1)
  (redraw-display)
  (sit-for 1)
  (koms)
  )

(defun koms () ""
  (interactive)
  (condition-case nil (ludd) (error nil))
  (condition-case nil (lys) (error nil))
  (condition-case nil (snopp) (error nil))
 ; (condition-case nil (uppkom) (error nil))
 ; (condition-case nil (cdkom) (error nil))
 ; (condition-case nil (rydkom) (error nil))
 ; (condition-case nil (tokkom) (error nil))
 ; (condition-case nil (mdskom) (error nil))
  (condition-case nil (mys) (error nil))
 ; (condition-case nil (plutten) (error nil))
)

(defun start-or-goto-kom (alias kom user password)
  (lyskom-clean-all-buffer-lists)
  (let ((kombuffers lyskom-buffer-list)
	(buf))
    (while kombuffers
      (when (string= kom (buffer-name (car kombuffers)))
	(setq buf (car kombuffers)
	      kombuffers nil))
      (setq kombuffers (cdr kombuffers)))
    (if buf
	(lyskom-switch-to-kom-buffer buf)
      (message (concat "starting " alias))
      (lyskom kom user password))))

(defun ludd () ""
  (interactive)
  (setq-default my-kom-server-priority 250)
  (start-or-goto-kom "LuddKOM" "kom.ludd.luth.se" "Christer Ekholm" (plist-get kom-passwd 'ludd)))

(defun lys () ""
  (interactive)
  (setq-default
   my-kom-server-priority 250
   kom-deferred-printing nil
   kom-friends '(1167 10706 70 6599)
   )
  (start-or-goto-kom "LysKOM" "kom.lysator.liu.se" "Christer Ekholm" (plist-get kom-passwd 'lys)))

(defun mys () ""
  (interactive)
  (setq-default my-kom-server-priority 50)
  (start-or-goto-kom "MysKOM" "myskom.kfib.org" "Christer Ekholm" (plist-get kom-passwd 'mys)))

(defun snopp () ""
  (interactive)
  (setq-default my-kom-server-priority 90)
  (start-or-goto-kom "SnoppKOM" "city.dll.nu" "Christer Ekholm" (plist-get kom-passwd 'snopp)))

(defun uppkom () ""
  (interactive)
  (setq-default my-kom-server-priority 90)
  (start-or-goto-kom "uppkom" "kom.update.uu.se" "Christer Ekholm" (plist-get kom-passwd 'uppkom)))

(defun cdkom () ""
  (interactive)
  (setq-default my-kom-server-priority 90)
  (start-or-goto-kom "CDKOM" "kom.cd.chalmers.se" "Christer Ekholm" (plist-get kom-passwd 'cdkom)))

(defun plutten () ""
  (interactive)
  (setq-default my-kom-server-priority 80)
  (start-or-goto-kom "PluttenKOM" "plutten.dnsalias.org" "Christer Ekholm" (plist-get kom-passwd 'plutten)))

(defun rydkom () ""
  (interactive)
  (setq-default my-kom-server-priority 90)
  (start-or-goto-kom "RydKOM" "kom.hem.liu.se" "Christer Ekholm" (plist-get kom-passwd 'rydkom)))

(defun tokkom () ""
  (interactive)
  (setq-default my-kom-server-priority 90)
  (start-or-goto-kom "TokKOM" "kom.stacken.kth.se" "Christer Ekholm" (plist-get kom-passwd 'tokkom)))

(defun dskom () ""
  (interactive)
  (setq-default my-kom-server-priority 90)
  (start-or-goto-kom "DSKOM" "kom.ds.hj.se" "Christer Ekholm" (plist-get kom-passwd 'dskom)))

(defun mdskom () ""
  (interactive)
  (setq-default my-kom-server-priority 90)
  (start-or-goto-kom "MDSKOM" "kom.mds.mdh.se" "Christer Ekholm" (plist-get kom-passwd 'mdskom)))

(add-hook 'lyskom-edit-mode-hook
          (function (lambda ()
                      (ispell-change-dictionary "svenska")
                      (flyspell-mode))))

(add-hook 'lyskom-login-hook
	  (function
	   (lambda ()
	     (set-kom-mercial)
	     (setq
	      kom-server-priority my-kom-server-priority
	      ))))

(add-hook 'lyskom-mode-hook (function (lambda () (swedish-keys-mode 1))))
(add-hook 'lyskom-mode-hook
      (function (lambda ()
		  (defun ja-or-nej-p (prompt &optional initial-input)
		    (y-or-n-p prompt))
		  (define-key lyskom-mode-map "," 'kom-view-commented-text)
		  (define-key lyskom-mode-map "c" 'kom-send-message)
		  (define-key lyskom-mode-map "C" 'kom-send-alarm)
                  )))
