;; Initializations
(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives '(("org"   . "http://orgmode.org/elpa/")
                         ("gnu"   . "http://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
(package-initialize)

;; Bootstrap `use-package`
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;; PATH
(let ((path (shell-command-to-string ". ~/.bash_profile; echo -n $PATH")))
  (setenv "PATH" path)
  (setq exec-path 
        (append
         (split-string-and-unquote path ":")
         exec-path)))

;; Some term enhancement
(defadvice term-sentinel (around my-advice-term-sentinel (proc msg))
  (if (memq (process-status proc) '(signal exit))
      (let ((buffer (process-buffer proc)))
        ad-do-it
        (kill-buffer buffer))
    ad-do-it))
(ad-activate 'term-sentinel)

(defadvice ansi-term (before force-bash)
  (interactive (list "/bin/zsh")))
(ad-activate 'ansi-term)


;; Other configs
(setq make-backup-files nil)
(setq auto-save-default nil)

;; Splash Screen
(setq inhibit-startup-screen t)
(setq initial-scratch-message ";; Happy Hacking")

;; Show matching parens
(setq show-paren-delay 0)
(show-paren-mode  1)

;; Paragraph movement
(global-set-key (kbd "s-j") 'forward-paragraph)
(global-set-key (kbd "s-k") 'backward-paragraph)

;; Keybinding for term mode
(add-hook 'term-mode
          (lambda () (global-set-key (kbd "s-v") 'term-paste)))

;; OrgMode Configs
(setq org-html-validation-link nil)
(setq org-todo-keywords
      '((sequence "TODO" "WORKING" "HOLD" "|" "DONE")))
(setq org-todo-keyword-faces
      '(("TODO"    . "blue")
	("WORKING" . "yellow")
	("HOLD"    . "red")
	("DONE"    . "green")))

;; UI configurations
(scroll-bar-mode -1)
(tool-bar-mode   -1)
(tooltip-mode    -1)
(menu-bar-mode   -1)
(global-linum-mode 1)
(add-to-list 'default-frame-alist '(font . "Iosevka-11"))
(add-to-list 'default-frame-alist '(height . 24))
(add-to-list 'default-frame-alist '(width . 80))

;; Vim mode
(use-package evil
  :ensure t
  :config
  (evil-mode 1))

(use-package evil-escape
  :ensure t
  :init
  (setq-default evil-escape-key-sequence "jk")
  :config
  (evil-escape-mode 1))

;; Anzu for search matching
(use-package anzu
  :ensure t
  :config
  (global-anzu-mode 1)
  (global-set-key [remap query-replace-regexp] 'anzu-query-replace-regexp)
  (global-set-key [remap query-replace] 'anzu-query-replace))

;; Theme
(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-one t))

;; Helm
(use-package helm
  :ensure t
  :init
  (setq helm-M-x-fuzzy-match t
	helm-mode-fuzzy-match t
	helm-buffers-fuzzy-matching t
	helm-recentf-fuzzy-match t
	helm-locate-fuzzy-match t
	helm-semantic-fuzzy-match t
	helm-imenu-fuzzy-match t
	helm-completion-in-region-fuzzy-match t
	helm-candidate-number-list 80
 	helm-split-window-in-side-p t
	helm-move-to-line-cycle-in-source t
	helm-echo-input-in-header-line t
	helm-autoresize-max-height 0
	helm-autoresize-min-height 20)
  :config
  (helm-mode 1))

;; RipGrep
(use-package helm-rg :ensure t)

;; Projectile
(use-package projectile
  :ensure t
  :init
  (setq projectile-require-project-root nil)
  (setq projectile-completion-system 'ivy)
  (setq projectile-indexing-method 'alien)
  :config
  (projectile-mode 1))

;; Helm Projectile
(use-package helm-projectile
  :ensure t
  :init
  (setq helm-projectile-fuzzy-match t)
  :config
  (helm-projectile-on))

;; All The Icons
(use-package all-the-icons :ensure t)

;; NeoTree
(use-package neotree
  :ensure t
  :init
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow)))

;; Which Key
(use-package which-key
  :ensure t
  :init
  (setq which-key-separator " ")
  (setq which-key-prefix-prefix "+")
  (setq which-key-popup-type 'minibuffer)
  (setq which-key-sort-order 'which-key-key-order)
  :config
  (which-key-mode))

;; Custom keybinding
(use-package general
  :ensure t
  :config (general-define-key
  :states '(normal visual insert emacs)
  :prefix "SPC"
  :non-normal-prefix "M-SPC"
  "/"   '(helm-projectile-rg :which-key "ripgrep")
  "TAB" '(switch-to-prev-buffer :which-key "previous buffer")
  "SPC" '(helm-M-x :which-key "M-x")
  "pf"  '(helm-projectile-find-file :which-key "find files")
  "pp"  '(helm-projectile-switch-project :which-key "switch project")
  "pb"  '(helm-projectile-switch-to-buffer :which-key "switch buffer")
  "pr"  '(helm-show-kill-ring :which-key "show kill ring")
  ;; Buffers
  "bb"  '(helm-mini :which-key "buffers list")
  ;; Window
  "wl"  '(windmove-right :which-key "move right")
  "wh"  '(windmove-left :which-key "move left")
  "wk"  '(windmove-up :which-key "move up")
  "wj"  '(windmove-down :which-key "move bottom")
  "w/"  '(split-window-right :which-key "split right")
  "w-"  '(split-window-below :which-key "split bottom")
  "wx"  '(delete-window :which-key "delete window")
  "qz"  '(delete-frame :which-key "delete frame")
  "qq"  '(kill-emacs :which-key "quit")
  ;; NeoTree
  "ft"  '(neotree-toggle :which-key "toggle neotree")
  ;; Others
  "at"  '(ansi-term :which-key "open terminal")
))

;; Fancy titlebar for MacOS
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))
(setq ns-use-proxy-icon  nil)
(setq frame-title-format nil)

;; Ruby
(use-package ruby-mode
  :ensure t
  :mode "\\.rb\\'"
  :mode "Rakefile\\'"
  :mode "Gemfile\\'"
  :mode "Berksfile\\'"
  :mode "Vagrantfile\\'"
  :interpreter "ruby"
  :init
  (setq ruby-indent-level 2
	ruby-indent-tabs-mode nil)
  (add-hook 'ruby-mode 'super)
  :bind
  (([(meta down)] . ruby-forward-sexp)
   ([(meta up)]   . ruby-backward-sexp)
   (("C-c C-e"    . ruby-send-region)))) ;;Rebind since Rubocop uses C-c C-r

;; RVM Integration
(use-package rvm
  :ensure t
  :config
  (rvm-use-default))

;; Ruby REPL
(use-package inf-ruby
  :ensure t
  :init
  (add-hook 'ruby-mode-hook 'inf-ruby-minor-mode))

;; Smart Parens
(use-package smartparens
  :ensure t
  :diminish(smartparens-mode . "()")
  :init
  (use-package smartparens-ruby)
  (add-hook 'ruby-mode-hook 'smartparens-strict-mode))

;; Rubocop for lint-like style checker for Ruby
(use-package rubocop
  :ensure t
  :init
  (add-hook 'ruby-mode-hook 'rubocop-mode)
  :diminish rubocop-mode)

;; Robe code assistance
;;(use-package robe
;; :ensure t
 ;; :bind("C-r-j" .robe-jump)
  ;;:init
  ;;(add-hook 'ruby-mode-hook 'robe-mode)
  ;;:config
  ;;(defadvice inf-ruby-console-auto
   ;;   (before activate-rvm-for-robe activate)
    ;;(rvm-activate-corresponding-ruby)))

;; Robe with company
;;(use-package company
 ;; :no-require t
  ;;:config
  ;;(push 'company-robe company-backends))



;; Web modes for dealing with html and lang templates
(use-package web-mode
  :ensure t
  :mode "\\.erb\\'")


;; Flycheck
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;; LSP
(use-package lsp-mode
  :ensure t
  :init
  (add-hook 'prog-major-mode #'lsp-prog-major-mode-enable))

(use-package lsp-ui
  :ensure t
  :init
  (add-hook 'lsp-mode-hook 'lsp-ui-mode))

;; Company mode
(use-package company
:ensure t
:init
(setq company-minimum-prefix-length 3)
(setq company-auto-complete nil)
(setq company-idle-delay 0)
(setq company-require-match 'never)
(setq company-frontends
  '(company-pseudo-tooltip-unless-just-one-frontend
    company-preview-frontend
    company-echo-metadata-frontend))
(setq tab-always-indent 'complete)
(defvar completion-at-point-functions-saved nil)
:config
(global-company-mode 1)
(define-key company-active-map (kbd "TAB") 'company-complete-common-or-cycle)
(define-key company-active-map (kbd "<tab>") 'company-complete-common-or-cycle)
(define-key company-active-map (kbd "S-TAB") 'company-select-previous)
(define-key company-active-map (kbd "<backtab>") 'company-select-previous)
(define-key company-mode-map [remap indent-for-tab-command] 'company-indent-for-tab-command)
(defun company-indent-for-tab-command (&optional arg)
  (interactive "P")
  (let ((completion-at-point-functions-saved completion-at-point-functions)
    	(completion-at-point-functions '(company-complete-common-wrapper)))
	(indent-for-tab-command arg)))

(defun company-complete-common-wrapper ()
	(let ((completion-at-point-functions completion-at-point-functions-saved))
	(company-complete-common))))

(use-package company-lsp
:ensure t
:init
(push 'company-lsp company-backends))
 
;; Powerline
(use-package spaceline
  :ensure t
  :init
  (setq powerline-default-separator 'arrow)
  :config
  (spaceline-emacs-theme)
  (spaceline-toggle-minor-modes-off)
  (spaceline-toggle-buffer-size-off)
  (spaceline-toggle-evil-state-on))

;;;;;;;;;;;;;;;;;;;;;;;
;; Language Supports ;;
;;;;;;;;;;;;;;;;;;;;;;;
 
;; JavaScript
(use-package js2-mode
  :ensure t
  :init
  (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode)))
(use-package tern :ensure t)

;; Rust
(use-package rust-mode
  :ensure t
  :init
  (add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode)))

;(use-package lsp-rust
  ;:ensure t
  ;:init
  ;(setq lsp-rust-rls-command '("rustup" "run" "nightly" "rls"))
  ;(add-hook 'rust-mode-hook #'lsp-rust-enable)
  ;(add-hook 'rust-mode-hook #'flycheck-mode))

 ;; Typescript
(use-package typescript-mode
  :ensure t
  :init
  (add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode)))

;; LSP for JavaScript and TypeScript
;(use-package lsp-javascript-typescript
  ;:ensure t
  ;:init
  ;(add-to-list 'js-mode-hook #'lsp-javascript-typescript-enable)
  ;(add-to-list 'typescript-mode-hook #'lsp-javascript-typescript-enable))
 
 ;; Auto-generated

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(anzu-cons-mode-line-p nil)
 '(mouse-wheel-progressive-speed nil)
 '(mouse-wheel-scroll-amount (quote (1 ((shift) . 5) ((control)))))
 '(package-selected-packages
   (quote
    (fontawesome font-utils all-the-icons-gnus all-the-icons-dired all-the-icons-ivy company-lsp emojify web-mode tide tss doom-modeline quickrun org-bullets lsp-ui flycheck-rust spaceline-all-the-icons spaceline flycheck-inline lsp-rust f lsp-mode rust-mode pdf-tools company js2-mode diff-hl editorconfig general which-key helm doom-themes evil use-package)))
 '(send-mail-function (quote smtpmail-send-it)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#212121" :foreground "#eeffff" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 110 :width normal :foundry "nil" :family "Iosevka"))))
 '(font-lock-constant-face ((t (:foreground "#C792EA"))))
 '(font-lock-keyword-face ((t (:foreground "#2BA3FF" :slant italic))))
 '(font-lock-preprocessor-face ((t (:inherit bold :foreground "#2BA3FF" :slant italic :weight normal))))
 '(font-lock-string-face ((t (:foreground "#C3E88D"))))
 '(font-lock-type-face ((t (:foreground "#FFCB6B"))))
 '(font-lock-variable-name-face ((t (:foreground "#FF5370"))))
 '(helm-rg-active-arg-face ((t (:foreground "LightGreen"))))
 '(helm-rg-file-match-face ((t (:foreground "LightGreen" :underline t))))
 '(helm-rg-preview-line-highlight ((t (:background "LightGreen" :foreground "black"))))
 '(mode-line ((t (:background "#191919" :box nil))))
 '(mode-line-inactive ((t (:background "#282828" :foreground "#5B6268" :box nil))))
 '(term ((t (:foreground "#fafafa")))))
