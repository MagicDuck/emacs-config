;; useful to look at: http://pages.sachachua.com/.emacs.d/Sacha.html
;;-------------------------------------------------------------------------
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
(global-linum-mode 1) ;; display line numbers
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(fset 'yes-or-no-p 'y-or-n-p) ;; Changes all yes/no questions to y/n type
(global-hl-line-mode 1) ;; highlight current line

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

;; keybindings

;;-------------------------------------------------------------------------
;; theme/font

;; alternatives:
(use-package
  ;;color-theme-sanityinc-tomorrow :init (load-theme 'sanityinc-tomorrow-day t)
  ;;color-theme-solarized :init (load-theme 'solarized t)
  ;;twilight-bright-theme :init (load-theme 'twilight-bright t)
  flatui-theme :init (load-theme 'flatui t)
  :defer t)

(set-frame-font "Inconsolata 12")

;; maximize emacs on load
(add-to-list 'default-frame-alist '(fullscreen . maximized))

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
  :bind (("C-c h" . helm-mini)
         ("C-h a" . helm-apropos)
         ("C-x C-b" . helm-buffers-list)
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

;;-------------------------------------------------------------------------
;; evil

(use-package evil
    :config
    (evil-mode t))
