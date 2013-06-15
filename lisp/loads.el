(setq inhibit-default-init t)
(load "default" t)
(load "misc")
(load "perl")
(load "html")
(load "ext")
(load "bindings")
(load "variables")
(if using-x
    (progn
      (load "frame")
      ))

(autoload 'html-helper-mode "html-helper-mode" nil t)
(autoload 'compile "compile.el" nil t)
(autoload 'swedish-keys-mode "swedkey.el" nil t)
(autoload 'wormy "wormy" nil t)

(autoload 'vm "vm" "Start VM on your primary inbox." t)
(autoload 'vm-other-frame "vm" "Like `vm' but starts in another frame." t)
(autoload 'vm-visit-folder "vm" "Start VM on an arbitrary folder." t)
(autoload 'vm-visit-virtual-folder "vm" "Visit a VM virtual folder." t)
(autoload 'vm-mode "vm" "Run VM major mode on a buffer" t)
(autoload 'vm-mail "vm" "Send a mail message using VM." t)
(autoload 'vm-mime-encode-composition "vm-mime" "MIME encode the current mail composition buffer." t)

(autoload 'mc-install-write-mode "mailcrypt" nil t)
(autoload 'mc-install-read-mode "mailcrypt" nil t)

(if (string-equal (user-login-name) "che")
    (progn
      (autoload 'ludd "luddkom" nil t)
      (autoload 'koms "luddkom" nil t)
      (autoload 'lys "luddkom" nil t)
      (autoload 'ender "luddkom" nil t)
      (autoload 'ham "luddkom" nil t)
      (autoload 'sdf "luddkom" nil t)))
