;; Lots of theft from https://github.com/rksm/emacs-rust-config
;; Thank you kind stranger.

;; TODO:
;; - When org-mode, then also visual-line-mode

;;(setq ispell-program-name "/usr/local/bin/hunspell")
(setq ispell-program-name "/usr/local/bin/aspell")

;; begin my-newer-stuff
(add-hook 'rustic-mode-hook (lambda () (flyspell-prog-mode)))
(add-hook 'js2-mode-hook (lambda () (flyspell-prog-mode)))
(add-hook 'python-mode-hook (lambda () (flyspell-prog-mode)))
(add-hook 'emacs-lisp-mode-hook (lambda () (flyspell-prog-mode)))
(add-hook 'org-mode-hook (lambda () (visual-line-mode)))

;;;; The smart way to do this (which does not work because I do not know from):
;; (defun add-hooks (function hooks)
;;   (mapc (lambda (hook)
;;           (add-hook hook function))
;;         hooks))
;; (defun my-turn-on-auto-fill ()
;;   (setq fill-column 72)
;;   (turn-on-auto-fill))
;; (add-hooks
;;  '(flyspell-prog-mode)
;;  '(rustic-mode-hook js2-mode-hook)
;;  )

;; end my-newer-stuff

;; begin was-my-stuff

(server-start)

(column-number-mode)
(global-auto-revert-mode 1)
(add-hook 'dired-mode-hook 'auto-revert-mode)

;;(setq ring-bell-function 'ignore) ;; if you disllike the below "subtl" bell.
;; https://www.emacswiki.org/emacs/AlarmBell - "Subtly flash the modeline"
(setq ring-bell-function
      (lambda ()
        (let ((orig-fg (face-foreground 'mode-line)))
          (set-face-foreground 'mode-line "#F2804F")
          (run-with-idle-timer 0.1 nil
                               (lambda (fg) (set-face-foreground 'mode-line fg))
                               orig-fg))))

(dolist (hook '(text-mode-hook))
  (add-hook hook (lambda () (flyspell-mode 1))))
(flyspell-prog-mode)
(setq org-startup-truncated nil)

(set-face-attribute 'default nil :height 220)
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
(custom-set-variables
 '(package-selected-packages
   '(js2-mode magit rust-mode rustic go-complete company go-mode ##)))
(custom-set-faces
 )
;; Things that emacs lets you "try once, enable, ..." (these are enabled "forever and stfu")
(put 'downcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)

;; end was-my-stuff

;; begin stuff from emacs-rust-config/bootstrap.el

(setq user-init-file (or load-file-name (buffer-file-name)))
(setq user-emacs-directory (file-name-directory user-init-file))
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(require 'package)
(add-to-list 'package-archives '("tromey" . "http://tromey.com/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(setq package-user-dir (expand-file-name "elpa/" user-emacs-directory))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; end stuff from emacs-rust-config/bootstrap.el

;; begin stuff from emacs-rust-config/init.el

(use-package rustic
  :ensure
  :bind (:map rustic-mode-map
              ("M-j" . lsp-ui-imenu)
              ("M-?" . lsp-find-references)
              ("C-c C-c l" . flycheck-list-errors)
              ("C-c C-c a" . lsp-execute-code-action)
              ("C-c C-c r" . lsp-rename)
              ("C-c C-c q" . lsp-workspace-restart)
              ("C-c C-c Q" . lsp-workspace-shutdown)
              ("C-c C-c s" . lsp-rust-analyzer-status)
              ("C-c C-c e" . lsp-rust-analyzer-expand-macro)
              ("C-c C-c d" . dap-hydra)
              ("C-c C-c h" . lsp-ui-doc-glance))
  :config
  ;; uncomment for less flashiness
  ;; (setq lsp-eldoc-hook nil)
  ;; (setq lsp-enable-symbol-highlighting nil)
  ;; (setq lsp-signature-auto-activate nil)

  ;; comment to disable rustfmt on save
  ;;(setq rustic-format-on-save t)  ;; how can we make this "nice"?
  (add-hook 'rustic-mode-hook 'rk/rustic-mode-hook))

(defun rk/rustic-mode-hook ()
  ;; so that run C-c C-c C-r works without having to confirm, but don't try to
  ;; save rust buffers that are not file visiting. Once
  ;; https://github.com/brotzeit/rustic/issues/253 Has been resolved this should
  ;; no longer be necessary.
  (when buffer-file-name
    (setq-local buffer-save-without-query t)))

;; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
;; for rust-analyzer integration

(use-package lsp-mode
  :ensure
  :commands lsp
  :custom
  ;; what to use when checking on-save. "check" is default, I prefer clippy
  (lsp-rust-analyzer-cargo-watch-command "clippy")
  (lsp-eldoc-render-all nil)
  (lsp-idle-delay 0.6)
  (lsp-rust-analyzer-server-display-inlay-hints t)
  :config
  (add-hook 'lsp-mode-hook 'lsp-ui-mode))

(use-package lsp-ui
  :ensure
  :commands lsp-ui-mode
  :custom
  (lsp-ui-peek-always-show t)
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-doc-enable nil))


;; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
;; inline errors

(use-package flycheck :ensure)


;; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
;; auto-completion and code snippets

(use-package yasnippet
  :ensure
  :config
  (yas-reload-all)
  (add-hook 'prog-mode-hook 'yas-minor-mode)
  (add-hook 'text-mode-hook 'yas-minor-mode))

(use-package company
  :ensure
  :bind
  (:map company-active-map
              ("C-n". company-select-next)
              ("C-p". company-select-previous)
              ("M-<". company-select-first)
              ("M->". company-select-last))
  (:map company-mode-map
        ("<tab>". tab-indent-or-complete)
        ("TAB". tab-indent-or-complete)))

(defun company-yasnippet-or-completion ()
  (interactive)
  (or (do-yas-expand)
      (company-complete-common)))

(defun check-expansion ()
  (save-excursion
    (if (looking-at "\\_>") t
      (backward-char 1)
      (if (looking-at "\\.") t
        (backward-char 1)
        (if (looking-at "::") t nil)))))

(defun do-yas-expand ()
  (let ((yas/fallback-behavior 'return-nil))
    (yas/expand)))

(defun tab-indent-or-complete ()
  (interactive)
  (if (minibufferp)
      (minibuffer-complete)
    (if (or (not yas/minor-mode)
            (null (do-yas-expand)))
        (if (check-expansion)
            (company-complete-common)
          (indent-for-tab-command)))))


;; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
;; for Cargo.toml and other config files

(use-package toml-mode :ensure)


;; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
;; setting up debugging support with dap-mode

(use-package exec-path-from-shell
  :ensure
  :init (exec-path-from-shell-initialize))

(when (executable-find "lldb-mi")
  (use-package dap-mode
    :ensure
    :config
    (dap-ui-mode)
    (dap-ui-controls-mode 1)

    (require 'dap-lldb)
    (require 'dap-gdb-lldb)
    ;; installs .extension/vscode
    (dap-gdb-lldb-setup)
    (dap-register-debug-template
     "Rust::LLDB Run Configuration"
     (list :type "lldb"
           :request "launch"
           :name "LLDB::Run"
	   :gdbpath "rust-lldb"
           ;; uncomment if lldb-mi is not in PATH
           ;; :lldbmipath "path/to/lldb-mi"
           ))))

;; begin stuff from emacs-rust-config/init.el

;;(setq js2-basic-offset 2)
(setq js-indent-level 2)


;; "Hey, why doesn't this work when at the top?" --mburr
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
;; wee
;;(setq org-export-with-section-numbers nil)

(setq org-catch-invisible-edits "error")

;; ;; AAAAAAArgGggg!
;; (setq ispell-dictionary "~/.emacs.d/share/words")

(defun sort-lines-nocase ()
  (interactive)
  (let ((sort-fold-case t))
    (call-interactively 'sort-lines)))


(setq org-default-notes-file "/Users/mburr/tmp/testorg/notes.org")



;; ;; https://discord.com/channels/489936967895875605/489936967895875607/890632675973529650
;; ;; You can probably get way with using an eval inside .dir-locals.el but it's not clean IMO.
;; ;; Alternatively you'll need a hook to look for .custom.el and load it. Example:
;; (defun load-cwd-.custom.el ()
;;   "If exists, load a file called \".custom.el\" from the current
;;   working directory."
;;   (when (file-exists-p ".custom.el")
;;     (load-file ".custom.el")))
;; (require 'projectile)
;; (defun load-.custom.el ()
;;   "Try to load \".custom.el\" from the current working directory,
;;   if that fails try looking for it at the project's root
;;   instead."
;;   (if (load-cwd-.custom.el)
;;       (message "Loaded .custom.el from current directory." (pwd))
;;     (when (projectile-project-p)
;;       (let ((default-directory default-directory))
;;     (cd (projectile-project-root))
;;     (load-cwd-.custom.el)
;;     (message "Loaded .custom.el from project directory.")))))
;; (add-hook 'find-file-hook #'load-.custom.el)
