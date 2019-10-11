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

;; Load Org configs
(org-babel-load-file (expand-file-name "~/.emacs.d/basic.org"))
(org-babel-load-file (expand-file-name "~/.emacs.d/ui.org"))
(org-babel-load-file (expand-file-name "~/.emacs.d/org-mode.org"))
(org-babel-load-file (expand-file-name "~/.emacs.d/whichkey.org"))
(org-babel-load-file (expand-file-name "~/.emacs.d/company-mode.org"))
(org-babel-load-file (expand-file-name "~/.emacs.d/custom-keys.org"))
(org-babel-load-file (expand-file-name "~/.emacs.d/vim.org"))
(org-babel-load-file (expand-file-name "~/.emacs.d/projectile.org"))
(org-babel-load-file (expand-file-name "~/.emacs.d/neotree.org"))
(org-babel-load-file (expand-file-name "~/.emacs.d/ruby.org"))
(org-babel-load-file (expand-file-name "~/.emacs.d/javascript.org"))

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
    (evil-magit dashboard fontawesome font-utils all-the-icons-gnus all-the-icons-dired all-the-icons-ivy company-lsp emojify web-mode tide tss doom-modeline quickrun org-bullets lsp-ui flycheck-rust spaceline-all-the-icons spaceline flycheck-inline lsp-rust f lsp-mode rust-mode pdf-tools company js2-mode diff-hl editorconfig general which-key helm doom-themes evil use-package)))
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
(put 'dired-find-alternate-file 'disabled nil)
