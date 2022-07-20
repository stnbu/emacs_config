(setq visible-bell 1)
;; * Hey, you could write a whole book about a programming thing entirely in org:
;;   - Every block recognized as "language foo" gets sent to the compiler "in order"
;;   - What the heck does "in order" mean? Well, that's the thing. Work it out.
;;   - What about say "resources" (files) referred to in the code, e.g. ~open("./file")..?
;;   - Maybe org takes care of that magically? Org's job is to output a directory tree
;;     with the right structure and run a single command. That's what it do.
;; * This might be a very smart way to write a program!!!!!!!!!

;; WANTED:
;; * Bug: I don't get flyspell enabled *right here* by default (elisp comments).
;; * Possibly interesting org-roam considerations:
;;   - If I'm forced to use three laptops, how do I synchronize?
;;   - How can these "second brains" be connected to one-another?
;; * How does org-roam deal with case and/or matching nodes. What if I have the words swapped, etc.
;; * How to do a thing asyncronously? Like: on save, do expensive thing that takes five seconds in the background!
;; * Spelling
;;   - All new buffers get flyspell disabled. Have a simple key to toggle.
;;   - Histogram!!
;; * It seems "weird" that the regular help window, doesn't close with C-g .. should it?
;; * We want a single place to put one or more commands on-save. First: ~delete-trailing-whitespace~ !
;; * The log command thing. Should log to file to figure out which thing you do a lot and make easier (key bindings etc)
;; * How to highlight `@@comment:whatev@@` in org-mode?
;; * A neat, hierarchical major-mode handling thing
;;   - We can say "org-mode has a superset config of text-mode" etc; a kind of inheritance
;;   - How can I implement my own "minor mode"? WTF /is/ a MMode?
;; * Right click:
;;   - Custom context menu stuff.
;;   - Single mouse click and: wrap `[A-Za-z-]+` in a `@makro{}` (or whatever)
;; * Windows [figure them out]:
;;   - How can I have `emacsclient -n` use a particular window?
;;   - How can I open close the LHS org-sidebar menu?
;;   - Why is org-sidebar so "different" from other windows?
;;      - For example, seems to be immune to `C-x 1`
;; * Would be nice to view help/info/desc of package that is not (yet) intalled.
;; * Keystroke to toggle flyspell? Or just forget flyspell?
;; * Have "when in mode X use major minor mode Y"
;;    (add-hook 'my-mode-hook 'my-minor-mode)

;; delete-trailing-whitespace~ !
;; * The log command thing. Should log to file to figure out which thing you do a lot and make easier (key bindings etc)
;; * How to highlight `@@comment:whatev@@` in org-mode?
;; * A neat, hierarchical major-mode handling thing
;;   - We can say "org-mode has a superset config of text-mode" etc; a kind of inheritance
;;   - How can I implement my own "minor mode"? WTF /is/ a MMode?
;; * Right click:
;;   - Custom context menu stuff.
;;   - Single mouse click and: wrap `[A-Za-z-]+` in a `@makro{}` (or whatever)
;; * Windows [figure them out]:
;;   - How can I have `emacsclient -n` use a particular window?
;;   - How can I open close the LHS org-sidebar menu?
;;   - Why is org-sidebar so "different" from other windows?
;;      - For example, seems to be immune to `C-x 1`
;; * Would be nice to view help/info/desc of package that is not (yet) intalled.
;; * Keystroke to toggle flyspell? Or just forget flyspell?
;; * Have "when in mode X use major minor mode Y"
;;    (add-hook 'my-mode-hook 'my-minor-mode)

(savehist-mode)
(server-start)
(column-number-mode)
(setq vc-follow-symlinks t)
(global-auto-revert-mode 1)
(setq custom-file "~/.emacs.d/custom.el")
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(defun ipdb_set_trace ()
  (insert "import ipdb; ipdb.set_trace()")
)

;; Warning (:warning): You have 'mode-require-final-newline'
;; turned on. ethan-wspace supersedes 'require-final-newline', so
;; 'mode-require-final-newline' will be turned off.
;;
;; You can disable this warning by customizing the variable
;; 'mode-require-final-newline' to be NIL.
;; Warning (:warning): You have
;; 'require-final-newline' turned on.  ethan-wspace supersedes
;; 'require-final-newline', and so 'require-final-newline' will be
;; turned off.  If you turned on 'require-final-newline' in your
;; customizations, you can disable this warning by removing these
;; customizations.  Otherwise, please file a bug report, as some
;; other code has turned on 'require-final-newline'.
(setq mode-require-final-newline nil)

(require 'package)   ;; why do we need this? do we?
(package-initialize) ;; why do we need this? do we?

;; erc stuff from systemcrafters.cc
(setq erc-server "irc.libera.chat"
      erc-nick "captainmidday"
      erc-user-full-name "Mike Burr"
      erc-track-shorten-start 8
      erc-autojoin-channels-alist '(("irc.libera.chat"))
      erc-kill-buffer-on-part t
            erc-auto-query 'bury) ;; do I want bury?

(setq ispell-program-name "aspell")

;; ;; This collides /hard/ with org-roam TBD
;; (add-hook 'org-mode-hook (lambda ()
;; 			   (visual-line-mode)
;; 			   (org-sidebar-tree)
;; 			   ))

(defun add-hooks (function hooks)
  (mapc (lambda (hook)
          (add-hook hook function))
        hooks))

(defun mburr/prog-mode-common ()
  (flyspell-prog-mode)
  (python-mode-hook)
  (emacs-lisp-mode-hook))
(add-hooks
 '(mburr/prog-mode-common)
 '(
   rustic-mode-hook
   js2-mode-hook
   )
 )

;; (setq ring-bell-function
;;       (lambda ()
;;         (let ((orig-fg (face-foreground 'mode-line)))
;;           (set-face-foreground 'mode-line "#F2804F")
;;           (run-with-idle-timer 0.1 nil
;;                                (lambda (fg) (set-face-foreground 'mode-line fg))
;;                                orig-fg))))

(dolist (hook '(text-mode-hook))
  (add-hook hook (lambda () (flyspell-mode 1))))

(set-face-attribute 'default nil :height 220)
;; Stuff that you will be prompted about:
(put 'downcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)

;; (unless (package-installed-p 'use-package)
;;   (package-refresh-contents)
;;   (package-install 'use-package))

;; end stuff from emacs-rust-config/bootstrap.el

;; org roam
(use-package org-roam
  :ensure t
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory "~/RoamNotes")
  (org-roam-completion-everywhere t)
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         :map org-mode-map
         ("C-M-i"    . completion-at-point))
  :config
  (org-roam-setup))
;; end roam

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
  (setq rustic-format-on-save t)
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

(setq org-default-notes-file "~/tmp/testorg/notes.org") ;; testing test

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


(setq rustic-rustfmt-args "--edition=2021")

;; https://emacs.stackexchange.com/questions/61386/package-refresh-hangs
(custom-set-variables
 '(gnutls-algorithm-priority "normal:-vers-tls1.3"))
