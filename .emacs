(setq ispell-program-name "/usr/local/bin/ispell")

(require 'package)
(add-to-list 'package-archives
			 '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/"))

(package-initialize)

(server-start)

(put 'upcase-region 'disabled nil)
;;(add-hook 'before-save-hook 'delete-trailing-whitespace)
;;(setq column-number-mode t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(fill-column 80)
 '(package-selected-packages
   (quote
	(go-mode company-lsp php-mode rust-mode magit markdown-mode)))
 '(tab-width 4)
 '(visible-bell 1))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(require 'company-lsp)
(push 'company-lsp company-backends)


;; TODO
; magit-status --> press [TAB]
; magit-stage
;;;;;;; in: .dir-locals.el
;;;;;;; (setq before-save-hook nil)
;;;;;;; ;;(add-hook 'before-save-hook 'delete-trailing-whitespace)
; k -- discard staged and unstaged (undo)

(global-set-key (kbd "C-x <up>") 'windmove-up)
(global-set-key (kbd "C-x <down>") 'windmove-down)
(global-set-key (kbd "C-x <right>") 'windmove-right)
(global-set-key (kbd "C-x <left>") 'windmove-left)
