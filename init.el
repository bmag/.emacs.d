(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("melpa" . "http://melpa.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")))

(package-initialize)

(add-to-list 'load-path (format "%s%s" user-emacs-directory "lisp/"))


;; provide `with-eval-after-load' for old Emacsen that don't have it
(unless (fboundp 'with-eval-after-load)
  ;; this macro was taken from Emacs' source code
  (defmacro with-eval-after-load (file &rest body)
    "Execute BODY after FILE is loaded.
FILE is normally a feature name, but it can also be a file name,
in case that file does not provide any feature."
    (declare (indent 1) (debug t))
    `(eval-after-load ,file (lambda () ,@body))))

(defmacro eval-if-require (feature &rest body)
  "Try to `require' FEATURE, execute BODY if successful."
  `(when (require ,feature nil t)
     ,@body))


;;; --- UI ---

;; IDO
(ido-mode 1)
(ido-everywhere 1)
(setq ido-enable-flex-matching 1)

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

(setq recentf-max-saved-items 50)
(setq recentf-max-menu-items 20)
(recentf-mode 1)
(global-set-key (kbd "C-x C-r") #'ido-recentf-open)

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

;; editing
(global-set-key (kbd "C-z") #'undo)
(global-set-key (kbd "<f9>") #'compile)
(global-set-key (kbd "C-<f9>") #'find-grep)
(setq-default require-final-newline t)

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
 '(default ((t (:inherit nil :stipple nil :background "black" :foreground "white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 113 :width normal :foundry "unknown" :family "DejaVu Sans Mono"))))
 '(cursor ((t (:background "dark red"))))
 '(font-lock-comment-face ((t (:foreground "green"))))
 '(font-lock-function-name-face ((t (:foreground "yellow"))))
 '(minibuffer-prompt ((t (:foreground "green"))))
 '(region ((t (:background "blue4"))))
 '(show-paren-match ((t (:background "midnight blue")))))



;;; --- UI plugins ---

;; company
(global-company-mode 1)
(setq-default company-idle-delay 0)

;; yasnippet
(yas-global-mode 1)

;; iedit
(global-set-key (kbd "C-;") #'iedit-mode)

;; ace-jump
(with-eval-after-load 'ace-jump-mode
  (ace-jump-mode-enable-mark-sync))
(global-set-key (kbd "C-c SPC") #'ace-jump-mode)
(global-set-key (kbd "C-x SPC") #'ace-jump-mode-pop-mark)

;; smex
(global-set-key (kbd "M-x") #'smex)			; all commands
(global-set-key (kbd "M-X") #'smex-major-mode-commands) ; only major mode's commands
(global-set-key (kbd "C-c M-x") #'execute-extended-command) ; old M-x


(with-eval-after-load 'flx-ido
  (defun toggle-flx-ido-advice (function &rest args)
    "Call FUNCTION with ARGS and `flx-ido-mode' toggled."
    (unwind-protect
	(progn (flx-ido-mode (if flx-ido-mode -1 1))
	       (apply function args))
      (flx-ido-mode (if flx-ido-mode -1 1))))

  ;; (with-eval-after-load 'smex
  ;;   (when (fboundp 'advice-add)
  ;;     (advice-add 'smex :around #'toggle-flx-ido-advice)
  ;;     (advice-add 'smex-major-mode-commands :around #'toggle-flx-ido-advice)))
  )

;; powerline
(require 'powerline)
(set-face-attribute 'mode-line nil
		    :background "sky blue"
		    :foreground "black"
		    :box nil)
(set-face-attribute 'powerline-active1 nil
		    :background "grey22"
		    :foreground "sky blue")
(set-face-attribute 'powerline-active2 nil
		    :background "grey40"
		    :foreground "grey90")
(powerline-default-theme)
(powerline-reset)

;; hydra
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
  ("q" nil "quit"))



;;; --- Programming ---

;; Python
(require 'my-python)

(with-eval-after-load 'flycheck
  (flycheck-package-setup)
  (setq flycheck-emacs-lisp-load-path 'inherit))

;; Emacs-Lisp
(add-hook 'emacs-lisp-mode-hook #'(lambda () (eldoc-mode 1)))
(add-hook 'emacs-lisp-mode-hook #'(lambda () (paredit-mode 1)))
(define-key emacs-lisp-mode-map (kbd "C-c C-j") #'idomenu)
(define-key emacs-lisp-mode-map (kbd "<f8>") #'eval-buffer)

(with-eval-after-load 'paredit
  (define-key paredit-mode-map (kbd "[") #'paredit-open-round)
  (define-key paredit-mode-map (kbd "]") #'paredit-close-round)
  (define-key paredit-mode-map (kbd "(") #'paredit-open-square)
  (define-key paredit-mode-map (kbd ")") #'paredit-close-square))

;; C
(add-hook 'c-mode-hook #'(lambda () (semantic-mode 1)))
(add-hook 'c-mode-hook #'(lambda () (semantic-idle-summary-mode 1)))
(with-eval-after-load 'cc-mode
  (define-key c-mode-map (kbd "M-<return>") #'semantic-ia-fast-jump)
  (define-key c-mode-map (kbd "C-c C-j") #'idomenu))

;; Common Lisp
(setq inferior-lisp-program "sbcl")



;;; Purpose
(add-to-list 'load-path "~/emacs-purpose/")
(require 'purpose)
(setq purpose-default-layout-file (concat user-emacs-directory "/purpose-layouts/"))
(setq split-width-threshold 120)
(setq split-height-threshold 40)
(purpose-mode)

(add-to-list 'load-path "~/emacs-purpose/extensions/")
(require 'pu-ext-dired-ibuffer)


