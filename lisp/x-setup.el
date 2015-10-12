(set-scroll-bar-mode 'right)
(toggle-scroll-bar 1)
(transient-mark-mode 1)
(setq mark-even-if-inactive t)
(global-unset-key "\C-z")

;; fringe TEST-line       sdf                    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx                     sdf------------------------------

(modify-face 'highlight nil "turquoise" nil nil nil nil)
(modify-face 'mode-line "#fff020" "#583517" nil nil nil nil)
(modify-face 'region nil "orange" nil nil nil nil)

(setq default-frame-alist
      (append (list (cons 'foreground-color "#583517")
		    (cons 'background-color "#f0d8b0")
		    )
	      default-frame-alist))


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
             )
       ))

(set-mouse-color "Black")
