;; Use cperl mode instead of the default perl mode
(defalias 'perl-mode 'cperl-mode)
 
;; Use 4 space indents via cperl mode
(custom-set-variables
 ;; Indentation
 '(cperl-indent-level 4)
 '(cperl-brace-offset 0)
 '(cperl-continued-brace-offset 0)
 '(cperl-label-offset 0)
 '(cperl-continued-statement-offset 0)
 '(cperl-close-paren-offset -4)
 '(cperl-indent-parens-as-block t)
 
 ;; auto
 '(cperl-electric-parens nil)
 '(cperl-electric-keywords nil)
 '(cperl-auto-newline nil)
 '(cperl-electic-linefeed t)
 '(cperl-electric-lbrace nil)
 '(cperl-hairy nil)
 ;; other
 '(cperl-clobber-lisp-bindings nil)
 )

;(add-hook 'cperl-mode-hook
;          (lambda ()
;            (define-abbrev-table 'cperl-mode-abbrev-table
;              '(
;                ("for" "formy" cperl-electric-keyword)
;                ))))
;
;
 
;; Insert spaces instead of tabs
(setq-default indent-tabs-mode nil)
