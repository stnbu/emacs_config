(require 'package)
(add-to-list 'package-archives
			 '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/"))

(package-initialize)

(server-start)

(put 'upcase-region 'disabled nil)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
;; (setq column-number-mode t)

(custom-set-variables
 '(fill-column 80)
 '(column-number-mode t)
 '(package-selected-packages (quote (markdown-mode)))
 '(tab-width 4))
