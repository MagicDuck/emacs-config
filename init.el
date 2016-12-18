;; useful to look at: http://pages.sachachua.com/.emacs.d/Sacha.html
;;-------------------------------------------------------------------------
;; proxy

(when (equal system-type 'windows-nt)
    (setq url-proxy-services
    '(("no_proxy" . "^\\(localhost\\|10.*\\)")
        ("http" . "proxy:8080")
        ("https" . "proxy:8080")))
)

;; package management
(require 'package)
(setq package-archives '(("melpa" . "http://melpa.org/packages/")
                         ("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ))
(package-initialize)

;; bootstrap - grab use-package if not available
(unless (package-installed-p 'use-package)
  (progn
    (package-refresh-contents)
    (package-install 'use-package)))

(require 'use-package)
(setq use-package-always-ensure t) ;; alway ensure packages are installed

;;-------------------------------------------------------------------------
;; misc customiztions

(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(menu-bar-mode -1)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(fset 'yes-or-no-p 'y-or-n-p) ;; Changes all yes/no questions to y/n type
(global-hl-line-mode 1) ;; highlight current line
(set-face-bold-p 'bold nil) ;; disable bold
(setq x-select-enable-clipboard t) ;; use system clipboard -- Note: to paste in insert mode, use Ctrl-o p

;; Stop littering everywhere with save files, put them somewhere
(setq backup-directory-alist '(("." . "~/.emacs-backups")))

(show-paren-mode 1) ;; highlight matching paren

;; Remember what I had open when I quit
(desktop-save-mode 1)

;; Tabs are evil
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)

;; Set locale to UTF8
(set-language-environment 'utf-8)
(set-terminal-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; RELATIVE line numbers
(use-package linum-relative
  :config
  ;; (setq linum-relative-current-symbol ">>")
  (linum-relative-global-mode 1))

;;-------------------------------------------------------------------------
;; keybindings

;; comment/uncomment line
;; Original idea from
;; http://www.opensubscriber.com/message/emacs-devel@gnu.org/10971693.html
(defun comment-dwim-line (&optional arg)
    "Replacement for the comment-dwim command.
    If no region is selected and current line is not blank and we are not at the end of the line,
    then comment current line.
    Replaces default behaviour of comment-dwim, when it inserts comment at the end of the line."
    (interactive "*P")
    (comment-normalize-vars)
    (if (and (not (region-active-p)) (not (looking-at "[ \t]*$")))
        (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    (comment-dwim arg)))
(global-set-key (kbd "M-;") 'comment-dwim-line)

;;-------------------------------------------------------------------------
;; theme/font

;; alternatives:
(use-package
  ;;color-theme-sanityinc-tomorrow :init (load-theme 'sanityinc-tomorrow-day t)
  ;;color-theme-solarized :init (load-theme 'solarized t)
  ;;twilight-bright-theme :init (load-theme 'twilight-bright t)
  flatui-theme :init (load-theme 'flatui t)
  :defer t)

;; (print (font-family-list))
;; (set-frame-font "Droid Sans Mono Slashed For Powerline 11")
(if (equal system-type 'windows-nt)
    (set-frame-font "Consolas 12")
    (set-frame-font "Droid Sans Mono 11"))

;; maximize emacs on load
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;;-------------------------------------------------------------------------
;; evil

(use-package evil
    :init
    (progn
        ;; This has to be before we invoke evil-mode due to:
        ;; https://github.com/cofi/evil-leader/issues/10
        (use-package evil-leader
            :init (global-evil-leader-mode)
            :config
            (progn
                (setq evil-leader/in-all-states t)
                (evil-leader/set-leader ",")

                ;; keyboard shortcuts
                (evil-leader/set-key
                    ;; "a" 'ag-project
                    ;; "a" 'ag
                    ;; "b" 'ido-switch-buffer
                    ;; "c" 'mc/mark-next-like-this
                    ;; "c" 'mc/mark-all-like-this
                    ;; "e" 'er/expand-region
                    ;; "e" 'mc/edit-lines
                    ;; "f" 'ido-find-file
                    "f" 'helm-projectile-find-file
                    "b" 'helm-buffers-list
                    "s" 'magit-status
                    "r" 'ranger
                    "e" 'er/expand-region
                    ;; "i" 'idomenu
                    ;; "j" 'ace-jump-mode
                    ;; "k" 'kill-buffer
                    ;; "k" 'kill-this-buffer
                    "o" 'occur
                    ;; "p" 'magit-find-file-completing-read
                    ;; "r" 'recentf-ido-find-file
                    ;; "s" 'ag-project
                    ;; "t" 'bw-open-term
                    ;; "t" 'eshell
                    "w" 'save-buffer
                    "g" 'helm-git-grep
                    "u" (lambda () (interactive)
                          (if (fboundp 'projectile-project-root) (helm-do-pt (projectile-project-root)) (Error "Projectile is not available!")))
                    "h" 'helm-projectile-pt
                    ;; "x" 'smex
                )
            )
        )
    )
    :config
    (evil-mode t)

    ;; semantic expand-contract
    (use-package expand-region
      :config
      (setq expand-region-contract-fast-key "r")
      )

    ;; allow (*) to select symbols
    (setq-default evil-symbol-word-search 'symbol)

    ;; esc should always quit: http://stackoverflow.com/a/10166400/61435
    ;; (define-key evil-normal-state-map [escape] 'keyboard-quit)
    ;; (define-key evil-visual-state-map [escape] 'keyboard-quit)
    ;; (define-key minibuffer-local-map [escape] 'abort-recursive-edit)
    ;; (define-key minibuffer-local-ns-map [escape] 'abort-recursive-edit)
    ;; (define-key minibuffer-local-completion-map [escape] 'abort-recursive-edit)
    ;; (define-key minibuffer-local-must-match-map [escape] 'abort-recursive-edit)
    ;; (define-key minibuffer-local-isearch-map [escape] 'abort-recursive-edit)
)

(use-package evil-escape
    :config
    (setq-default evil-escape-key-sequence "jk")
    (setq-default evil-escape-delay 0.1)
    (evil-escape-mode t)
)

;; evil - magit integration
(use-package evil-magit)

;; (helm-do-pt (projectile-project-root))

;;-------------------------------------------------------------------------
;; helm

(use-package helm
  :diminish helm-mode
  :init
  (progn
    (require 'helm-config)
    (setq helm-candidate-number-limit 100)
    ;; From https://gist.github.com/antifuchs/9238468
    (setq helm-idle-delay 0.0 ; update fast sources immediately (doesn't).
          helm-input-idle-delay 0.01  ; this actually updates things
                                        ; reeeelatively quickly.
          helm-yas-display-key-on-candidate t
          helm-quick-update t
          helm-M-x-requires-pattern nil
          helm-split-window-in-side-p t ; open helm buffer inside current window, not occupy whole other window
          helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
          helm-ff-file-name-history-use-recentf t
          helm-ff-skip-boring-files t
          helm-buffers-fuzzy-matching t
          helm-recentf-fuzzy-match    t
          helm-M-x-fuzzy-match t
    )
    (helm-mode)
    (helm-autoresize-mode t)
    (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
    (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
    (define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z
    )
  ;; TODO: look at these bindings and see which make sense
  :bind (
         ("C-c h" . helm-mini)
         ("C-x b" . helm-buffers-list)
         ("M-y" . helm-show-kill-ring)
         ("M-x" . helm-M-x)
         ("C-x c o" . helm-occur)
         ("C-x c s" . helm-swoop)
         ("C-x c y" . helm-yas-complete)
         ("C-x c Y" . helm-yas-create-snippet-on-region)
         ("C-x c SPC" . helm-all-mark-rings)))
(ido-mode -1) ;; Turn off ido mode in case I enabled it accidentally as it seems to conflict with helm

;; great for describing bindings
(use-package helm-descbinds
  :defer t
  :bind (("C-h b" . helm-descbinds)
         ("C-h w" . helm-descbinds)))


;;------------------------------------------------------------------------------------------
;; projectile

(use-package projectile
  :diminish projectile-mode
  :config
  (progn
    (setq projectile-keymap-prefix (kbd "C-c p"))
    (setq projectile-completion-system 'default)
    (setq projectile-enable-caching t)
    (setq projectile-indexing-method 'alien)
    (setq projectile-enable-caching t)
    (add-to-list 'projectile-globally-ignored-files "node-modules"))
  :config
  (projectile-global-mode))
;;(use-package helm-projectile)
(use-package helm-projectile
  :ensure t
  :init
  (helm-projectile-on)
  (setq projectile-switch-project-action 'helm-projectile)
  (defvar helm-source-file-not-found
    (helm-build-dummy-source
        "Create file"
      :action 'find-file))
  (add-to-list 'helm-projectile-sources-list helm-source-file-not-found t)
  )

;;-------------------------------------------------------------------------------------------
;; git
(use-package magit
    :config
    (progn
        (when (equal system-type 'windows-nt)
          (setq magit-git-executable "c:/bin/git/bin/git.exe"))
        (setq magit-diff-options '("-b")) ; ignore whitespace
    )
)


;;---------------------------------------------------------------------------------
;; smart-line/powerline

;; (use-package telephone-line
;;   :config
;;   (setq telephone-line-lhs
;;         '((evil   . (telephone-line-evil-tag-segment))
;;           (accent . (telephone-line-vc-segment
;;                      telephone-line-erc-modified-channels-segment
;;                      telephone-line-process-segment))
;;           (nil    . (telephone-line-minor-mode-segment
;;                      telephone-line-buffer-segment))))
;;   (setq telephone-line-rhs
;;         '((nil    . (telephone-line-misc-info-segment))
;;           (accent . (telephone-line-major-mode-segment))
;;           (evil   . (telephone-line-airline-position-segment))))
;;   (telephone-line-mode t))

(use-package smart-mode-line
    :config
    (setq sml/theme 'respectful)
    (setq sml/no-confirm-load-theme t)
    (sml/setup)
)

(use-package nyan-mode
    :init
    (setq nyan-animate-nyancat t)
    (setq nyan-wavy-trail nil)
    (nyan-mode))

;;-------------------------------------------------------------------------------------------
;; ranger
;; https://github.com/ralesi/ranger.el#standard-ranger-bindings

(use-package ranger
    :config
    (setq ranger-max-preview-size 10)
    (setq ranger-excluded-extensions '("mkv" "iso" "mp4"))
    (setq ranger-dont-show-binary t)
)

;;-------------------------------------------------------------------------------------------
;; javascript

(use-package js2-mode
  :config
  (add-to-list 'auto-mode-alist `(,(rx ".js" string-end) . js2-mode))
)

;; linting
;; NOTE: you will need to install external tools like node jshint for things to work
;; use flycheck-verify-setup to make sure stuff is installed
(use-package flycheck
    :config
    (add-hook 'after-init-hook #'global-flycheck-mode)
    ;; (add-hook 'js2-mode-hook 'flycheck-mode)
    (progn
        (if (equal system-type 'windows-nt)
            (setq flycheck-jshintrc "c:/code/hana_epm_fpa/config/coding/jshintconfig.js")
            (setq flycheck-jshintrc "~/.emacs.d/.jshintrc"))
    )
)

;;-------------------------------------------------------------------------------------------
;; autocomplete

(use-package company
  :config
  (add-hook 'prog-mode-hook 'company-mode)
  (setq company-idle-delay 0.1))

;;-------------------------------------------------------------------------------------------
;; searching

(use-package pt)
(use-package helm-pt)
(use-package helm-git-grep)
(use-package helm-ls-git)

;;-------------------------------------------------------------------------------------------
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" default)))
 '(package-selected-packages
   (quote
    (helm-git-grep helm-ls-git helm-pt pt expand-region js2-mode ranger telephone-line smart-mode-line-powerline-theme smart-mode-line evil-magit use-package twilight-bright-theme meacupla-theme material-theme magit helm-projectile helm-descbinds flatui-theme evil-leader evil-escape company color-theme-solarized color-theme-sanityinc-tomorrow ample-theme)))
 '(pt-arguments
   (quote
    ("--smart-case --before=2 --after=2 --skip-vcs-ignores"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
