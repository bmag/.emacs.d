(setq inhibit-startup-screen t)

(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("melpa" . "http://melpa.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")))

(package-initialize)
;; (unless (package-installed-p 'use-package)
;;   (package-refresh-contents)
;;   (package-install 'use-package))
;; (require 'use-package)

;; used packages:
;; ace-jump-mode
;; cider
;; clojure-mode
;; comapny
;; company-quickhelp
;; elpy
;; flycheck
;; flycheck-package
;; helm
;; hydra
;; idomenu
;; ido-vertical
;; iedit
;; imenu-list
;; paredit
;; powerline
;; purpose
;; rainbow-delimiters
;; smex
;; undo-tree
;; yasnippet

;; installed but unconfigured packages:
;; ace-window
;; diminish
;; flx
;; flx-ido
;; gh-md
;; golden-ratio
;; magit
;; markdown-mode
;; projectile
;; python-pep8
;; use-package

(add-to-list 'load-path (format "%s%s" user-emacs-directory "lisp/"))


;; provide `with-eval-after-load' for old Emacsen that don't have it
(unless (fboundp 'with-eval-after-load)
  ;; this macro was taken from Emacs' source code, with some alteration
  ;; to work with Emacs 24.3 (and older?)
  (defmacro with-eval-after-load (file &rest body)
    "Execute BODY after FILE is loaded.
FILE is normally a feature name, but it can also be a file name,
in case that file does not provide any feature."
    ;; (declare (indent 1) (debug t))
    `(eval-after-load ,file '(progn ,@body))))

(defmacro eval-if-require (feature &rest body)
  "Try to `require' FEATURE, execute BODY if successful."
  `(when (require ,feature nil t)
     ,@body))


;;; --- UI ---

;; another user keymap
(global-set-key (kbd "<f9>") (define-prefix-command 'my-keymap))

;; IDO
(ido-mode 1)
(ido-everywhere 1)
(setq ido-enable-flex-matching 1)

;; y/n questions everywhere
(defalias 'yes-or-no-p #'y-or-n-p)

;; ibuffer
(global-set-key (kbd "C-x C-b") #'ibuffer-list-buffers)

;; recentf
(defun ido-recentf-open (&optional arg)
  "Use `ido-completing-read' to \\[find-file] a recent file. With prefix
argument, use `recentf-open-files' instead."
  (interactive "P")
  (if arg
      (recentf-open-files)
    (find-file (ido-completing-read "Find recent file: " recentf-list))))

(defun my-recentf ()
  (interactive)
  (cond (ido-mode (call-interactively #'ido-recentf-open))
	(helm-mode (call-interactively #'helm-recentf))
	(t (call-interactively #'recentf-open-files))))

(setq recentf-max-saved-items 50)
(setq recentf-max-menu-items 20)
(recentf-mode 1)
(global-set-key (kbd "C-x C-r") #'my-recentf)

;; buffer switching
(defun switch-to-other-buffer ()
  (interactive)
  (switch-to-buffer (other-buffer)))

(global-set-key (kbd "<f6>") #'switch-to-other-buffer)
(global-set-key (kbd "<pause>") #'(lambda () (interactive) (kill-buffer (current-buffer))))

;; man
(global-set-key (kbd "<S-f1>") #'man)

;; scrolling
(global-set-key (kbd "M-<up>") #'scroll-down-line)
(global-set-key (kbd "M-<down>") #'scroll-up-line)

;; comint and shells
(global-set-key (kbd "<f1>") #'shell)
(add-hook 'comint-mode-hook
	  #'(lambda ()
	      (define-key comint-mode-map (kbd "M-p")
		#'comint-previous-matching-input-from-input)
	      (define-key comint-mode-map (kbd "M-n")
		#'comint-next-matching-input-from-input)))

;; view
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-linum-mode 1)
(column-number-mode 1)
(blink-cursor-mode -1)

(show-paren-mode 1)
(setq show-paren-style 'expression)
(global-hl-line-mode 1)

;; editing
(global-set-key (kbd "C-z") #'undo)
(global-set-key (kbd "C-<f9>") #'find-grep)
(global-set-key (kbd "M-/") #'hippie-expand)
(setq hippie-expand-try-functions-list '(try-expand-dabbrev
					 try-expand-dabbrev-all-buffers
					 try-expand-dabbrev-from-kill
					 try-complete-lisp-symbol-partially
					 try-complete-lisp-symbol
					 try-complete-file-name-partially
					 try-complete-file-name
					 try-expand-all-abbrevs
					 try-expand-list
					 try-expand-line))
(setq-default require-final-newline t)

;; taken from `elpy-open-and-indent-line-below'
(defun my:newline-and-indent-below ()
  "Open a line below the current one, move there, and indent."
  (interactive)
  (move-end-of-line 1)
  (newline-and-indent))
(global-set-key (kbd "C-o") #'my:newline-and-indent-below)


;; electric
(electric-pair-mode 1)
(electric-indent-mode 1)

;; movement
;; S-<right/left/up/down> bound to windmove-right/left/up/down
(windmove-default-keybindings)
(winner-mode)

;; colors
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "black" :foreground "white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 132 :width normal :foundry "unknown" :family "Inconsolata"))))
 '(cursor ((t (:background "dark red"))))
 '(font-lock-comment-face ((t (:foreground "green"))))
 '(font-lock-function-name-face ((t (:foreground "yellow"))))
 '(minibuffer-prompt ((t (:foreground "green"))))
 '(rainbow-delimiters-depth-2-face ((t (:foreground "green yellow"))))
 '(rainbow-delimiters-depth-3-face ((t (:foreground "sandy brown"))))
 '(rainbow-delimiters-depth-4-face ((t (:foreground "purple1"))))
 '(rainbow-delimiters-depth-5-face ((t (:foreground "LightGoldenrod1"))))
 '(rainbow-delimiters-depth-6-face ((t (:foreground "light sky blue"))))
 '(rainbow-delimiters-depth-7-face ((t (:foreground "light green"))))
 '(rainbow-delimiters-depth-8-face ((t (:foreground "goldenrod"))))
 '(rainbow-delimiters-depth-9-face ((t (:foreground "orchid"))))
 '(region ((t (:background "blue4"))))
 '(show-paren-match ((t (:background "midnight blue")))))



;;; --- UI plugins ---

;; diminish
;; (eval-if-require
;;  'diminish
;;  (diminish 'eldoc-mode)
;;  (diminish 'company-mode)
;;  (diminish 'yas-minor-mode))


;; company, company-quickhelp
(eval-if-require
 'company
 (global-company-mode 1))

(with-eval-after-load 'company
  (setq-default company-idle-delay 0)
  (eval-if-require
   'company-quickhelp
   (setq company-quickhelp-delay 1.5)
   (company-quickhelp-mode 1)))

;; YASnippet
(eval-if-require
 'yasnippet
 (yas-global-mode 1))

;; iedit
(global-set-key (kbd "C-c ;") #'iedit-mode)
(add-hook 'iedit-mode-hook #'(lambda () (global-hl-line-mode -1)))
(add-hook 'iedit-mode-end-hook #'(lambda () (global-hl-line-mode 1)))

;; ido-vertical-mode
(eval-if-require
 'ido-vertical-mode
 ;; todo: change keys in ido-common-completion-map to work
 ;; intuitively with ido-vertical
 (setq ido-vertical-define-keys nil)
 (ido-vertical-mode 1))

;; undo-tree
(eval-if-require
 'undo-tree
 (global-undo-tree-mode 1))


;; ace-jump
(autoload 'ace-jump-mode-enable-mark-sync "ace-jump-mode")
(with-eval-after-load 'ace-jump-mode
  (ace-jump-mode-enable-mark-sync))
(global-set-key (kbd "C-c SPC") #'ace-jump-mode)
(global-set-key (kbd "C-c C-SPC") #'ace-jump-mode-pop-mark)

;; smex
(global-set-key (kbd "M-x") #'smex)
(global-set-key (kbd "M-X") #'smex-major-mode-commands)
(global-set-key (kbd "C-c M-x") #'execute-extended-command)

;; (with-eval-after-load 'flx-ido
;;   (defun toggle-flx-ido-advice (function &rest args)
;;     "Call FUNCTION with ARGS and `flx-ido-mode' toggled."
;;     (unwind-protect
;; 	(progn (flx-ido-mode (if flx-ido-mode -1 1))
;; 	       (apply function args))
;;       (flx-ido-mode (if flx-ido-mode -1 1))))

;;   ;; (with-eval-after-load 'smex
;;   ;;   (when (fboundp 'advice-add)
;;   ;;     (advice-add 'smex :around #'toggle-flx-ido-advice)
;;   ;;     (advice-add 'smex-major-mode-commands :around #'toggle-flx-ido-advice)))
;;   )

;; powerline
;; (eval-if-require
;;  'powerline
;;  (set-face-attribute 'mode-line nil
;; 		     :background "sky blue"
;; 		     :foreground "black"
;; 		     :box nil)
;;  (set-face-attribute 'powerline-active1 nil
;; 		     :background "grey22"
;; 		     :foreground "sky blue")
;;  (set-face-attribute 'powerline-active2 nil
;; 		     :background "grey40"
;; 		     :foreground "grey90")
;;  (powerline-default-theme)
;;  (powerline-reset))

;; hydra
(eval-if-require
 'hydra
 (defhydra hydra-zoom (global-map "<f2>")
   "zoom"
   ("g" text-scale-increase "in")
   ("l" text-scale-decrease "out"))

 (defhydra hydra-error (global-map "M-g")
   "goto-error"
   ("f" first-error "first")
   ("n" next-error "next")
   ("p" previous-error "prev")
   ("v" recenter-top-bottom "recenter")
   ("q" nil "quit")))

;; rainbow-delimiters
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; dired-rainbow
(eval-if-require
 'dired-rainbow
 (dired-rainbow-define code "yellow" (".*\\.el")))

;; helm
(eval-if-require
 'helm
 (require 'helm-config)
 (global-set-key (kbd "C-c h") 'helm-command-prefix)
 (global-unset-key (kbd "C-x c"))
 (global-set-key (kbd "M-x")
		 #'(lambda () (interactive)
		     (call-interactively
		      (cond (helm-mode #'helm-M-x)
			    ((fboundp 'smex) #'smex)
			    (t #'execute-extended-command)))))
 (define-key helm-map (kbd "TAB") #'helm-execute-persistent-action)
 (define-key helm-map (kbd "C-z") #'helm-select-action)
 (setq helm-ff-file-name-history-use-recentf t
       ;; helm-split-window-in-side-p t
       helm-move-to-line-cycle-in-source t
       helm-ff-search-library-in-sexp t
       helm-scroll-amount 8)
 (helm-mode 1))

;; helm-company
(with-eval-after-load
 'company
 (define-key company-mode-map (kbd "C-;") #'helm-company)
 (define-key company-active-map (kbd "C-;") #'helm-company))

;;; --- Programming ---

;; Projectile
(projectile-global-mode 1)

;; Python
(require 'my-python)

;; Flycheck
(with-eval-after-load 'flycheck
  (flycheck-package-setup)
  (setq flycheck-emacs-lisp-load-path 'inherit))

;; Emacs-Lisp
(add-hook 'emacs-lisp-mode-hook #'turn-on-eldoc-mode)
(add-hook 'emacs-lisp-mode-hook #'enable-paredit-mode)
(define-key emacs-lisp-mode-map (kbd "<f8>") #'eval-buffer)
(define-key emacs-lisp-mode-map (kbd "C-c C-j") #'idomenu)

;; Clojure
(add-hook 'clojure-mode-hook #'enable-paredit-mode)
(add-hook 'cider-repl-mode-hook #'enable-paredit-mode)
;; (with-eval-after-load 'clojure-mode
;;   )

;; Paredit
(with-eval-after-load 'paredit
  (define-key paredit-mode-map (kbd "[") #'paredit-open-round)
  (define-key paredit-mode-map (kbd "]") #'paredit-close-round)
  (define-key paredit-mode-map (kbd "(") #'paredit-open-square)
  (define-key paredit-mode-map (kbd ")") #'paredit-close-square))

;; C
(with-eval-after-load 'cc-mode
  (require 'semantic)
  (define-key c-mode-map (kbd "M-<return>") #'semantic-ia-fast-jump)
  (define-key c-mode-map (kbd "C-c C-j") #'idomenu))

(add-hook 'c-mode-hook
	  #'(lambda ()
	      (semantic-mode 1)
	      (semantic-idle-summary-mode 1)))

;; Common Lisp
(setq inferior-lisp-program "sbcl")



;;; Purpose
(add-to-list 'load-path "~/emacs-purpose/")
(eval-if-require
 'purpose
 (require 'my-purpose))



;;; Prefix overload, ace-window
(add-to-list 'load-path "~/Documents/emacs/prefix-overload")
(eval-if-require
 'prefix-overload
 (define-prefix-overload my-ace-window
   '(ace-select-window
     ace-swap-window
     ace-delete-window))
 (global-set-key (kbd "C-c -") #'my-ace-window))

(put 'narrow-to-region 'disabled nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (windata use-package undo-tree spinner smex python-pep8 projectile powerline popup-switcher paredit magit imenu-list iedit ido-vertical-mode hydra golden-ratio flycheck-package flx-ido f elpy deferred company-quickhelp ace-window ace-jump-mode))))
