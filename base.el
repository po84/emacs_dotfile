;;; package --- Summary
;;; my dotfile

;;; Commentary:

;;; Code:
;; Install use-package
(require 'package)
(setq package-enable-at-startup nil)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")))
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (add-to-list 'package-archives (cons "marmalade" (concat proto "://marmalade-repo.org/packages/"))))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))
(defvar exec-path-from-shell-check-startup-files)
(setq exec-path-from-shell-check-startup-files nil)

(use-package exec-path-from-shell
    :ensure
    :config (exec-path-from-shell-initialize))
(require 'use-package)

;; Emacs starts out with a black buffer
(setq inhibit-splash-screen t
      initial-scratch-message nil)

;; Turn dinging off
(setq visible-bell nil)
(setq ring-bell-function 'ignore)
(setq-default tab-width 4)
(display-line-numbers-mode t)

;; Turn off menu bar, tool bar, and scroll bar
(if window-system (scroll-bar-mode -1))
(tool-bar-mode -1)
(menu-bar-mode -1)

;; Backup files setup
(setq
  backup-by-copying t      ; don't clobber symlinks
  backup-directory-alist
  `((".*" . ,temporary-file-directory)) ; don't litter my fs tree
  delete-old-versions t
  kept-new-versions 6
  kept-old-versions 2
  version-control t)       ; use versioned backups

;; For :diminish
;; removing/abbreviating minor mode indicators in modeline
(use-package diminish :ensure)

;; For :delight
;; customizing major/minor modes appearance in modeline
(use-package delight :ensure)

;; Load custom theme - Spacemacs-dark
(use-package spacemacs-common
 :ensure spacemacs-theme
 :config (load-theme 'spacemacs-dark t))
;; (use-package challenger-deep-theme
;;   :ensure)
;; (use-package cyberpunk-theme
;;   :ensure)
;; Customize the modeline
;; (use-package spaceline-config
;;  :ensure spaceline
;;  :config (spaceline-spacemacs-theme))


;; magit
(use-package magit :ensure)

(use-package projectile
  :ensure
  :delight '(:eval (concat " " (projectile-project-name)))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :config
  (projectile-mode 1))

;; ;; treemacs
;; (use-package treemacs
;;   :ensure
;;   :defer
;;   :init
;;   (with-eval-after-load 'winum
;; 	(define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
;;   :bind
;;   (:map global-map
;; 		("M-0" . treemacs-select-window)
;; 		("C-x t 1" . treemacs-delete-other-window)
;; 		("C-x t t" . treemacs)
;; 		("C-x t C-t" . treemacs-find-file)))

;; (use-package treemacs-magit
;;   :after treemacs magit
;;   :ensure)

;; flycheck
(use-package flycheck
  :ensure
  :diminish flycheck-mode
  :init (global-flycheck-mode))

;; company
(defvar comapny-idle-delay)
(defvar company-minimum-prefix-length)
(use-package company
  :ensure
  :diminish company-mode
  :config
  (setq comapny-idle-delay 0)
  (setq company-minimum-prefix-length 1)
  (push 'company-robe company-backends))

;; helm
(defvar helm-find-files-map)
(defvar helm-buffer-max-length)
(use-package helm
  :ensure
  :demand
  :diminish helm-mode
  :bind (("M-x" . helm-M-x)
		 ("M-y" . helm-show-kill-ring)
		 ("C-x b" . helm-mini)
		 ("C-x C-f" . helm-find-files)
		 :map helm-find-files-map
		 ("C-<tab>" . helm-execute-persistent-action)
		 ("C-<backspace>" . helm-find-files-up-one-level))
  :config
  (helm-mode 1)
  (setq helm-buffer-max-length 30))

;; JS
(use-package js2-mode
  :ensure
  :hook (js-mode . js2-minor-mode)
  :config
  (setq js2-basic-offset 2))

(defun setup-tide-mode()
  "Setup function for tide."
  (interactive)
  (tide-setup)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (company-mode +1))

(use-package tide
  :ensure
  :diminish tide-mode
  :hook ((js-mode . setup-tide-mode)
		 (before-save . tide-format-before-save)))

;; ruby
(use-package ruby-mode
  :ensure
  :mode "\\.rb\\'"
  :mode "Rakefile\\'"
  :mode "Gemfile\\'"
  :interpreter "ruby"
  :init
  (setq ruby-indent-level 2
		ruby-indent-tabs-mode nil)
  :bind
  (([(meta down)] . ruby-forward-sexp)
   ([(meta up)] . ruby-backward-sexp)
   (("C-c C-e" . ruby-send-region))))

;; web/templates
(use-package web-mode
  :ensure
  :mode "\\.erb\\'")

;; rvm
(use-package rvm
  :ensure
  :config
  (rvm-use-default))

;; Ruby REPL
(use-package inf-ruby
  :ensure
  :hook (ruby-mode . inf-ruby-minor-mode))

;; ruby linting
(use-package rubocop
  :ensure
  ;; :diminish rubocop-mode
  :hook (ruby-mode . rubocop-mode))

;; (use-package robe
;;   :ensure
;;   :bind ("C-M-." . robe-jump)
;;   :hook (ruby-mode . robe-mode)
;;   :config
;;   (defadvice inf-ruby-console-auto
;; 	  (before activate-rvm-for-roby-activate)
;; 	(rvm-activate-corresponding-ruby)))

(use-package ruby-tools
  :ensure
  ;; :diminish ruby-tools-mode
  :hook (ruby-mode . ruby-tools-mode))



;; go
;; need to install gopls with `go get golang.org/x/tools/gopls@latest`
(use-package go-mode
  :ensure
  :diminish eldoc-mode
  :mode "\\.go\\'")

;; lsp-mode
(use-package lsp-mode
  :ensure
  :init (setq lsp-keymap-prefix (kbd "C-c l"))
  :commands (lsp lsp-deferred)
  :hook ((go-mode ruby-mode) . lsp-deferred))

(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

(use-package lsp-ui
  :ensure
  :commands lsp-ui-mode)

(use-package company-lsp
  :ensure
  :commands company-lsp)

(use-package yasnippet
  :ensure
  :diminish yas-minor-mode
  :commands yas-minor-mode
  :hook ((go-mode . yas-minor-mode)
		 (js-mode . yas-minor-mode)
		 (ruby-mode . yas-minor-mode)))

(use-package yasnippet-snippets :ensure)

(use-package which-key
  :ensure
  :diminish which-key-mode
  :config
  (which-key-mode))

;;; init.el ends here
