;;-------------------------------------------------------------------------
;; package management

(require 'package)

;; ensures given packages are installed
(defun ensure-package-installed (&rest packages)
  "Assure every package is installed, ask for installation if it’s not.
  Return a list of installed packages or nil for every skipped package."
  (mapcar
   (lambda (package)
     (if (package-installed-p package)
         nil
       (if (y-or-n-p (format "Package %s is missing. Install it? " package))
           (package-install package)
         package)))
   packages))

;; make sure to have downloaded list of packages availale.
(or (file-exists-p package-user-dir)
    (package-refresh-contents))

;; package repositories
(setq package-archives '(("elpa" . "http://tromey.com/elpa/")
                         ("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.org/packages/")))

(package-initialize)


;;-------------------------------------------------------------------------
;; misc customiztions

(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(menu-bar-mode -1)
(global-linum-mode 1) ;; display line numbers
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(fset 'yes-or-no-p 'y-or-n-p) ;; Changes all yes/no questions to y/n type

;; Stop littering everywhere with save files, put them somewhere
(setq backup-directory-alist '(("." . "~/.emacs-backups")))

(show-paren-mode 1) ;; highlight matching paren

;; Remember what I had open when I quit
(desktop-save-mode 1)

;; Tabs are evil
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)

;;-------------------------------------------------------------------------
;; helm

(ensure-package-installed 'helm)
(require 'helm-config)

;;-------------------------------------------------------------------------
;; evil

(ensure-package-installed 'evil)
(require 'evil)
(evil-mode t)
