;; Helpers to determine which machine I'm on
;; Get current system's name
(defun insert-system-name()
(interactive)
(insert (format "%s" system-name))
)

;; Get current system type
(defun insert-system-type()
(interactive)
(insert (format "%s" system-type))
)

;; Check if system is Darwin/Mac OS X
(defun system-type-is-darwin ()
(interactive)
(string-equal system-type "darwin")
)

;; Check if system is GNU/Linux
(defun system-type-is-gnu ()
(interactive)
(string-equal system-type "gnu/linux")
)

;; Packages are in .emacs.d
(add-to-list 'load-path "~/.emacs.d")
;; So everything works for root.
;; Hacky - there's probably a better way
(add-to-list 'load-path "~henrik/.emacs.d")

;; Emacs size and position. 
(setq default-frame-alist (append (list
  '(width  . 90)  
  '(height . 35)) 
  default-frame-alist))

;; Window title
(setq-default frame-title-format (list "emacs: %b"))
(setq-default icon-title-format (list "emacs: %b"))

;; No start-up message
(setq inhibit-startup-message t)

;; Use org-mode by default
(setq initial-major-mode 'org-mode)
(setq default-major-mode 'org-mode)

;; Backups to a specific directory
(setq backup-directory-alist
      `(("." . ,(expand-file-name "/tmp/emacsbackups"))))

;; *Messages* is not needed
(setq message-log-max nil)
(kill-buffer "*Messages*")

;; Visible selection
(setq transient-mark-mode t)

;; Cursor color
(set-cursor-color "orange")

;; Type/delete directly in region
(delete-selection-mode 1)

;; Show line numbers
(line-number-mode t) 

;; Week starts on Monday
(setq calendar-week-start-day 1)

;; Just ask me y or no
(defalias 'yes-or-no-p 'y-or-n-p)

;; Confirm emacs exit
(setq confirm-kill-emacs ' yes-or-no-p) 

;; No toolbar
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))

;; Remote File Editing
(when (require 'tramp nil t)
  (setq tramp-default-method "scp"))

;; Smooth scrolling
(require 'smooth-scrolling)

;; Long-lines
(setq longlines-wrap-follows-window-size t)

;; Newline and indent
(global-set-key "\C-m" 'newline-and-indent)

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(org-agenda-files (quote ("~/gtd.org"))))

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:stipple nil :background "black" :foreground "bisque" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 75 :width normal :family "DejaVu Sans Mono")))))

;; Smart tabs 
(defun smart-tab ()
     "This smart tab is minibuffer compliant: it acts as usual in
       the minibuffer. Else, if mark is active, indents region. Else if
       point is at the end of a symbol, expands it. Else indents the

       current line."
     (interactive)
     (if (string-match "Minibuf" (buffer-name))
         (unless (minibuffer-complete)
           (dabbrev-expand nil))
       (if mark-active
           (indent-region (region-beginning)

                          (region-end))
         (if (looking-at "\\>")
             (dabbrev-expand nil)
           (indent-for-tab-command)))))
(global-set-key [(tab)] 'smart-tab)

;; SQL mode
;; M-x sql-mysql to connect, M-x sql-mode for mode, C-c, C-c to send
(eval-after-load "sql"
  '(progn
     (sql-set-product 'mysql)
  ))

;; Configure orgmode
(require 'org)
(defun gtd ()
  "Open the GTD file."
  (interactive)
  (find-file "~/gtd.org"))
(add-to-list 'auto-mode-alist '("\.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cg" 'gtd)
(setq org-log-done t)
(setq org-agenda-start-on-weekday nil)
(setq org-tags-match-list-sublevels 1)
(setq org-agenda-custom-commands
    '(("W" todo "WAITING" nil)
     ("d" "Agenda + Todo" ((agenda) (todo "TODO"))))
)

;; Configure subversion
(require 'psvn)

