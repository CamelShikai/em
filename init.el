;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;;(package-initialize)

(add-to-list 'custom-theme-load-path (expand-file-name "~/.emacs.d/themes/"))
(load-theme 'monokai t)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "DejaVu Sans Mono" :slant normal :weight normal :height 160 :width normal)))))
;;rebind C-x C-b to buffer menu in current window
(global-set-key "\C-x\C-b" 'buffer-menu)
;;all buffer display line number
(add-hook 'prog-mode-hook 'linum-mode)
(global-set-key [(control x) (k)] 'kill-this-buffer)
;;add a load path
(add-to-list 'load-path "~/.emacs.d/lisp/")
;;markdown mode
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

(autoload 'gfm-mode "markdown-mode"
   "Major mode for editing GitHub Flavored Markdown files" t)
(add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))
;;turn on ace-select-window package
(global-set-key (kbd "M-p") 'ace-window)
(add-hook 'Info-mode-hook 'on-screen-mode)
;;trun on linum mode
(global-linum-mode 1)

;; Shift the selected region right if distance is postive, left if
;; negative

(defun shift-region (distance)
  (let ((mark (mark)))
    (save-excursion
      (indent-rigidly (region-beginning) (region-end) distance)
      (push-mark mark t t)
      ;; Tell the command loop not to deactivate the mark
      ;; for transient mark mode
      (setq deactivate-mark nil))))

(defun shift-right ()
  (interactive)
  (shift-region 1))

(defun shift-left ()
  (interactive)
  (shift-region -1))

;; Bind (shift-right) and (shift-left) function to your favorite keys. I use
;; the following so that Ctrl-Shift-Right Arrow moves selected text one 
;; column to the right, Ctrl-Shift-Left Arrow moves selected text one
;; column to the left:

(global-set-key [C-S-right] 'shift-right)
(global-set-key [C-S-left] 'shift-left)
;;revert buffer without confirmation
;; Source: http://www.emacswiki.org/emacs-en/download/misc-cmds.el
(defun revert-buffer-no-confirm ()
    "Revert buffer without confirmation."
    (interactive)
    (revert-buffer :ignore-auto :noconfirm))
;;set font size
(set-face-attribute 'default nil :height 120)
(set-default-font "DejaVu Sans Mono")

;;shell not fully functional problem
(setenv "PAGER" "cat")

;;revert all buffers
(defun revertall ()
  "Refresh all open file buffers without confirmation.
Buffers in modified (not yet saved) state in emacs will not be reverted. They
will be reverted though if they were modified outside emacs.
Buffers visiting files which do not exist any more or are no longer readable
will be killed."
  (interactive)
  (dolist (buf (buffer-list))
    (let ((filename (buffer-file-name buf)))
      ;; Revert only buffers containing files, which are not modified;
      ;; do not try to revert non-file buffers like *Messages*.
      (when (and filename
                 (not (buffer-modified-p buf)))
        (if (file-readable-p filename)
            ;; If the file exists and is readable, revert the buffer.
            (with-current-buffer buf
              (revert-buffer :ignore-auto :noconfirm :preserve-modes))
          ;; Otherwise, kill the buffer.
          (let (kill-buffer-query-functions) ; No query done when killing buffer
            (kill-buffer buf)
            (message "Killed non-existing/unreadable file buffer: %s" filename))))))
  (message "Finished reverting buffers containing unmodified files."))
;;disable menu bar
(menu-bar-mode -1) 
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (company-irony irony zenburn-theme klere-theme auto-complete ace-window dumb-jump golden-ratio-scroll-screen all-the-icons neotree json-reformat delight beacon json-mode))))

;; packages
(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/"))
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
  (package-initialize)
)

;;not tabs always space
(setq-default indent-tabs-mode nil)
;;always show paren mode on
(show-paren-mode 1)
;;add melpa
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/"))
;;toggle neotree
(global-set-key [f8] 'neotree-toggle)
;;config neotree theme
;;(setq neo-theme (if (display-graphic-p) 'icons 'arrow))
;;use all the icons
;;(require 'all-the-icons)
;;set neo
(setq neo-window-width 50)
;;open neo smart mode
(setq neo-smart-open t)
;;half page scrolling
(require 'golden-ratio-scroll-screen)
(global-set-key [remap scroll-down-command] 'golden-ratio-scroll-screen-down)
(global-set-key [remap scroll-up-command] 'golden-ratio-scroll-screen-up)
;;dumb jump
(dumb-jump-mode)
;;tab width
(setq tab-width 4)
;;ace-window binding
(global-set-key (kbd "M-o") 'ace-window)
;;set buffer-menu-name-width
(setq Buffer-menu-name-width 40)
;;auto complete enable
(ac-config-default)
;;whitespacemode
(require 'whitespace)
(setq whitespace-style '(face empty tabs lines-tail trailing))
(global-whitespace-mode t)
;;vertical border
(set-face-background 'vertical-border "gray")
(set-face-foreground 'vertical-border (face-background 'vertical-border))
;;disable tool bar
(tool-bar-mode -1) 
;;disable scroll bar
(toggle-scroll-bar -1) 
;;irony
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)

;; Windows performance tweaks
;;
(when (boundp 'w32-pipe-read-delay)
  (setq w32-pipe-read-delay 0))
;; Set the buffer size to 64K on Windows (from the original 4K)
(when (boundp 'w32-pipe-buffer-size)
  (setq irony-server-w32-pipe-buffer-size (* 64 1024)))
;;company irony
 (eval-after-load 'company
   '(add-to-list 'company-backends 'company-irony))

