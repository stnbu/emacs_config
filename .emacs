; -*- mode: Lisp;-*-

;; Emacs config file for PLA Tech Talk, Feb 5, 2020
;; Mike Burr <mburr@cattlekrush.com>

;; Instructions
;;   1) Save this file as ~/.emacs # rm -i ~/.emacs && curl -o ~/.emacs https://raw.githubusercontent.com/stnbu/emacs_config/master/.emacs
;;   2) Download and run the below "Mac for OSX" binary
;;
;; Meta Key: It should just be your "option" (or ALT) key, but if not: https://www.emacswiki.org/emacs/MetaKeyProblems
;;
;; Mac (Mojave as of writing) binary used with this .emacs file
;;   https://emacsformacosx.com/emacs-builds/Emacs-26.3-universal.dmg
;;
;; How to decipher eLisp
;;   https://github.com/alhassy/ElispCheatSheet/blob/master/CheatSheet.pdf
;;
;; Key bindings cheat sheet
;;   https://www.gnu.org/software/emacs/refcards/pdf/refcard.pdf
;;
;; Essential key chords (subjectively ordered by "usefulness")
;; C means "ctrl"
;; M means "option" (or "alt") [meta]
;; S means "command" [super]
;; "Point" just means "cursor"
;; "Region" means "selected text"
;; A space ' ' means: key stroke, release, next key stroke...
;; RET means: supply argument, hit enter, supply next argument, hit enter again...
;;   C-x C-f      [f]ind file (open existing or create new)
;;   C-p|n|b|f    Point navigation: [p]revious line, [n]ext line, [b]ack, [f]orwards)
;;   C-a          Move point to the beginning of current line [a of "a..z"]
;;   C-e          Move point to [e]nd of line
;;   C-x C-s      Save buffer
;;   C-s          [s]earch starting at point (wraps)
;;   C-r          Search in [r]everse starting at point
;;   M-%          Find/replace (the `%` sign looks like "change o for o")
;;   C-/          Undo
;;   C-g          Like "esc". "cancel! stop doing!"
;;   C-k          [k]ill to end of line.
;;   C-space      Begin region selection (move point to see what's selected)
;;   C-x b        Switch to [b]uffer, supports tab-completion
;;   M-;          Comment (e.g. selected region. because `;` is lisp comment)
;;   M-.          Go to definition of word at point (the identifier under your cursor)
;;   M-,          The opposite of go-to-definition. Go back to where you came from. Can do many levels deep.
;;   S-u          Revert buffer (to what is on disk, discard changes. [u]ndo everything.)
;;   C-x 1        Show only "this 1" (show only the window with the 'point')
;;   C-x 0        Show only the "0"ther window (the window without the 'point'. It's a zero, but you get the idea.)
;;   M-w          Copy region
;;   C-w          Cut region
;;   C-y          Paste region ([y]ank from buffer)
;;   M-$          Spell check word at point. If the region is active, do it for all words in the region instead (mnemonic: correct spelling has great value$$$)
;;   C-x k        [k]ill current buffer
;;   M-x          Run a command, supports tab completion
;;
;; Essential commands
;;   M-x rectangle-mark-mode      Select, interact with rectangle, e.g. when inserting, deleting the same line on each row.
;;   M-x describe-*               The help system. `describe-` and then tab key to see what you can get help for.
;;   M-x find-replace-regex       Just what it says
;;   M-x package-*                Search for, install packages, etc.
;;   M-x load-file RET ~/.emacs RET  Re-read Emacs configuration (e.g. when you make changes)
;;
;; Credit for recent js2 additions
;;   https://emacs.cafe/emacs/javascript/setup/2017/04/23/emacs-setup-javascript.html
;;
;; Stuff you should probably just go ahead and install (but may be mode-specific.) Be sure add ~/go/bin and ~/bin to your $PATH
;;   brew install ag ispell go
;;   go build golang.org/x/tools/cmd/guru  # installs to ~/go/bin/guru
;;   npm install --prefix ~/ -g tern


;; BEGIN GLOBAL-STUFF

;; begin package-stuff

(setq exec-path (append exec-path '("~/go/bin")))

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(setq use-package-always-ensure t)

;; Add packages you'd like auto-installed here (It would be smarter to put package config inside of `(use-package ...)` But instead they're below in commented sections.)
(use-package ag)
(use-package atom-one-dark-theme)
(use-package auto-complete)
(use-package company-php)
(use-package company-tern)
(use-package dap-mode)
(use-package exec-path-from-shell)
(use-package flymake-go)
(use-package go-autocomplete)
(use-package go-dlv)
(use-package go-guru)
(use-package go-mode)
(use-package go-playground)
(use-package go-scratch)
(use-package gotest)
(use-package js2-mode)
(use-package js2-refactor)
(use-package magit)
(use-package neotree)
(use-package php-mode)
(use-package xref-js2)

;; end package-stuff

(server-start)
(tool-bar-mode -1)                  ; Disable the button bar atop screen
(scroll-bar-mode -1)                ; Disable scroll bar
(setq inhibit-startup-screen t)     ; Disable startup screen with graphics
(set-default-font "Monaco 12")      ; Set font and size
(setq-default indent-tabs-mode nil) ; Use spaces instead of tabs
(setq tab-width 2)                  ; Four spaces is a tab
(setq visible-bell nil)             ; Disable annoying visual bell graphic
(setq ring-bell-function 'ignore)   ; Disable super annoying audio bell
(setq-default require-final-newline t)
(global-set-key "\M-c" 'copy-region-as-kill)
(global-set-key "\M-v" 'yank)
(global-set-key "\M-g" 'goto-line)
(setq column-number-mode t)         ; Show column numbers
(global-auto-revert-mode 1)         ; Update buffer when file-on-disk changes, automatically

;; Answers to "confusing" stuff that emacs asks, so it doesn't need to ask again.
(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)

;; If you find useful *.el files you can just drop them in here
(add-to-list 'load-path "~/.emacs.d/lisp/")

;; END GLOBAL-STUFF

;; BEGIN JS2-STUFF

(require 'js2-mode)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-hook 'js2-mode-hook #'js2-imenu-extras-mode)
(require 'js2-refactor)
(require 'xref-js2)
(add-hook 'js2-mode-hook #'js2-refactor-mode)
(js2r-add-keybindings-with-prefix "C-c C-r")
(define-key js2-mode-map (kbd "C-k") #'js2r-kill)
;; js-mode (which js2 is based on) binds "M-." which conflicts with xref, so unbind it.
(define-key js-mode-map (kbd "M-.") nil)
(add-hook 'js2-mode-hook (lambda ()
                           (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t)))
(define-key js2-mode-map (kbd "C-k") #'js2r-kill)
(require 'company)
(require 'company-tern)
(add-to-list 'company-backends 'company-tern)
(add-hook 'js2-mode-hook (lambda ()
                           (tern-mode)
                           (company-mode)))
;; Disable completion keybindings, as we use xref-js2 instead
(define-key tern-mode-keymap (kbd "M-.") nil)
(define-key tern-mode-keymap (kbd "M-,") nil)

(setq js2-basic-offset 2)

;; END JS2-STUFF

;; BEGIN GOLANG-STUFF

;;(setq gofmt-command "goimports")
;;(add-hook 'before-save-hook 'gofmt-before-save)

;; Get the user's $PATH and $GOPATH. Note that you want ~/go/bin in your $PATH
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-env "GOPATH"))
;; Define function to call when go-mode loads
(defun my-go-mode-hook ()

  (add-to-list 'load-path (concat (getenv "HOME")  "/go/src/golang.org/x/lint/misc/emacs/"))
  (require 'golint)
  
  (add-hook 'before-save-hook 'gofmt-before-save) ; gofmt before every save
  (setq gofmt-command "goimports")                ; gofmt uses invokes goimports
  (if (not (string-match "go" compile-command))   ; set compile command default
      (set (make-local-variable 'compile-command)
           "go build -v && go test -v && go vet"))
  ;; guru settings
  (go-guru-hl-identifier-mode)                    ; highlight identifiers
  ;; Key bindings specific to go-mode
  (local-set-key (kbd "M-.") 'godef-jump)         ; Go to definition
  (local-set-key (kbd "M-*") 'pop-tag-mark)       ; Return from whence you came
  (local-set-key (kbd "M-p") 'compile)            ; Invoke compiler
  (local-set-key (kbd "M-P") 'recompile)          ; Redo most recent compile cmd
  (local-set-key (kbd "M-]") 'next-error)         ; Go to next error (or msg)
  (local-set-key (kbd "M-[") 'previous-error)     ; Go to previous error or msg
  ;; Misc go stuff
  (auto-complete-mode 1))                         ; Enable auto-complete mode

;; Connect go-mode-hook with the function we just defined
(add-hook 'go-mode-hook 'my-go-mode-hook)

;; Ensure the go specific autocomplete is active in go-mode.
(with-eval-after-load 'go-mode
  (require 'go-autocomplete))

;;(add-hook 'before-save-hook 'gofmt-before-save)


;; END GOLANG-STUFF

;; BEGIN MAGIT-STUFF

(global-set-key (kbd "C-c m") 'magit-status)

;; END MAGIT-STUFF


;; BEGIN TRAMP-STUFF

;;;; If you fiddle with shells other than bash for tramp, fiddle like this:
;; (setq tramp-shell-prompt-pattern "\\(?:^\\|\r\\)[^]#$%>\n]*#?[]#$%>] *\\(^[\\[[0-9;]*[a-zA-Z] *\\)*")

;; END TRAMP-STUFF
