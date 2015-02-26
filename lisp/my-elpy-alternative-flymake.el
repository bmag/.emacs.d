;;;;;;;;;;;;;;;;;;;
;;; Module: My:Flymake

(defvar my:elpy-flymake-command "pyflakes3"
  "Checker command to use with flymake.")

(defvar my:elpy-flymake-extra-arguments '()
  "Extra arguments for flymake's checker command.")

(defun my:elpy-module-flymake (command &rest args)
  "Enable Flymake support for Python."
  (pcase command
    (`global-init
     (require 'flymake)
     (elpy-modules-remove-modeline-lighter 'flymake-mode)

     ;; Add our initializer function
     (add-to-list 'flymake-allowed-file-name-masks
                  '("\\.py\\'" my:elpy-flymake-python-init)))
    (`buffer-init
     ;; `flymake-no-changes-timeout': The original value of 0.5 is too
     ;; short for Python code, as that will result in the current line
     ;; to be highlighted most of the time, and that's annoying. This
     ;; value might be on the long side, but at least it does not, in
     ;; general, interfere with normal interaction.
     (set (make-local-variable 'flymake-no-changes-timeout)
          60)

     ;; `flymake-start-syntax-check-on-newline': This should be nil for
     ;; Python, as;; most lines with a colon at the end will mean the
     ;; next line is always highlighted as error, which is not helpful
     ;; and mostly annoying.
     (set (make-local-variable 'flymake-start-syntax-check-on-newline)
          nil)

     ;; Enable warning faces for flake8 output.
     ;; COMPAT: Obsolete variable as of 24.4
     (if (boundp 'flymake-warning-predicate)
         (set (make-local-variable 'flymake-warning-predicate) "^W[0-9]")
       (set (make-local-variable 'flymake-warning-re) "^W[0-9]"))

     (flymake-mode 1))
    (`buffer-stop
     (flymake-mode -1)
     (kill-local-variable 'flymake-no-changes-timeout)
     (kill-local-variable 'flymake-start-syntax-check-on-newline)
     ;; COMPAT: Obsolete variable as of 24.4
     (if (boundp 'flymake-warning-predicate)
         (kill-local-variable 'flymake-warning-predicate)
       (kill-local-variable 'flymake-warning-re)))))

(defun my:elpy-flymake-python-init ()
  ;; Make sure it's not a remote buffer as flymake would not work
  (when (not (file-remote-p buffer-file-name))
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace)))
      (list my:elpy-flymake-command
	    (append my:elpy-flymake-extra-arguments (list temp-file))))))

(provide 'my-elpy-alternative-flymake)
