;; init.el --- Emacs configuration

;; INSTALL PACKAGES
;; --------------------------------------
(require 'package)

(setq native-comp-async-report-warnings-errors nil)

(setq package-archives
      '(("elpy" . "http://jorgenschaefer.github.io/packages/")
        ("melpa" . "https://melpa.org/packages/")
        ("gnu" . "http://elpa.gnu.org/packages/")
        ("melpa-stable" . "https://stable.melpa.org/packages/")))
;;("gnu-devel" . "https://elpa.gnu.org/devel/")))

(package-initialize)

;; To copy path when initialized in the deamon mode
(when (daemonp)
  (exec-path-from-shell-initialize))

(when (not package-archive-contents)
  (package-refresh-contents))

(defvar myPackages
  '(flycheck
    ;; material-theme
    solarized-theme
    ;; py-autopep8
    projectile
    helm
    web-mode
    rjsx-mode
    helm-projectile
    magit
    pyvenv
    nov
    go-mode))

(menu-bar-mode -1)
;; (display-time-mode t)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(setq backup-directory-alist '(("." . "~/.backups/emacs")))
(require 'use-package)

(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      myPackages)

;; BASIC CUSTOMIZATION
;; --------------------------------------

(toggle-frame-maximized) ;; maximize the frame
;; (toggle-frame-fullscreen) ;; maximize the window

(setq inhibit-startup-message t) ;; hide the startup message
;; (load-theme 'solarized-zenburn t)
;; (load-theme 'material t) ;; load material theme
;; (global-linum-mode t) ;; enable line numbers globally
(setq linum-format "%d ")
(column-number-mode 1)

;; use flycheck not flymake with elpy
;; (when (require 'flycheck nil t)
;;   (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
;;   (add-hook 'elpy-mode-hook 'flycheck-mode))

;; (require 'py-autopep8)
;; (add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

(projectile-mode t)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(helm-mode t)

(setq projectile-completion-system 'helm
      projectile-switch-project-action 'helm-projectile)


(require 'rjsx-mode)
(add-to-list 'auto-mode-alist '("\\.js\\'" . rjsx-mode))

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))

(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
)
(add-hook 'web-mode-hook  'my-web-mode-hook)

(require 'nov)
(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))

;; ;; (setq web-mode-enable-auto-pairing t)
;; (add-hook 'web-mode-hook
;;           (lambda ()
;;             ;; short circuit js mode and just do everything in jsx-mode
;;             (if (equal web-mode-content-type "javascript")
;;                 (web-mode-set-content-type "jsx")
;;               (message "now set to: %s" web-mode-content-type))))

(defun nuke_traling ()
  (add-hook 'before-save-hook #'delete-trailing-whitespace nil t))
(add-hook 'prog-mode-hook #'nuke_traling)
(setq js-indent-level 2)

(global-set-key (kbd "C-x C-g") 'magit-status)

(setq-default indent-tabs-mode nil)
(setq x-select-enable-clipboard t)

;; (load-theme 'solarized-zenburn t)

;; (set-face-attribute 'helm-selection nil
;;                     :background "green"
;;                     :foreground "black")

;; (if (daemonp)
;;     (add-hook 'after-make-frame-functions
;; 	      (lambda (frame)
;; 		(with-selected-frame frame (load-theme 'solarized-selenized-black t))))
;;   (load-theme 'solarized-selenized-black t))

;; macro to insert pdb in the code
(fset 'pdb-insert
   (kmacro-lambda-form [?\C-a return up tab ?i ?m ?p ?o ?r ?t ?  ?p ?d ?b ?\; ?  ?p ?d ?b ?. ?s ?e ?t ?_ ?t ?r ?a ?c ?e ?\( ?\) ?\C-x ?\C-s] 0 "%d"))
(global-set-key (kbd "C-x p") 'pdb-insert)

;; (use-package elpy
;;   :ensure t
;;   :init
;;   (elpy-enable))

(global-unset-key (kbd "C-z"))
(windmove-default-keybindings)

(setq browse-url-browser-function 'eww-browse-url
      shr-use-colors nil
      shr-bullet "• "
      shr-folding-mode t
      eww-search-prefix "https://duckduckgo.com/html?q="
      url-privacy-level '(email agent cookies lastloc))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("69f7e8101867cfac410e88140f8c51b4433b93680901bb0b52014144366a08c8"
     default))
 '(package-selected-packages
   '(better-defaults company eglot ein elpy exec-path-from-shell flycheck
                     go-mode graphql-mode helm-projectile ini-mode
                     jedi jinja2-mode lsp-ui magit modus-themes nov
                     py-autopep8 rjsx-mode rust-mode sdlang-mode
                     solarized-theme typescript-mode use-package
                     web-mode yaml-mode zenburn-theme))
 '(warning-suppress-types '(((python python-shell-completion-native-turn-on-maybe)))))

;; Theme customization

;; (custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.

 ;; '(default ((t (:inherit nil :extend nil :stipple nil :background "#002221" :foreground "#e6f8f8" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 113 :width normal :foundry "PfEd" :family "DejaVu Sans Mono"))))
 ;; '(fringe ((t (:background "#292929" :foreground "#777777"))))
 ;; '(helm-selection ((t (:extend t :background "firebrick" :underline t)))))

(require 'company)
;; (require 'yasnippet)
(require 'pyvenv)
(require 'eglot)

;; For go
;; Use eglot as the lsp client, and enable company mode
(require 'go-mode)
(use-package go-mode
  :ensure nil
  :hook
  (go-mode . eglot-ensure)  ; connect to language server when go-file is opened
  (go-mode . company-mode)
  )

;; For python
;; Use eglot as the lsp client, and enable company mode
;; eglot-find-implementation is not working
;; xref-* is used for finding references (C-h f xref)

;; (pyvenv-activate "~/.virtualenvs/swh/")

(use-package python-mode
  :ensure nil
  :hook
  (python-mode . eglot-ensure)  ; connect to language server when py-file is opened
  (python-mode . company-mode)
  :custom
  (python-shell-interpreter "ipython"
                            python-shell-interpreter-args "-i --simple-prompt")
  )

;; For rust
;; Use eglot as the lsp client, and enable company mode
(require 'rust-mode)
(use-package rust-mode
  :ensure nil
  :hook
  (rust-mode . eglot-ensure)  ; connect to language server when rust-file is opened
  (rust-mode . company-mode)
  )

(require 'modus-themes)
(if (daemonp)
    (add-hook 'after-make-frame-functions
	      (lambda (frame)
		(with-selected-frame frame (load-theme 'modus-vivendi t))))
  (load-theme 'modus-vivendi t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; (setq dired-listing-switches "-l -h")

(add-to-list 'default-frame-alist
             '(font . "DejaVu Sans Mono-14"))

(setq ispell-program-name "/opt/homebrew/bin/aspell")
