(defvar my:elpy-check-command "pylint"
  "Command used to check python files.")

(defvar my:elpy-check-extra-args "--msg-template='{path}:{line}: [{msg_id}({symbol}), {obj}] {msg}'"
  "Extra arguments for elpy's python checker command.")

(defun my:elpy-check (&optional whole-project-p)
  "Run `my:elpy-check-command' on the current buffer's file,

or the project root if WHOLE-PROJECT-P is non-nil (interactively,
with a prefix argument)."
  (interactive "P")
  (when (not (buffer-file-name))
    (error "Can't check a buffer without a file."))
  (save-some-buffers (not compilation-ask-about-save) nil)
  (let ((process-environment (python-shell-calculate-process-environment))
        (exec-path (python-shell-calculate-exec-path))
        (file-name-or-directory (expand-file-name
                                 (if whole-project-p
                                     (or (elpy-project-root)
                                         (buffer-file-name))
                                   (buffer-file-name))))
        (extra-args (if whole-project-p
                        (concat " --exclude="
                                (mapconcat #'identity
                                           elpy-project-ignored-directories
                                           ","))
                      "")))
    (compilation-start (concat my:elpy-check-command
                               " "
			       my:elpy-check-extra-args
			       " "
                               (shell-quote-argument file-name-or-directory)
                               extra-args)
                       nil
                       (lambda (mode-name)
                         "*Python Check*"))))

(provide 'my-elpy-check)
