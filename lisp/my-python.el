(require 'elpy)

;; use flymake with pyflakes3. works with other checkers as well, by changing
;; `my:elpy-flymake-command' and `my:elpy-flymake-extra-arguments'
(require 'my-elpy-alternative-flymake)
(delete 'elpy-module-flymake elpy-modules)
(add-to-list 'elpy-modules 'my:elpy-module-flymake)
(add-hook 'elpy-mode-hook #'(lambda () (setq flymake-no-changes-timeout 10)))

;; use flycheck instead of flymake
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (setq elpy-modules (delq 'my:elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook #'(lambda () (flycheck-mode 1))))

;; use Pylint instead of flake8
(require 'my-elpy-check)
(define-key elpy-mode-map [remap elpy-check] #'my:elpy-check)

(setq my:elpy-check-command "pylint")
(setq my:elpy-check-extra-args "--msg-template='{path}:{line}: [{msg_id}({symbol}), {obj}] {msg}'")

(setq elpy-rpc-backend "jedi")
(setq elpy-rpc-python-command "python3")

;; IPython
(elpy-use-ipython)
(setq
 python-shell-interpreter "ipython3"
 python-shell-interpreter-args ""
 python-shell-prompt-regexp "In \\[[0-9]+\\]: "
 python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "
 python-shell-completion-setup-code 
 "from IPython.core.completerlib import module_completion"
 python-shell-completion-module-string-code
 "';'.join(module_completion('''%s'''))\n"
 python-shell-completion-string-code
 "';'.join(get_ipython().Completer.all_completions('''%s'''))\n")

(elpy-enable)

(provide 'my-python)
