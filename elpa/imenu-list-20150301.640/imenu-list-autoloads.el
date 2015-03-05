;;; imenu-list-autoloads.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads (imenu-list-minor-mode imenu-list imenu-list-noselect)
;;;;;;  "imenu-list" "imenu-list.el" (21747 15290 536684 393000))
;;; Generated autoloads from imenu-list.el

(autoload 'imenu-list-noselect "imenu-list" "\
Update and show the imenu-list buffer, but don't select it.
If the imenu-list buffer doesn't exist, create it.

\(fn)" t nil)

(autoload 'imenu-list "imenu-list" "\
Update and show the imenu-list buffer.
If the imenu-list buffer doesn't exist, create it.

\(fn)" t nil)

(defvar imenu-list-minor-mode nil "\
Non-nil if Imenu-List minor mode is enabled.
See the command `imenu-list-minor-mode' for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `imenu-list-minor-mode'.")

(custom-autoload 'imenu-list-minor-mode "imenu-list" nil)

(autoload 'imenu-list-minor-mode "imenu-list" "\
Toggle Imenu-List minor mode on or off.
With a prefix argument ARG, enable Imenu-List minor mode if ARG is
positive, and disable it otherwise.  If called from Lisp, enable
the mode if ARG is omitted or nil, and toggle it if ARG is `toggle'.
\\{imenu-list-minor-mode-map}

\(fn &optional ARG)" t nil)

;;;***

;;;### (autoloads nil nil ("imenu-list-pkg.el") (21747 15290 695647
;;;;;;  463000))

;;;***

(provide 'imenu-list-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; imenu-list-autoloads.el ends here
