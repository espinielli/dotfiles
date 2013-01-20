;; inspired by emacs kicker
;; URL: https://github.com/dimitri/emacs-kicker
;; inspired by Chris Forno
;; URL: http://jekor.com/.emacs
;; inspired by Dimitri Fontaine
;; URL: https://github.com/dimitri/el-get


(require 'cl)                           ; common lisp goodies, loop

;; detect if el-get is already installed and install it if necessary.
;; user master branch
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (let (el-get-master-branch)
      (goto-char (point-max))
      (eval-print-last-sexp))))

(el-get 'sync)



;; now either el-get is `require'd already, or have been `load'ed by the el-get installer.
;; set local recipes
(setq
 el-get-sources
 '((:name buffer-move                   ; have to add your own keys
          :after (progn
                   (global-set-key (kbd "<C-S-up>")     'buf-move-up)
                   (global-set-key (kbd "<C-S-down>")   'buf-move-down)
                   (global-set-key (kbd "<C-S-left>")   'buf-move-left)
                   (global-set-key (kbd "<C-S-right>")  'buf-move-right)))

   (:name magit                         ; git meet emacs, and a binding
          :after (progn
                   (global-set-key (kbd "C-x C-z") 'magit-status)))

   (:name goto-last-change              ; move pointer back to last change
          :after (progn
                   ;; when using AZERTY keyboard, consider C-x C-_
                   (global-set-key (kbd "C-x C-/") 'goto-last-change)))))

;; now set our own packages
(setq
 my:el-get-packages
 '(el-get                               ; el-get is self-hosting
   switch-window                        ; takes over C-x o
   auto-complete                        ; complete as you type with overlays
   js-comint
   color-theme                          ; nice looking emacs
   color-theme-solarized                ; check out color-theme-blue-mood
   auctex
   muse
   emacs-goodies-el
   magit
   magithub
   ipython
   ess
   ess-smart-underscore
   json
   js2-mode
   multi-web-mode
   ))

;;
;; Some recipes require extra tools to be installed
;;
;; Note: el-get-install requires git, so we know we have at least that.
(when (el-get-executable-find "cvs")
  (add-to-list 'my:el-get-packages 'emacs-goodies-el)) ; the debian addons for emacs

(when (el-get-executable-find "svn")
  (loop for p in '(psvn                 ; M-x svn-status
                   yasnippet            ; powerful snippet mode
                   )
        do (add-to-list 'my:el-get-packages p)))

(setq my:el-get-packages
      (append
       my:el-get-packages
       (loop for src in el-get-sources collect (el-get-source-name src))))

;; install new packages and init already installed packages
(el-get 'sync my:el-get-packages)

;; on to the visual settings
(setq inhibit-splash-screen t)          ; no splash screen, thanks
(line-number-mode 1)                    ; have line numbers and
(column-number-mode 1)                  ; column numbers in the mode line
(setq visible-bell t)                   ; no noisy beep, just a visual one
(tool-bar-mode -1)                      ; no tool bar with icons
(scroll-bar-mode t)                     ; yes/no (t/-1) scroll bars
(unless (string-match "apple-darwin" system-configuration)
  ;; on mac, there's always a menu bar drawn, don't have it empty
  (menu-bar-mode -1))
(global-hl-line-mode  t)                ; do/don't (t/-1) highlight current line
(global-linum-mode 1)                   ; add line numbers on the left

(transient-mark-mode 1)                 ; highlight selected region

;;; paren-match
(show-paren-mode 1)                     ; parent matching
;;(setq show-paren-style 'mixed)
(setq show-paren-style 'parenthesis)


(blink-cursor-mode -1)                  ; no blinking cursor

;; frame size settings
(defun set-frame-size-according-to-resolution ()
  (interactive)
  (when (display-graphic-p)
    (progn
      ;; use 120 char wide window for largeish displays
      ;; and smaller 80 column windows for smaller displays
      ;; pick whatever numbers make sense for you
      (if (>= (x-display-pixel-width) 1280)
	  (add-to-list 'default-frame-alist (cons 'width 120))
	(add-to-list 'default-frame-alist (cons 'width 80)))
      ;; for the height, subtract a certain amount of pixels
      ;; from the screen height (for panels, menubars and
      ;; whatnot), then divide by the height of a char to
      ;; get the height we want
      (add-to-list 'default-frame-alist
		   (cons 'height (/ (- (x-display-pixel-height) 100)
				    (frame-char-height)))))))
;; set frame size both for initial frame and for the others
(add-hook 'after-init-hook            'set-frame-size-according-to-resolution)
;;(add-hook 'after-make-frame-functions 'set-frame-size-according-to-resolution)

;; my colors: see color-theme
(color-theme-solarized-dark)

;; my keybindings
(global-unset-key "g")
(global-set-key "g" (quote goto-line))
(global-set-key (kbd "C-k") 'kill-whole-line)

;; choose your own fonts, in a system dependant way
(if (string-match "apple-darwin" system-configuration)
    (set-face-font 'default "Monaco-13")
  (set-face-font 'default "Monospace-10"))
(global-font-lock-mode 1)               ; style text, always
(setq-default show-trailing-whitespace 't)

;; avoid compiz manager rendering bugs
(add-to-list 'default-frame-alist '(alpha . 100))

;; under mac, have Command as Meta and keep Option for localized input
(when (string-match "apple-darwin" system-configuration)
  (setq mac-allow-anti-aliasing t)
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'none))

;; Use the clipboard, pretty please, so that copy/paste "works"
(setq x-select-enable-clipboard t)

;; Navigate windows with M-<arrows>
(windmove-default-keybindings 'meta)
(setq windmove-wrap-around t)

; winner-mode provides C-<left> to get back to previous window layout
(winner-mode 1)

;; whenever an external process changes a file underneath emacs, and there
;; was no unsaved changes in the corresponding buffer, just revert its
;; content to reflect what's on-disk.
(global-auto-revert-mode 1)

;; M-x shell is a nice shell interface to use, let's make it colorful.  If
;; you need a terminal emulator rather than just a shell, consider M-x term
;; instead.
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; If you do use M-x term, you will notice there's line mode that acts like
;; emacs buffers, and there's the default char mode that will send your
;; input char-by-char, so that curses application see each of your key
;; strokes.
;;
;; The default way to toggle between them is C-c C-j and C-c C-k, let's
;; better use just one key to do the same.
(require 'term)
(define-key term-raw-map  (kbd "C-'") 'term-line-mode)
(define-key term-mode-map (kbd "C-'") 'term-char-mode)

;; Have C-y act as usual in term-mode, to avoid C-' C-y C-'
;; Well the real default would be C-c C-j C-y C-c C-k.
(define-key term-raw-map  (kbd "C-y") 'term-paste)

;; use ido for minibuffer completion
(require 'ido)
(ido-mode t)
(setq ido-save-directory-list-file "~/.emacs.d/.ido.last")
(setq ido-enable-flex-matching t)
(setq ido-use-filename-at-point 'guess)
(setq ido-show-dot-for-dired t)

;; default key to switch buffer is C-x b, but that's not easy enough
;;
;; when you do that, to kill emacs either close its frame from the window
;; manager or do M-x kill-emacs.  Don't need a nice shortcut for a once a
;; week (or day) action.
(global-set-key (kbd "C-x C-b") 'ido-switch-buffer)
;(global-set-key (kbd "C-x C-c") 'ido-switch-buffer)
(global-set-key (kbd "C-x B") 'ibuffer)

;; C-x C-j opens dired with the cursor right on the file you're editing
(require 'dired-x)

;; full screen
(defun fullscreen ()
  (interactive)
  (set-frame-parameter nil 'fullscreen
                       (if (frame-parameter nil 'fullscreen) nil 'fullboth)))
(global-set-key [f1] 'fullscreen)

;; python & Co.
(setq py-mode-map python-mode-map)

;; backup files & Co.
(defvar backup-dir (expand-file-name "~/.emacs.d/backup/"))
(defvar autosave-dir (expand-file-name "~/.emacs.d/autosave/"))
(setq backup-directory-alist (list (cons ".*" backup-dir)))
(setq auto-save-list-file-prefix autosave-dir)
(setq auto-save-file-name-transforms `((".*" ,autosave-dir t)))

;; ac-complete settings
;;;;;;;;;;;;;;;;;;;;;;;;
; Load the default configuration
(require 'auto-complete-config)
; Use dictionaries by default
(setq-default ac-sources (add-to-list 'ac-sources 'ac-source-dictionary))
(global-auto-complete-mode t)
; Start auto-completion after 2 characters of a word
(setq ac-auto-start 2)
; case sensitivity is important when finding matches
(setq ac-ignore-case nil)


;; yasnippet
;;;;;;;;;;;;;
;; Load the library
(require 'yasnippet)

;;(yas-global-mode 1)
;; per buffer yas-minor-mode (comment out yas-global-mode)
;;(yas-reload-all)
;;(add-hook 'javascript-mode-hook
;;          '(lambda ()
;;             (yas-minor-mode)))
(add-hook 'python-mode-hook
          '(lambda ()
             (yas-minor-mode)))

(require 'js2-mode)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

(setq js2-mode-hook
  '(lambda () (progn
    (set-variable 'indent-tabs-mode nil)
    (set-variable 'js2-bounce-indent-p t)
    (setq tab-width 3))))

;; js-comint
;;;;;;;;;;;;
(require 'js-comint)
;; Use node as our repl
(setq inferior-js-program-command "node")
(add-hook 'js2-mode-hook '(lambda ()
			    (local-set-key "\C-x\C-e" 'js-send-last-sexp)
			    (local-set-key "\C-\M-x" 'js-send-last-sexp-and-go)
			    (local-set-key "\C-cb" 'js-send-buffer)
			    (local-set-key "\C-c\C-b" 'js-send-buffer-and-go)
			    (local-set-key "\C-cl" 'js-load-file-and-go)
			    (local-set-key [return] 'newline-and-indent)
			    ))

(setq inferior-js-mode-hook
      (lambda ()
        ;; We like nice colors
        (ansi-color-for-comint-mode-on)
        ;; Deal with some prompt nonsense
        (add-to-list 'comint-preoutput-filter-functions
                     (lambda (output)
		       (replace-regexp-in-string ".*1G.*3G"        "> "    output)
		       )
		     )
        (add-to-list 'comint-preoutput-filter-functions
                     (lambda (output)
                       (replace-regexp-in-string ".*1G\.\.\..*5G"  "... "  output)
		       )
		     )
	)
      )

;; multi-web-mode
(require 'multi-web-mode)
(setq mweb-default-major-mode 'html-mode)
(setq mweb-tags '((php-mode "<\\?php\\|<\\? \\|<\\?=" "\\?>")
		  (js-mode "<script +\\(type=\"text/javascript\"\\|language=\"javascript\"\\)[^>]*>" "</script>")
		  (js-mode "<script[^>]*>" "</script>")
		  (css-mode "<style +type=\"text/css\"[^>]*>" "</style>")))
(setq mweb-filename-extensions '("php" "htm" "html" "ctp" "phtml" "php4" "php5"))
(multi-web-global-mode 1)


;; SLIME (via quicklisp)
(load (expand-file-name "~/quicklisp/slime-helper.el"))
;; Replace "sbcl" with the path to your implementation
(setq inferior-lisp-program "sbcl --noinform --no-linedit")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(js2-basic-offset 2))

;; pare-match and color
(require 'paren)
(set-face-background 'show-paren-match-face (face-background 'default))
(set-face-foreground 'show-paren-match-face "#859900")
(set-face-attribute 'show-paren-match-face nil :weight 'extra-bold)
(defadvice show-paren-function
      (after show-matching-paren-offscreen activate)
      "If the matching paren is offscreen, show the matching line in the
        echo area. Has no effect if the character before point is not of
        the syntax class ')'."
      (interactive)
      (if (not (minibuffer-prompt))
          (let ((matching-text nil))
            ;; Only call `blink-matching-open' if the character before point
            ;; is a close parentheses type character. Otherwise, there's not
            ;; really any point, and `blink-matching-open' would just echo
            ;; "Mismatched parentheses", which gets really annoying.
            (if (char-equal (char-syntax (char-before (point))) ?\))
                (setq matching-text (blink-matching-open)))
            (if (not (null matching-text))
                (message matching-text)))))

