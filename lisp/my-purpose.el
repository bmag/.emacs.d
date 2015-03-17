;; general purpose configuration

(setq purpose-default-layout-file (concat user-emacs-directory "/purpose-layouts/"))
(add-to-list 'purpose-user-mode-purposes '(Custom-mode . custom))
(add-to-list 'purpose-user-mode-purposes '(clojure-mode . clojure))
(add-to-list 'purpose-user-mode-purposes '(cider-repl-mode . cider))
(purpose-compile-user-configuration)
;; (setq split-width-threshold 120)
;; (setq split-height-threshold 40)
(purpose-mode)
;; (setq purpose-message-on-p t)

(require 'purpose-x)
(global-set-key (kbd "C-x 1")
		(define-purpose-prefix-overload my:delete-windows
		  '(delete-other-windows purpose-delete-non-dedicated-windows)))
(global-set-key (kbd "C-c b") #'purpose-switch-buffer-with-purpose)
(global-set-key (kbd "C-c 1") #'purpose-delete-non-dedicated-windows)


;; special customizations

(defun my-layout-filename (name)
  "Return full filename for layout NAME"
  (concat purpose-default-layout-file name))

(defun my-packages-persp (&optional arg)
  "Open perspective for installing packages in current frame.
With prefix argument, open perspective in new frame."
  (interactive "P")
  (when arg
    (select-frame-set-input-focus (make-frame-command)))
  (purpose-load-window-layout (my-layout-filename "packages.window-layout"))
  (package-list-packages-no-fetch))
(define-key my-keymap (kbd "p p") #'my-packages-persp)

(add-hook 'after-init-hook #'(lambda ()
			       (purpose-load-window-layout
				(my-layout-filename "edit.window-layout"))))

(defun my-clojure-persp ()
  (interactive)
  (purpose-load-window-layout (my-layout-filename "clojure.window-layout")))
(define-key my-keymap (kbd "p c") #'my-clojure-persp)


;; don't let cider use "C-c ," since it clashes with purpose
;; instead of:
;; - "C-c ," for cider-test-run-tests
;; - "C-c C-," for cider-test-rerun-tests
;; we get:
;; - "C-c C-," for cider-test-run-tests
;; - "C-u C-c C-," for cider-test-rerun-tests
(with-eval-after-load 'cider-mode
  (define-key cider-mode-map (kbd "C-c ,") nil)
  (define-key cider-mode-map (kbd "C-c C-,")
    (define-purpose-prefix-overload cider-test-run-overload
      '(cider-test-run-tests cider-test-rerun-tests))))

;; make helm behave nicely when there are several windows in the frame

(defun my-helm-display-function (buffer &optional alist)
  (let ((purpose-display-at-bottom-height 0.5))
    (pop-to-buffer buffer '(purpose-display-at-bottom . nil))))

(defun my-sync-helm-and-purpose ()
  (if purpose-mode
      (setq helm-display-function #'my-helm-display-function)
    (setq helm-display-function #'helm-default-display-buffer)))

(my-sync-helm-and-purpose)
(add-hook 'purpose-mode-hook #'my-sync-helm-and-purpose)

(provide 'my-purpose)
