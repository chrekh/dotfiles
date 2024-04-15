(menu-bar-mode -1)
(set-scroll-bar-mode 'right)
(toggle-scroll-bar 1)
(transient-mark-mode 1)
(setq mark-even-if-inactive t)
(global-unset-key "\C-z")
(global-unset-key "\C-x\C-z")

;; fringe TEST-line       sdf                    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx                     sdf------------------------------

(modify-face 'highlight nil "turquoise" nil nil nil nil)
(modify-face 'mode-line "#fff020" "#583517" nil nil nil nil)
(modify-face 'region nil "orange" nil nil nil nil)

(setq default-frame-alist
      (append (list (cons 'foreground-color "#583517")
		    (cons 'background-color "#f0d8b0")
		    )
	      default-frame-alist))

;; Fix for problem with emacs-26.1 on RHEL8 under vcxsrv causing new frames to be resized to height 3
;; https://askubuntu.com/questions/1210236/how-to-stop-emacs-resizing-its-initial-frame
(setq after-init-hook (lambda ()
                        (set-frame-height (selected-frame) 37 ))
      after-make-frame-functions (lambda (frame)
                                   (set-frame-height frame 37 ))
      )

(cond ((>= emacs-major-version 21)
       (tool-bar-mode -1)
       (blink-cursor-mode -1)
       (mouse-wheel-mode 1)
       (modify-face 'fringe "#000000" "#ffb0b0" nil nil nil nil)
       ))

(cond ((>= emacs-major-version 24)
       (setq select-active-regions 'only
             x-select-enable-primary t
             x-select-enable-clipboard t
             mouse-drag-copy-region t
             )
       ))

(set-mouse-color "Black")

(defun bigfont nil
  "Change font"
  (interactive)
  (set-face-font 'default "-*-*-medium-r-normal-*-20-*-*-*-*-*-iso8859-*")
  )

(defun smallfont nil
  "Reset font"
  (interactive)
  (set-face-font 'default "*-fixed-medium-r-normal-*-14-*-*-*-c-*-iso8859-*")
  )
